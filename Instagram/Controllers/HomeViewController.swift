//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Mobile Computing on 26/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit
import SDWebImage
class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var users = [UserModel]()
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        //loadPosts()
        
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshHome(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        ////// for refreshing home page after editing profile//////////////////////
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadRequest(_:)), name: Notification.Name(rawValue: "reloadUserInfo"), object: nil)
        //var post = Post(captionText: "test", photoUrlString: "url1")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.posts.removeAll()
        self.users.removeAll()
        loadPosts()
        self.tableView.reloadData()
    }/*
    @objc func reloadRequest(_ notification: Notification) {
        self.posts.removeAll()
        self.users.removeAll()
        loadPosts()
        self.tableView.reloadData()
    }*/
    @objc private func refreshHome(_ sender: Any) {
        self.posts.removeAll()
        self.users.removeAll()
        loadPosts()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    func loadPosts(){
        self.activityIndicatorView.startAnimating()
        Api.Feed.observeFeed(withId: Api.User.CURRENT_USER!.uid) {
            (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.posts.insert(post, at: 0)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
            
        }
        Api.Feed.observeFeedRemoved(withId: Api.User.CURRENT_USER!.uid) {(post) in
            self.posts = self.posts.filter {$0.id != post.id}
            self.users = self.users.filter {$0.id != post.uid}
            self.tableView.reloadData()
            
        }
    }
    

    
    func fetchUser(uid: String, completed: @escaping () -> Void){
        
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completed()
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Home_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
        }
    }
}

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
