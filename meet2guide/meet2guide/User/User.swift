//
//  User.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 18.04.2022.
//

import Foundation
import UIKit
import Firebase

struct UserData {
    let email: String
    let name: String
    let surname: String
    let phone: String
    var profileImageName: String
    var profileImage: UIImage?
    var rating: Float
    
    init(email: String, name: String, surname: String, phone: String, image: UIImage? = nil) {
        self.email = email
        self.name = name
        self.surname = surname
        self.phone = phone
        self.profileImageName = ""
        self.profileImage = image
        self.rating = 0.0
    }
    
    init(snapshot: FirebaseDatabase.DataSnapshot) {
        let value = snapshot.value as! [String: AnyObject]
        email = value["email"] as! String
        name = value["name"] as! String
        surname = value["surname"] as! String
        phone = value["phone"] as! String
        profileImageName = value["image_name"] as! String
        self.rating = 0.0
    }
    
    func toDictionary() -> Any {
        return ["email": email, "name": name, "surname": surname, "phone": phone, "image_name": profileImageName]
    }
    
    init(name: String, surname: String, phone: String, email: String, image: UIImage, rating: Float) {
        self.name = name
        self.surname = surname
        self.phone = phone
        self.email = email
        self.profileImage = image
        self.profileImageName = ""
        self.rating = rating
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
