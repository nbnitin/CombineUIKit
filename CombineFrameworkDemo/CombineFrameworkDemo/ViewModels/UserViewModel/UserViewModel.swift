//
//  UserViewModel.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 10/04/23.
//

import Foundation
import Combine

class UserViewModel {
    
    func getUserData() -> AnyPublisher<[UserModel], Error> {
        UserService.shared.getUserData()
            .eraseToAnyPublisher()
    }
}
