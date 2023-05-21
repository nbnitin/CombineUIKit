//
//  UserModel.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 06/04/23.
//

import Foundation


struct UserModel : Decodable {
    let id : Int?
    let name, username, email, phone, website : String?
    let address : Address?
    let company : Company?
    let albumDatas : [AlbumModel]?
}


struct Address : Decodable {
    let street, suite, city, zipcode : String?
    let geo : Geo?
}


struct Geo : Decodable {
    let lat, lng : String?
}

struct Company : Decodable {
    let name, catchPhrase, bs : String?
}
