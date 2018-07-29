//
//  ProductVC.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProductVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private var products = [Item]() {didSet{reloadDataSource()}}
    private var filteredProducts = [Item]() {didSet{tableView.reloadData()}}
    
    private var searchInProgress = false
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setUpSearchBar()
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
        observeProducts()
    }
    
    private func clear(){
        SVProgressHUD.dismiss()
        removeProductObservers()
    }
    
    private func observeProducts(){
        ItemSystem.system.addProductObserver(forEventType: .added) { (addedProducts, error) in
            guard let addedProducts = addedProducts, error == nil else{
                self.issueAlert(ofType: .dataRetrievalFailed)
                return
            }
            
            self.products.append(contentsOf: addedProducts)
        }
        ItemSystem.system.addProductObserver(forEventType: .removed) { (removedProducts, error) in
            guard let removedProducts = removedProducts, error == nil else{
                self.issueAlert(ofType: .dataRetrievalFailed)
                return
            }
            
            self.products = self.products.filter({ (product) -> Bool in
                for removedProduct in removedProducts{
                    if product.databaseID == removedProduct.databaseID { return false }
                }
                return true
            })
        }
        ItemSystem.system.addProductObserver(forEventType: .modified) { (modifiedProducts, error) in
            guard let modifiedProducts = modifiedProducts, error == nil else{
                self.issueAlert(ofType: .dataRetrievalFailed)
                return
            }
            
            self.products = self.products.filter({ (product) -> Bool in
                for modifiedProduct in modifiedProducts{
                    if product.databaseID == modifiedProduct.databaseID { return false }
                }
                return true
            })
            self.products.append(contentsOf: modifiedProducts)
        }
    }
    
    private func removeProductObservers(){
        ItemSystem.system.removeProductObservers()
    }
    
    private func setUpSearchBar(){
        searchBar.change(textFont: UIFont(name: "Avenir", size: 14))
        searchBar.placeholder = "Search for items you can buy"
    }
    
    private func reloadDataSource(){
        if searchInProgress{
            filteredProducts = products.filter({ (product) -> Bool in
                let name = product.name
                if name.contains(searchText) {
                    return true
                }
                if searchText == ""{
                    return true
                }
                return false
            })
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchInProgress = true
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchInProgress = false
        
        searchBar.resignFirstResponder()
        searchBar.text = nil
        searchBar.showsCancelButton = false
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInProgress = true
        self.searchText = searchText
        filteredProducts = products.filter({ (product) -> Bool in
            if product.name.contains(searchText) {
                return true
            }
            if searchText == ""{
                return true
            }
            return false
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchInProgress {
            return filteredProducts.count
        }
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NameFile.Cells.product, for: indexPath)
        

        if let cell = cell as? ProductCell{
            if searchInProgress{
                cell.product = filteredProducts[indexPath.row]
            }else{
                cell.product = products[indexPath.row]
            }
            cell.addBtn.addTarget(self, action: #selector(ProductVC.addProduct(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc private func addProduct(sender: UIButton){
        guard let cell = sender.superview?.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else{
            self.issueAlert(ofType: .requestFailed)
            return
        }
        
        var product = Item()
        if searchInProgress{
            product = filteredProducts[indexPath.row]
        }else{
            product = products[indexPath.row]
        }
        
        ItemSystem.system.addItem(product) { (error) in
            guard error == nil else{
                self.issueAlert(ofType: .requestFailed)
                return
            }

            self.performSegue(withIdentifier: NameFile.Segues.unwindToItems, sender: sender)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
