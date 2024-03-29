//
//  Comment.swift
//  Instagram
//
//  Created by Mobile Computing on 29/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation

class Comment{
    var commentText: String?
    var uid: String?
}
extension Comment{
    static func transformComment(dict:[String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
