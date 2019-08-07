//
//  NotificationApi.swift
//  Instagram
//
//  Created by Mobile Computing on 03/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase
class NotificationApi {
    var REF_NOTIFICATION = Database.database().reference().child("notification")
    
    func observeNotification(withId id: String,  completion: @escaping (Notification) -> Void){
        REF_NOTIFICATION.child(id).observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let newNoti = Notification.transform(dict: dict, key: snapshot.key)
                completion(newNoti)
            }
        })
    }
}
