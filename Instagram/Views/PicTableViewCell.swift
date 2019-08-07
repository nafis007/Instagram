//
//  PicTableViewCell.swift
//  Instagram
//
//  Created by Mobile Computing on 19/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit
import Haneke
class PicTableViewCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    
    var pic:JSON?{
        didSet {
            self.setupPic()
        }
    }
    
    override func prepareForReuse() {
        self.picImageView.image = nil
    }
    
    func setupPic(){
        self.captionLabel.text = self.pic?["caption"]["text"].string
        if let urlString = self.pic?["images"]["standard_resolution"]["url"]{
            let url = NSURL(string:urlString.stringValue)
            self.picImageView.hnk_setImageFromURL(url! as URL)
            
        }
    } // Configure the view for the selected state
    

}
