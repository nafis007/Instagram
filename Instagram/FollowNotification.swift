//
//  FollowNotification.swift
//  Instagram
//
//  Created by Mobile Computing on 04/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FollowNotificationApi {
    var REF_FOLLOWNOTIFICATION = Database.database().reference().child("follow_notification")
    
    func observeNotification(withId id: String,  completion: @escaping (Notification) -> Void){
        REF_FOLLOWNOTIFICATION.child(id).observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let newNoti = Notification.transform(dict: dict, key: snapshot.key)
                completion(newNoti)
            }
        })
    }
}
