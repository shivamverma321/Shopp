//
//  ProductCell.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: AsyncImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    var product = Item() {didSet{reloadData()}}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImageView.layer.masksToBounds = true
        productImageView.layer.cornerRadius = 10
        
        addBtn.layer.masksToBounds = true
        addBtn.layer.cornerRadius = addBtn.frame.width/2
    }
    
    private func reloadData(){
        nameLabel.text = product.name
        descriptionLabel.text = product.description
        priceLabel.text = product.price.dollarCurrency()
        productImageView.setFirebaseURL(firebaseURL: product.imageURL)
    }
    
}

//
//  ItemCell.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: AsyncImageView!
    
    var item = Item() {didSet{reloadData()}}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImageView.layer.masksToBounds = true
        itemImageView.layer.cornerRadius = 10
    }
    
    private func reloadData(){
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = item.price.dollarCurrency()
        itemImageView.setFirebaseURL(firebaseURL: item.imageURL)
    }
    
}

//
//  Item.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import UIKit

class Item{
    
    var databaseID: String
    
    var type: ItemType
    
    var name: String
    var description: String
    var price: Double
    var imageURL: String
    
    init(databaseID: String, type: ItemType, name: String, description: String, price: Double, imageURL: String) {
        self.databaseID = databaseID
        self.type = type
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = imageURL
    }
    
    init() {
        self.databaseID = ""
        self.type = .none
        self.name = ""
        self.description = ""
        self.price = 0.00
        self.imageURL = ""
    }
    
}

enum ItemType{
    case grocery
    case clothing
    case pharmacy
    case none
}
