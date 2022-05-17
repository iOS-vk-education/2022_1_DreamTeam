//
//  NetworkManager.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 29.04.2022.
//

import Foundation
import Firebase

protocol NetworkManagerProtocol {
    func createUser(user: UserData, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func logOut()
    
    func addUserInDataBase(user: UserData)
    
    func getUser(completion: @escaping (Result<UserData, Error>) -> Void)
    
    func imageLoad(image: UIImage?)
    
    func updateUser(user: UserData)
    
    func saveUser(user: UserData)
    
    func checkUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func addExcursion(excursion: ExcursionData)
}

final class NetworkManager {
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    let imageLoader = ImageLoader.shared
    
    private var userData: UserData?
    
    private var excursionData: ExcursionData?
    
    private init() {}
}

extension NetworkManager: NetworkManagerProtocol {
    func saveUser(user: UserData) {
        self.userData = user
        imageLoader.load(image: user.profileImage) { [weak self] (result) in
            switch result {
            case .success(let name):
                self?.userData?.profileImageName = name
                guard let user = self?.userData else {
                    print("error")
                    return
                }
                self?.updateUser(user: user)
            case .failure(let error):
                print("registration interactor error: \(error)")
            }
        }
    }
    
    func updateUser(user: UserData) {
        guard let currentUser = Auth.auth().currentUser else { return }
        //currentUser.updateEmail(to: user.email, completion: nil)
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(String(userForBase.uid))
        userRef.updateChildValues(user.toDictionary() as! [AnyHashable : Any])
    }
    
    func imageLoad(image: UIImage?) {
        imageLoader.load(image: image) { [weak self] (result) in
                    switch result {
                    case .success(let name):
                        self?.userData?.profileImageName = name
                        guard let user = self?.userData else {
                            print("error")
                            return
                        }
                        self?.addUserInDataBase(user: user)
                    case .failure(let error):
                        print("registration interactor error: \(error)")
                    }
                }
    }
    
    func createUser(user: UserData, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userData = user
        Auth.auth().createUser(withEmail: user.email, password: password) { [weak self] result, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let userData = self?.userData else {
                completion(.failure(error!))
                return
            }
            
            self?.imageLoad(image: userData.profileImage)
            completion(.success(()))
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
    
    func getUser(completion: @escaping (Result<UserData, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.observe(.value, with: {[weak self] (snapshot) in 
            var user = UserData(snapshot: snapshot)
            if !(user.profileImageName.isEmpty) {
                self?.imageLoader.get(name: user.profileImageName, completion: { (result) in
                    switch result {
                    case .success(let image):
                        user.profileImage = image
                        completion(.success(user))
                    case .failure(let error):
                        user.profileImage = UIImage(systemName: "person")
                        completion(.failure(error))
                    }
                })
            } else {
                user.profileImage = UIImage(systemName: "person")
                completion(.success(user))
            }
        })
    }
    
    func checkUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(()))
        }
    }
    
    func addExcursion(excursion: ExcursionData) {
        guard let currentUser = Auth.auth().currentUser else { return }
        self.excursionData = excursion
        self.excursionData?.addedByUser = currentUser.uid
        imageLoader.load(image: excursion.image) { [weak self] (result) in
            switch result {
            case .success(let name):
                self?.excursionData?.imageName = name
                guard let excursionData = self?.excursionData else {
                    print("error")
                    return
                }
                self?.addExcursionInBase(excursion: excursionData)
            case .failure(let error):
                print("registration interactor error: \(error)")
            }
        }
        
    }
    
    
    func addExcursionInBase(excursion: ExcursionData) {
        let ref = Database.database().reference(withPath: "excursions")
        
        ref.child(excursion.name).setValue(excursion.toDictionary())
    }
}
