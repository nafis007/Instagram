//
//  FeedApi.swift
//  Instagram
//
//  Created by Mobile Computing on 01/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FeedApi{
    var REF_FEED = Database.database().reference().child("feed")
    
    func observeFeed(withId id: String,  completion: @escaping (Post) -> Void){
        REF_FEED.child(id).queryOrdered(byChild: "timestamp").observe(.childAdded, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: {
                (post) in
                completion(post)
            })
        })
    }
    
    func observeFeedRemoved(withId id: String, completion: @escaping (Post) -> Void){
        REF_FEED.child(id).observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
}
