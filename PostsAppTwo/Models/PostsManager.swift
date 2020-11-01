//
//  PostsManager.swift
//  PostsAppTwo
//
//  Created by Syimyk on 11/1/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PostsManagerDelegate {
    func didUpdatePost(_ postsManager : PostsManager,post: [PostModel])
    func didFailWithError(error : Error)
}


struct PostsManager {
    
    var delegate : PostsManagerDelegate?
    
    let postURL = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchPost(){
        performRequest(with : postURL)
    }
    
    func performRequest(with urlString : String){
        AF.request(urlString, method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                var posts =  [PostModel]()
                for item in json.prefix(30){
                    let id = item.1["id"].intValue
                    let title = item.1["title"].stringValue
                    let body = item.1["body"].stringValue
                    let post = PostModel(postId: id, postTitle: title, postBody: body)
                    posts.append(post)
                    self.delegate?.didUpdatePost(self, post: posts)
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
                
            }
            
        }
    }
}
