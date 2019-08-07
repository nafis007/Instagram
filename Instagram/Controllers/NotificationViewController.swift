//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Mobile Computing on 04/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

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
        Api.FollowNotification.observeNotification(withId: currentUser.uid, completion: {
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
       
        if segue.identifier == "Notification_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
        }
    }

}
extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension NotificationViewController: NotificationTableViewCellDelegate {
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Notification_ProfileSegue", sender: userId)
    }
}
