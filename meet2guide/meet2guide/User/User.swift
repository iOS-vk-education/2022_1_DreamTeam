//
//  User.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 18.04.2022.
//

import Foundation
import UIKit
import Firebase

struct User {
    var name: String
    var surname: String
    var phone: String
    var email: String
    var image: UIImage
    var rating: Float
}

struct UserData {
    let email: String
    let name: String
    let surname: String
    let phone: String
    
    init(email: String, name: String, surname: String, phone: String) {
        self.email = email
        self.name = name
        self.surname = surname
        self.phone = phone
    }
    
    func toDictionary() -> Any {
        return ["email": email, "name": name, "surname": surname, "phone": phone]
    }
}

struct UserBase {
    let email: String
    let uid: String
    
    init(user: Firebase.User) {
        email = user.email ?? ""
        uid = user.uid
    }
}
