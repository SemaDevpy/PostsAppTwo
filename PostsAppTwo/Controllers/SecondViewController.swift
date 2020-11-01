//
//  SecondViewController.swift
//  PostsAppTwo
//
//  Created by Syimyk on 11/1/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var postID = 0
    
    var commntsList = [CommentModel]()
    
    var commentsManager = CommentsManager()
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        commentsManager.delegate = self
        commentsManager.fetchComments(by: postID)
        
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
       showAlert()
    }
    
    func showAlert(){
         let alertView = UIAlertController(title: "Добавить комментарий", message: "", preferredStyle: .alert)
         
         alertView.addTextField(configurationHandler: nil)
         alertView.addTextField(configurationHandler: nil)
         alertView.addTextField(configurationHandler: nil)
         
         alertView.textFields![0].placeholder = "Введите заглавие комментария"
         alertView.textFields![1].placeholder = "Введите вашу почту"
         alertView.textFields![2].placeholder = "Введите комментарий"
         
         alertView.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { (_) in
             let theme = alertView.textFields![0].text!
             let email = alertView.textFields![1].text!
             let comment = alertView.textFields![2].text!
             var newComment = CommentModel(comName: theme, comEmail: email, comBody: comment)
             self.commntsList.append(newComment)
             DispatchQueue.main.async {
                 self.table.reloadData()
                 let indexPath = IndexPath(row: self.commntsList.count - 1, section: 0)
                 self.table.scrollToRow(at: indexPath, at: .top, animated: true)
             }
             
         }
             )
         )
         
         
         self.present(alertView, animated: true, completion: nil)
     }

}

//MARK: - UITableViewDataSource
extension SecondViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commntsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: K.secondVC.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Заглавие: \(commntsList[indexPath.row].comName)\nОт: \(commntsList[indexPath.row].comEmail)"
        cell.detailTextLabel?.text = commntsList[indexPath.row].comBody
        return cell
    }
    
    
}

//MARK: - CommentsManagerDelegate
extension SecondViewController : CommentsManagerDelegate {
    func didUpdateComment(_ commentManager: CommentsManager, comment: [CommentModel]) {
        commntsList = comment
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
