//
//  Excursion.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 16.05.2022.
//

import Foundation
import UIKit
import Firebase
import YandexMapsMobile

struct ExcursionData {
    var id: String
    var name: String
    var date: String
    var address: String
    var description: String?
    var image: UIImage?
    var imageName: String
    var addedByUser: String
    var rating: Float
    var price: String
    var latitude: Double?
    var longtitude: Double?
    
    init(name: String, date: String, address: String, description: String?, image: UIImage, price: String, coords: YMKPoint?, userId: String = "") {
        self.name = name
        self.date = date
        self.address = address
        self.description = description
        self.image = image
        self.imageName = ""
        self.addedByUser = userId
        self.id = ""
        self.rating = 0.0
        self.price = price
        if let coord = coords {
            latitude = coord.latitude
            longtitude = coord.longitude
        }
    }
    
    init(snapshot: FirebaseDatabase.DataSnapshot) {
        let value = snapshot.value as! [String: AnyObject]
        id = value["id"] as! String
        name = value["name"] as! String
        date = value["date"] as! String
        address = value["address"] as! String
        description = value["description"] as! String
        imageName = value["image_name"] as! String
        addedByUser = value["user_id"] as! String
        rating = 0
        price = value["price"] as! String
        let lat = value["latitude"] as? String
        if let lat = lat {
            latitude = Double(lat)
        }
        let long = value["longtitude"] as? String
        if let long = long {
            longtitude = Double(long)
        }
        //rating = value["rating"] as! Float
    }
    
    func toDictionary() -> Any {
        var strLatitude = ""
        if let latitude = latitude {
            strLatitude = String(latitude)
        } else {
            strLatitude = ""
        }
        
        var strLongtitude = ""
        if let longtitude = longtitude {
            strLongtitude = String(longtitude)
        } else {
            strLongtitude = ""
        }
        return ["id": id,
                "name": name,
                "date": date,
                "address": address,
                "description": description,
                "image_name": imageName,
                "user_id": addedByUser,
                "rating": String(rating),
                "price": price,
                "latitude": strLatitude,
                "longtitude": strLongtitude]
    }
}
