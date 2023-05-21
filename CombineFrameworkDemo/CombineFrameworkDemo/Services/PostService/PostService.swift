//
//  PostService.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 10/04/23.
//

import Foundation
import Combine

class PostService {
    
    func getAllPosts(url: URL) -> AnyPublisher<[Posts],Error> {
        ServiceManager.shared.callApi(url: url, for: [Posts].self)
            .eraseToAnyPublisher()
    }
    
    func getPostDetails(url: URL) -> Future<Posts,Error> {
        return ServiceManager.shared.callApiUsingFuture(url: url, for: Posts.self)
    }
}
