//
//  PicViewController.swift
//  Instagram
//
//  Created by Mobile Computing on 19/10/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit
import Alamofire



class PicViewController: UIViewController, UITableViewDataSource  {
    var accessToken = ""
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "picCell") as! PicTableViewCell
        cell.pic = self.results?[indexPath.row]
        return cell
    }
    
    var results: [JSON]? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPics()
    }
    
    func loadPics(){
        let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)"
        Alamofire.request(url, method: .get).responseJSON(completionHandler: { (response) in
            let json = response.result.value as? [String:Any]
            if(json != nil){
                var jsonObj = JSON(json!)
                if let data = jsonObj["data"].arrayValue as [JSON]?{
                    self.results = data
                    self.tableView.reloadData()
                    
                }
            }
        })
    }

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
