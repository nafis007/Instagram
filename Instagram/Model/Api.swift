//
//  Api.swift
//  Instagram
//
//  Created by Mobile Computing on 30/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import Foundation
struct Api {
    static var User = UserApi()
    static var Post = PostApi()
    static var Comment = CommentApi()
    static var Post_Comment = Post_CommentApi()
    static var MyPosts = MyPostsApi()
    static var Follow = FollowApi()
    static var Feed = FeedApi()
    static var HashTag = HashTagApi()
    static var Notification = NotificationApi()
    static var FollowNotification = FollowNotificationApi()
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static let INSTAGRAM_CLIENT_ID  = "e98a00ff3a344e3698998a763b3f698d"
    
    static let INSTAGRAM_CLIENTSERCRET = "3d4a79d1e82d40479ad045eb69224298"
    
    static let INSTAGRAM_REDIRECT_URI = "http://miaoyensheng.com"
    
    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
    
    static let INSTAGRAM_SCOPE = "likes+comments+relationships"
    
}
