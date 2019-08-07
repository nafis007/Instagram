//
//  HelperService.swift
//  Instagram
//
//  Created by Mobile Computing on 30/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
class HelperService {
    static func uploadDataToServer(data: Data, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void){
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoIdString)
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: {(myUrl,error) in
                let photoUrl = myUrl?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!, ratio: ratio, caption: caption, onSuccess: onSuccess)
            })
        }
        }
        static func sendDataToDatabase(photoUrl: String, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void){
            let newPostId = Api.Post.REF_POSTS.childByAutoId().key
            let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
            
            guard let currentUser = Api.User.CURRENT_USER else{
                return
            }
            /*
            let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            for var word in words{
                if word.hasPrefix("#"){
                    word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                    let newHashTagRef = Api.HashTag.REF_HASHTAG.child(word.lowercased())
                    newHashTagRef.child(newPostId!).setValue(true)
                }
            }*/
            let currentUserId = currentUser.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            
            newPostReference.setValue(["uid": currentUserId,"photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio, "timestamp": timestamp], withCompletionBlock: {(error, ref) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId!).setValue(true)
                Api.Follow.REF_FOLLOWERS.child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
                    snapshot in
                    let arraySnapshot = snapshot.children.allObjects as! [DataSnapshot]
                    arraySnapshot.forEach({(child) in
                        Api.Feed.REF_FEED.child(child.key).child(newPostId!).setValue(true)
                        let newNotificationId = Api.Notification.REF_NOTIFICATION.child(child.key).childByAutoId().key
                        let newNotificationReference = Api.Notification.REF_NOTIFICATION.child(child.key).child(newNotificationId!)
                        newNotificationReference.setValue(["from": Api.User.CURRENT_USER!.uid, "type":"feed", "objectId":newPostId!, "time": timestamp])
                    })
                })
                let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
                myPostRef.setValue(true, withCompletionBlock: {(error, ref) in
                    if error != nil {
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                    }
                })
                ProgressHUD.showSuccess("Success")
                
                onSuccess()
            })
            
        }
}
