//
//  PostApi.swift
//  Instagram
//
//  Created by Mobile Computing on 30/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded){(snapshot:DataSnapshot)  in
            if let dict = snapshot.value as? [String: Any]{
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    func observePost(withId id: String, completion: @escaping (Post) -> Void){
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    func observeTopPosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapShot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapShot.forEach({(child) in
                if let dict = child.value as? [String: Any]{
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                }
            })
        })
    }
    func observeLikeCount(withPostId id: String, completion:  @escaping (Int) -> Void){
        REF_POSTS.child(id).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                completion(value)
            }
        })
    }
    func incrementLikes(postId: String, onSucess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        let postRef = Api.Post.REF_POSTS.child(postId)
        var dislike = 0
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Api.User.CURRENT_USER?.uid {
                var likes: Dictionary<String, Bool>
                
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                    dislike = 1
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            let timestamp = Int(Date().timeIntervalSince1970)
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
                onSucess(post)
                if dislike == 1 {
                    let newNotificationId = Api.Notification.REF_NOTIFICATION.child(post.uid!).childByAutoId().key
                    let newNotificationReference = Api.Notification.REF_NOTIFICATION.child(post.uid!).child(newNotificationId!)
                    newNotificationReference.setValue(["from": Api.User.CURRENT_USER!.uid, "type":"like", "objectId":post.id!, "time": timestamp])
                }
                
                
            }
        }
    }
}
