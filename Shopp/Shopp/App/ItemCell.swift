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
