//
//  PostsViewModel.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 10/04/23.
//

import Foundation
import Combine


class PostViewModel {
    private let service = PostService()
    
    
    func getAllPosts() -> AnyPublisher<[Posts],Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return Fail(error: NSError(domain: "Missing Feed URL", code: -10001, userInfo: nil)).eraseToAnyPublisher()
        }
        return service.getAllPosts(url: url)
    }
}

//this below I am creating to show different use of combine into View Model Layer

class PostDetailsViewModel : ObservableObject {
    
    private let service = PostService()
    var cancellable : AnyCancellable!
    @Published var postDetails : Posts = Posts()
    
    func getPostDetails(_ postId : Int) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)") else {
            print( Fail<Any, NSError>(error: NSError(domain: "Missing Feed URL", code: -10001, userInfo: nil)) )
            return
        }
    
        cancellable = service.getPostDetails(url: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("Error", error.localizedDescription)
                }
            } receiveValue: {  postDetails in
                self.postDetails = postDetails
                print(self.postDetails, "vm")
            }

    }
    
    
    
}
