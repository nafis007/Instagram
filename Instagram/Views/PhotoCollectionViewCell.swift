//
//  PhotoCollectionViewCell.swift
//  Instagram
//
//  Created by Mobile Computing on 30/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    var post : Post? {
        didSet {
            updateView()
        }
    }
    func updateView(){
        if let photoUrlString = post?.photoUrl{
            let photoUrl = URL(string: photoUrlString)
            photo.sd_setImage(with: photoUrl)
        }
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
        
    }
    
    @objc func photo_TouchUpInside() {
        if let id = post?.id {
            delegate?.goToDetailVC(postId: id)
        }
    }
    
}
