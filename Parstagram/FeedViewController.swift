//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Nelson  on 10/1/22.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    let myRefreshControl = UIRefreshControl()
    var numberofPosts: Int?
    var totalNumofPosts: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "instagram_logo.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        myRefreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        myRefreshControl.tintColor = .white
        myRefreshControl.transform = CGAffineTransform(scaleX: 1.25,y: 1.25)
        tableView.refreshControl = myRefreshControl
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getPosts()
        }
    
    @objc func getPosts(){
        
        numberofPosts = 10
        print(numberofPosts as Any)
        let query = PFQuery(className:"Posts")
        query.includeKey("user")
        query.limit = numberofPosts!
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                query.countObjectsInBackground{ (count: Int32, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else{
                        self.totalNumofPosts = Int(count)
                        print(self.totalNumofPosts as Any)
                    }
                }
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    func getMorePosts(){
        
        numberofPosts = numberofPosts! + 10
        print(numberofPosts as Any)
        let query = PFQuery(className:"Posts")
        query.includeKey("user")
        query.limit = numberofPosts!
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                query.countObjectsInBackground{ (count: Int32, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else{
                        self.totalNumofPosts = Int(count)
                        print(self.totalNumofPosts as Any)
                    }
                }
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row < (totalNumofPosts ?? 10) - 1{
            if indexPath.row + 1 == posts.count {
                        getMorePosts()
                    }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]

        let user = post["user"] as! PFUser
        
        cell.usernameLabel.text = "\(user.username ?? " "):"
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
