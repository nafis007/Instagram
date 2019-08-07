//
//  ActivityViewController.swift
//  InstagramClone
//
//  Created by Mobile Computing on 26/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notifications = [Notification]()
    var users = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotifications()
        // Do any additional setup after loading the view.
    }
    
    func loadNotifications(){
        guard let currentUser = Api.User.CURRENT_USER else{
            return
        }
        Api.Notification.observeNotification(withId: currentUser.uid, completion: {
            notification in
            guard let uid = notification.from else {
                return
            }
            self.fetchUser(uid: uid, completed: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
            
        })
    }
    func fetchUser(uid: String, completed: @escaping () -> Void){
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completed()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Activity_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
        
    }
    
}
extension ActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension ActivityViewController: ActivityTableViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "Activity_DetailSegue", sender: postId)
    }
}
