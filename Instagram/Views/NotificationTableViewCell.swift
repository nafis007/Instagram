//
//  NotificationTableViewCell.swift
//  Instagram
//
//  Created by Mobile Computing on 04/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit
protocol NotificationTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}
class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    

    @IBOutlet weak var descriptionLabel: UILabel!
    var delegate: NotificationTableViewCellDelegate?
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
        case "follow":
            descriptionLabel.text = "started following you"
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
            delegate?.goToProfileUserVC(userId: id)
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
