//
//  ViewController.swift
//  PostsAppTwo
//
//  Created by Syimyk on 11/1/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController{
    
    var postsManager = PostsManager()
    
    @IBOutlet weak var table: UITableView!
    
    var postsList = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        postsManager.delegate = self
        postsManager.fetchPost()
    }
    
    
}

//MARK: - UITableViewDataSource
extension FirstViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = postsList[indexPath.row].postTitle
        cell.detailTextLabel?.text = postsList[indexPath.row].postBody
        return cell
    }
    
    
}

extension FirstViewController : PostsManagerDelegate{
    func didUpdatePost(_ postsManager: PostsManager, post: [PostModel]) {
        postsList = post
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
