//
//  FollowApi.swift
//  Instagram
//
//  Created by Mobile Computing on 01/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id: String){
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                for key in dict.keys{
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        Api.Follow.REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
        print("Hello")
        let timestamp = Int(Date().timeIntervalSince1970)
        let newNotificationId = Api.FollowNotification.REF_FOLLOWNOTIFICATION.child(id).child(Api.User.CURRENT_USER!.uid).key
        let newNotificationReference = Api.FollowNotification.REF_FOLLOWNOTIFICATION.child(id).child(newNotificationId!)
        newNotificationReference.setValue(["from": Api.User.CURRENT_USER!.uid, "type":"follow", "objectId": Api.User.CURRENT_USER!.uid, "time": timestamp])
    }
    func unFollowAction(withUser id: String){
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                for key in dict.keys{
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
        Api.Follow.REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void){
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull{
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    
    func fetchCountFollowing(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    func fetchCountFollowers(userId: String, completion: @escaping (Int) -> Void) {
        REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
}
