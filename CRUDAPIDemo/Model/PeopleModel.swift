//
//  PeopleModel.swift
//  CRUDAPIDemo
//
//  Created by Shubham Kumar on 01/02/22.
//

import Foundation

struct PeopleModel: Codable {
    let data:[People]
}

struct People: Codable, Identifiable, Equatable {
    var id: Int?
    let first_name: String
    let last_name: String
    let age : String
    let active_date: String
    let created_at: String
    let updated_at:String
}
