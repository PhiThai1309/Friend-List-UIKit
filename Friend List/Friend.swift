//
//  Friend.swift
//  Friend List
//
//  Created by phi.thai on 3/6/23.
//

import Foundation

struct Friend: Codable {
    var id: integer_t
    var name: String
    var email: String
    var gender: String
    var status: String
    
    init(id: integer_t, name: String, email: String, gender: String, status: String) {
        self.id = id
        self.name = name
        self.email = email
        self.gender = gender
        self.status = status
    }
}
