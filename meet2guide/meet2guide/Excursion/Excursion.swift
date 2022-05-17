//
//  Excursion.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 16.05.2022.
//

import Foundation
import UIKit

struct ExcursionData {
    var name: String
    var date: String
    var address: String
    var description: String?
    var image: UIImage?
    var imageName: String
    var addedByUser: String
    
    init(name: String, date: String, address: String, description: String?, image: UIImage, userId: String = "") {
        self.name = name
        self.date = date
        self.address = address
        self.description = description
        self.image = image
        self.imageName = ""
        self.addedByUser = userId
    }
    
    func toDictionary() -> Any {
        return ["name": name, "date": date, "address": address, "description": description, "image_name": imageName, "user_id": addedByUser]
    }
}
