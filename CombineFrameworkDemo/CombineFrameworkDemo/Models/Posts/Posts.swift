//
//  Posts.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 10/04/23.
//

import Foundation
import Combine

class Posts : Decodable, ObservableObject {
    @Published var isRead : Bool = false
    
    let userId : Int?
    let id : Int?
    let title : String?
    let body : String?
    
    enum CodingKeys : String, CodingKey {
        case  userId
        case id
        case title
        case body
    }
    
    
    required init(from decoder: Decoder) throws {
        let decode = try? decoder.container(keyedBy: CodingKeys.self)
        userId = try decode?.decodeIfPresent(Int.self, forKey: .userId)
        id = try decode?.decodeIfPresent(Int.self, forKey: .id)
        title = try decode?.decodeIfPresent(String.self, forKey: .title)
        body = try decode?.decodeIfPresent(String.self, forKey: .body)
    }
    
    
    init(userId: Int?, id: Int?, title: String?, body: String?) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
    init() {
        self.userId = nil
        self.id = nil
        self.title = nil
        self.body = nil
    }
}
