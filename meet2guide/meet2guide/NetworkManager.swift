//
//  NetworkManager.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 29.04.2022.
//

import Foundation
import Firebase

protocol NetworkManagerProtocol {
    func createUser(user: UserData, password: String, completion: @escaping (AuthResult) -> Void)
    
    func logOut()
    
    func addUserInDataBase(user: UserData)
}

final class NetworkManager {
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    private init() {}
}

enum AuthResult {
    case success
    case failure(Error)
}

extension NetworkManager: NetworkManagerProtocol {
    func createUser(user: UserData, password: String, completion: @escaping (AuthResult) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: password) { [weak self] result, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            self?.addUserInDataBase(user: user)
            completion(.success)
        }
    }
    
    func addUserInDataBase(user: UserData) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.setValue(user.toDictionary())
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
