//
//  UserService.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 10/04/23.
//

import Foundation
import Combine

class UserService {
    
    static let shared = UserService()
    var cancellables =  Set<AnyCancellable>()
    var posts = [UserModel]()
    
    func getUserData() -> AnyPublisher<[UserModel], Error> {
        guard let request = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return Fail(error: NSError(domain: "Missing Feed URL", code: -10001, userInfo: nil)).eraseToAnyPublisher()
        }
        
        //return ServiceManager.shared.getUserData(url: request!)
          //  .eraseToAnyPublisher()
        
        return ServiceManager.shared.callApi(url: request, for: [UserModel].self)
       
        
        
//        return ServiceManager.shared.callAPI(request!, for: [UserModel].self)
//            .map(\.value.)
            
            
    }
}
