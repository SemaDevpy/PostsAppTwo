//
//  CommentsManager.swift
//  PostsAppTwo
//
//  Created by Syimyk on 11/1/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol CommentsManagerDelegate {
    func didUpdateComment(_ commentManager : CommentsManager,comment: [CommentModel])
    func didFailWithError(error : Error)
}

struct CommentsManager {
    
    var delegate : CommentsManagerDelegate?
    
    let commentURL = "https://jsonplaceholder.typicode.com/comments?postId="
    
    func fetchComments(by id : Int){
        let urlString = "\(commentURL)\(id)"
        performRequest(with : urlString)
    }
    
    func performRequest(with urlString : String){
        AF.request(urlString, method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                var comments =  [CommentModel]()
                for item in json.prefix(30){
                    let name = item.1["name"].stringValue
                    let email = item.1["email"].stringValue
                    let body = item.1["body"].stringValue
                    let comment = CommentModel(comName: name, comEmail: email, comBody: body)
                    comments.append(comment)
                    self.delegate?.didUpdateComment(self, comment: comments)
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
            
        }
    }
    
}
