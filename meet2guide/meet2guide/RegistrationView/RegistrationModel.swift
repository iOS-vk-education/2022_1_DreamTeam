//
//  RegistrationModel.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 29.04.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol RegistrationModelProtocol {
    func createUser(user: UserData, password: String, completion: @escaping (AuthResult) -> Void)
}


class RegistrationModel {
    var user: UserData?
    
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    
}

extension RegistrationModel: RegistrationModelProtocol {
    func createUser(user: UserData, password: String, completion: @escaping (AuthResult) -> Void) {
        networkManager.createUser(user: user, password: password) { result in
            completion(result)
        }
    }
}
