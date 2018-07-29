//
//  ViewController.swift
//  Shopp
//
//  Created by Shivam Verma on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import UIKit
import SVProgressHUD
import ESPullToRefresh

class ItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var yourItemsLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var profileImageView: AsyncImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var noItemsLabel: UILabel!
    @IBOutlet weak var noItemsDescriptionLabel: UILabel!
    @IBOutlet weak var noItemsAddItemBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var searchInProgress = false
    private var searchText = ""
    
    private var addItemBtn = UIButton()
    private var fadeView = GradientView()
    
    private var items = [Item]() {
        didSet{
            let addText = (items.count == 1) ? "Item" : "Items"
            itemCountLabel.text = items.count.withCommas() + " " + addText
            reloadDataSource()
        }
    }
    private var filteredItems = [Item]() {didSet{tableView.reloadData()}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        noItemsAddItemBtn.layer.masksToBounds = true
        noItemsAddItemBtn.layer.cornerRadius = noItemsAddItemBtn.frame.size.width/10
        
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 1

        noItemsLabel.isHidden = true
        noItemsDescriptionLabel.isHidden = true
        noItemsAddItemBtn.isHidden = true
        noItemsAddItemBtn.addTarget(self, action: #selector(ItemsVC.segueToProducts(sender:)), for: .touchUpInside)
        
        setUpSearchBar()
        setUpFadeView()
        setUpAddItemBtn()
        setUpRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileImageView.image = AppStorage.User.profileImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clear()
    }
    
    
    private func setUp(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        observeItems()
    }
    
    private func clear(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        items.removeAll()
        SVProgressHUD.dismiss()
        removeItemObservers()
    }
    
    private func observeItems(){
        ItemSystem.system.addItemObserver(forEventType: .added) { (addedItems, error) in
            guard let addedItems = addedItems, error == nil else{
                self.issueAlert(ofType: .dataRetrievalFailed)
                return
            }
            
            self.items.append(contentsOf: addedItems)
        }
        ItemSystem.system.addItemObserver(forEventType: .removed) { (removedItems, error) in
            guard let removedItems = removedItems, error == nil else{
                self.issueAlert(ofType: .dataRetrievalFailed)
                return
            }
            
            self.items = self.items.filter({ (item) -> Bool in
                for removedItem in removedItems{
                    if item.databaseID == removedItem.databaseID { return false }
                }
                return true
            })
        }
        ItemSystem.system.addItemObserver(forEventType: .modified) { (modifiedItems, error) in
            guard let modifiedItems = modifiedItems, error == nil else{
                self.issueAlert(ofType: .dataRetrievalFailed)
                return
            }
            
            self.items = self.items.filter({ (item) -> Bool in
                for modifiedItem in modifiedItems{
                    if item.databaseID == modifiedItem.databaseID { return false }
                }
                return true
            })
            self.items.append(contentsOf: modifiedItems)
        }
    }
    
    private func removeItemObservers(){
        ItemSystem.system.removeItemObservers()
    }
    
    private func showOrHideViews(){
        noItemsLabel.isHidden = true
        noItemsDescriptionLabel.isHidden = true
        noItemsAddItemBtn.isHidden = true
        addItemBtn.isHidden = false
        fadeView.isHidden = false
        
        print(items.count)
        if items.count == 0 && !searchInProgress{
            print("not workiing")
            noItemsLabel.isHidden = false
            noItemsDescriptionLabel.isHidden = false
            noItemsAddItemBtn.isHidden = false
            addItemBtn.isHidden = true
            fadeView.isHidden = true
        }
        
        if searchInProgress{
            addItemBtn.isHidden = true
            fadeView.isHidden = true
        }
 
    }
    
    private func setUpFadeView(){
        
        let width: CGFloat = view.frame.size.width
        let height: CGFloat = 200
        
        fadeView = GradientView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        fadeView.startColor = UIColor.clear
        fadeView.middleColor = UIColor.white.withAlphaComponent(0.1)
        fadeView.endColor = UIColor.white
        fadeView.backgroundColor = UIColor.clear
        fadeView.isUserInteractionEnabled = false
        
        view.addSubview(fadeView)
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.size.height{
            fadeView.frame = CGRect(x: view.frame.midX-fadeView.frame.size.width/2.0, y: view.frame.maxY-tabBarHeight-fadeView.frame.size.height, width: width, height: height)
        }
    }
    
    private func setUpAddItemBtn(){
        
        let width: CGFloat = 150
        let height: CGFloat = 55
        
        addItemBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        addItemBtn.backgroundColor = UIColor(red: 234/255, green: 113/255, blue: 89/255, alpha: 1)
        addItemBtn.setTitle("Add Item", for: .normal)
        addItemBtn.titleLabel?.font = UIFont(name: "Avenir", size: 15)
        addItemBtn.layer.masksToBounds = true
        addItemBtn.layer.cornerRadius = width/8.0
        
        view.addSubview(addItemBtn)
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.size.height{
            addItemBtn.frame = CGRect(x: view.frame.midX-addItemBtn.frame.size.width/2.0, y: view.frame.maxY-tabBarHeight-addItemBtn.frame.size.height-20.0, width: width, height: height)
            addItemBtn.addTarget(self, action: #selector(ItemsVC.segueToProducts(sender:)), for: .touchUpInside)
        }
    }
    
    private func setUpSearchBar(){
        searchBar.change(textFont: UIFont(name: "Avenir", size: 14))
        searchBar.placeholder = "Search your items"
    }
    
    private func setUpRefresh(){
        tableView.es.addPullToRefresh {
            self.tableView.es.stopPullToRefresh()
            SVProgressHUD.show()
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
    }
    
    private func reloadDataSource(){
        if searchInProgress{
            filteredItems = items.filter({ (item) -> Bool in
                let name = item.name
                if name.contains(searchText) {
                    return true
                }
                if searchText == ""{
                    return true
                }
                return false
            })
        }
        
        showOrHideViews()
        tableView.reloadData()
    }
    
    private var previousOffset: CGFloat = 1
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        noItemsLabel.frame.origin.y += previousOffset - scrollView.contentOffset.y
        noItemsDescriptionLabel.frame.origin.y += previousOffset - scrollView.contentOffset.y
        noItemsAddItemBtn.frame.origin.y += previousOffset - scrollView.contentOffset.y
        
        previousOffset = scrollView.contentOffset.y
    }
 
 
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchInProgress = true
        
        searchBar.showsCancelButton = true
        showOrHideViews()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchInProgress = false
        
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchBar.showsCancelButton = false
        showOrHideViews()
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInProgress = true
        self.searchText = searchText
        filteredItems = items.filter({ (item) -> Bool in
            if item.name.contains(searchText) {
                return true
            }
            if searchText == ""{
                return true
            }
            return false
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchInProgress {
            return filteredItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NameFile.Cells.item, for: indexPath)
        
        if searchInProgress{
            if let cell = cell as? ItemCell{
                cell.item = filteredItems[indexPath.row]
            }
        }
        
        if let cell = cell as? ItemCell{
            cell.item = items[indexPath.row]
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            var removeID = ""
            if searchInProgress{
                removeID = filteredItems[indexPath.row].databaseID
            }else{
                removeID = items[indexPath.row].databaseID
            }

            ItemSystem.system.deleteItem(withDatabaseID: removeID) { (error) in
                if error != nil{
                    self.issueAlert(ofType: .requestFailed)
                }
            }
            
        }
    }
    
    @objc private func segueToProducts(sender: Any?){
        performSegue(withIdentifier: NameFile.Segues.toProductVC, sender: sender)
    }
    
    @IBAction func unwindToItems(segue: UIStoryboardSegue) {
        print("unwinding")
    }
    
    
}

