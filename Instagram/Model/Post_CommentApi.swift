//
//  Post_CommentApi.swift
//  Instagram
//
//  Created by Mobile Computing on 30/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
import FirebaseDatabase
class Post_CommentApi {
    var REF_POST_COMMENTS = Database.database().reference().child("post-comments")
    
    
    /* func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    } */
}
