//
//  ActivityTableViewCell.swift
//  Instagram
//
//  Created by Mobile Computing on 03/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit
protocol ActivityTableViewCellDelegate {
    func goToDetailVC(postId: String)
    //func goToProfileVC(userId: String)
}

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var delegate: ActivityTableViewCellDelegate?
    var notification: Notification?{
        didSet{
            updateView()
        }
    }
    var user: UserModel?{
        didSet{
            setupUserInfo()
        }
    }
    func updateView(){
        switch notification!.type! {
        case "feed":
            descriptionLabel.text = "added a new post"
            let postId = notification!.objectId!
            Api.Post.observePost(withId: postId, completion: {(post) in
                if let photoUrlString = post.photoUrl{
                    let photoUrl = URL(string: photoUrlString)
                    self.photo.sd_setImage(with: photoUrl, placeholderImage: UIImage(named:"placeholderImg"))
                }
            })
        case "like":
            descriptionLabel.text = "Liked your Post"
            let postId = notification!.objectId!
            Api.Post.observePost(withId: postId, completion: {(post) in
                if let photoUrlString = post.photoUrl{
                    let photoUrl = URL(string: photoUrlString)
                    self.photo.sd_setImage(with: photoUrl, placeholderImage: UIImage(named:"placeholderImg"))
                }
            })
        default:
            print()
        }
        
        if let timestamp = notification?.timestamp{
            
            let timeestampDate = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timeestampDate, to: now)
            var timeText = ""
            if diff.second! <= 0{
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute! ==  0 {
                timeText =  "\(diff.second!)s"
            }
            if diff.minute! > 0 && diff.hour! ==  0 {
                timeText = "\(diff.minute!)m"
            }
            if diff.hour! > 0 && diff.day! ==  0 {
                timeText =  "\(diff.hour!)h"
            }
            if diff.day! > 0 && diff.weekOfMonth! ==  0 {
                timeText = "\(diff.day!)d"
            }
            if diff.weekOfMonth! > 0 {
                timeText =  "\(diff.weekOfMonth!)w"
            }
            
            timeLabel.text = timeText
        }
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.cell_TouchUpInside))
        addGestureRecognizer(tapGestureForPhoto)
        isUserInteractionEnabled = true
    }
    @objc func cell_TouchUpInside(){

        if let id = notification?.objectId {
            delegate?.goToDetailVC(postId: id)
        }
    }
    func setupUserInfo(){
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl{
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named:"placeholderImg"))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
