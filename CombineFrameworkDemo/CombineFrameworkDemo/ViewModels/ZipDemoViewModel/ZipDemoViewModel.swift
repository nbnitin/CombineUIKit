//
//  ZipDemoViewModel.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 22/04/23.
//

import Foundation
import Combine


class ZipDemoViewModel {
    
    private let service = ServiceManager()

    
    func getAllUsers() -> Future<[UserModel], Error> {
        service.callApiUsingFuture(url: URL(string: "https://jsonplaceholder.typicode.com/users")!, for: [UserModel].self)
            
    }
    
    func getAllAlbums() -> Future<[AlbumModel], Error> {
        service.callApiUsingFuture(url: URL(string: "https://jsonplaceholder.typicode.com/albums")!, for: [AlbumModel].self)
    }
   
}
