//
//  ViewController.swift
//  Shopp
//
//  Created by Shivam Verma on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import UIKit

class ItemRepoVC: UIViewController {
    
    @IBOutlet weak var yourItemsLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var inventoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

