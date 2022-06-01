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
    
    func saveUser(user: UserData, completion: @escaping (Result<Void, Error>) -> Void)
    
    func checkUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func addExcursion(excursion: ExcursionData, completion: @escaping (Result<Void, Error>) -> Void)
    
    func loadListExcursion(completion: @escaping (Result<Array<ExcursionData>, Error>) -> Void)
    
    func getExcursion(with id: String, completion: @escaping (Result<ExcursionData, Error>) -> Void)
    
    func addExcursionToUser(with id: String)
    
    func getExcursionsByUser(completion: @escaping (Result<[ExcursionData], Error>) -> Void)
    func observeUpdateExcursions(completion: @escaping (Result<Array<ExcursionData>, Error>) -> Void)
    
    func updateUserExcurions(with excursionId: String)
    
    func getExcursionsIdByUser(completion: @escaping (Result<[String], Error>) -> Void)
    
    func getExcursionsAddedByUser(completion: @escaping (Result<[ExcursionData], Error>) -> Void)
    
    func deleteExcrusion(with id: String)
    
    func getAddedExcursionsIdByUser(completion: @escaping (Result<[String], Error>) -> Void)
}

final class NetworkManager {
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    let imageLoader = ImageLoader.shared
    
    private var userData: UserData?
    
    private var excursionData: ExcursionData?
    
    private init() {}
}

extension NetworkManager: NetworkManagerProtocol {
    
    func saveUser(user: UserData, completion: @escaping (Result<Void, Error>) -> Void) {
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
                completion(.success(()))
            case .failure(let error):
                print("registration interactor error: \(error)")
                completion(.failure(error))
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
    
    func addExcursion(excursion: ExcursionData, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        self.excursionData = excursion
        self.excursionData?.addedByUser = currentUser.uid
        imageLoader.load(image: excursion.image) { [weak self] (result) in
            switch result {
            case .success(let name):
                self?.excursionData?.imageName = name
                self?.excursionData?.id = UUID().uuidString
                guard let excursionData = self?.excursionData else {
                    print("error")
                    return
                }
                self?.addExcursionInBase(excursion: excursionData)
                completion(.success(()))
            case .failure(let error):
                print("registration interactor error: \(error)")
                completion(.failure(error))
            }
        }
        
    }
    
    
    func addExcursionInBase(excursion: ExcursionData) {
        var ref = Database.database().reference(withPath: "excursions")
        
        ref.child(excursion.id).setValue(excursion.toDictionary())
        
        guard let currentUser = Auth.auth().currentUser else { return }
        ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("my_excursions").child(excursion.id).setValue("")
    }
    
    func loadListExcursion(completion: @escaping (Result<Array<ExcursionData>, Error>) -> Void) {
        let ref = Database.database().reference(withPath: "excursions")
        ref.getData { [weak self] error, snapshot in
            if let error = error {
                return
            }
            if snapshot.exists() {
                var excursions = Array<ExcursionData>()
                var excursionsFromBase = Array<Firebase.DataSnapshot>()
                for item in snapshot.children {
                    excursionsFromBase.append(item as! DataSnapshot)
                }
                
                for item in excursionsFromBase {
                    var excursion = ExcursionData(snapshot: item)
                    self?.imageLoader.get(name: excursion.imageName) { result in
                        switch result {
                        case .success(let image):
                            excursion.image = image
                            excursions.append(excursion)
                            if excursions.count == excursionsFromBase.count {
                                completion(.success(excursions))
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                
                
            }
            
        }
    }
    
    func getExcursion(with id: String, completion: @escaping (Result<ExcursionData, Error>) -> Void) {
        let ref = Database.database().reference(withPath: "excursions")
        ref.child(id).observe(.value, with: {[weak self] (snapshot) in
            print(snapshot)
            var excursion = ExcursionData(snapshot: snapshot)
            if !(excursion.imageName.isEmpty) {
                self?.imageLoader.get(name: excursion.imageName, completion: { (result) in
                    switch result {
                    case .success(let image):
                        excursion.image = image
                        completion(.success(excursion))
                    case .failure(let error):
                        excursion.image = UIImage(systemName: "map")
                        completion(.failure(error))
                    }
                })
            } else {
                excursion.image = UIImage(systemName: "map")
                completion(.success(excursion))
            }
        })
    }
    
    func addExcursionToUser(with id: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("excursions").child(id).setValue("")
    }
    
    func getExcursionsByUser(completion: @escaping (Result<[ExcursionData], Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("excursions").observe(.value, with: { [weak self] snapshot in
            
            if snapshot.exists() {
                let dictionary = snapshot.value as? [String: AnyObject]
                guard let dict = dictionary else {
                    return
                }
                let array = Array(dict.keys)
                print(array)
                var listExcursions = [ExcursionData]()
                for id in array {
                    self?.getExcursion(with: id) { result in
                        switch result {
                        case .success(let excursion):
                            listExcursions.append(excursion)
                            if listExcursions.count == array.count {
                                completion(.success(listExcursions))
                            }
                        case .failure(let error):
                            completion(.success([]))
                        }
                    }
                }
            } else {
                completion(.success([]))
            }
            
        })
    }
    
    
    func getExcursionsAddedByUser(completion: @escaping (Result<[ExcursionData], Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("my_excursions").observe(.value, with: { [weak self] snapshot in
            
            if snapshot.exists() {
                let dictionary = snapshot.value as? [String: AnyObject]
                guard let dict = dictionary else {
                    return
                }
                let array = Array(dict.keys)
                print(array)
                var listExcursions = [ExcursionData]()
                for id in array {
                    self?.getExcursion(with: id) { result in
                        switch result {
                        case .success(let excursion):
                            listExcursions.append(excursion)
                            if listExcursions.count == array.count {
                                completion(.success(listExcursions))
                            }
                        case .failure(let error):
                            completion(.success([]))
                        }
                    }
                }
            } else {
                completion(.success([]))
            }
            
        })
    }
    
    func observeUpdateExcursions(completion: @escaping (Result<Array<ExcursionData>, Error>) -> Void) {
        let ref = Database.database().reference(withPath: "excursions")
        ref.observe(.value, with: {[weak self] snapshot in
            if snapshot.exists() {
                var excursions = Array<ExcursionData>()
                var excursionsFromBase = Array<Firebase.DataSnapshot>()
                for item in snapshot.children {
                    excursionsFromBase.append(item as! DataSnapshot)
                }
                
                for item in excursionsFromBase {
                    var excursion = ExcursionData(snapshot: item)
                    self?.imageLoader.get(name: excursion.imageName) { result in
                        switch result {
                        case .success(let image):
                            excursion.image = image
                            excursions.append(excursion)
                            if excursions.count == excursionsFromBase.count {
                                completion(.success(excursions))
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                
                
            }
            
        })
    }
    
    func updateUserExcurions(with excursionId: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("excursions").child(excursionId).removeValue()
    }
    
    func getExcursionsIdByUser(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("excursions").observe(.value, with: { [weak self] snapshot in
            
            if snapshot.exists() {
                let dictionary = snapshot.value as? [String: AnyObject]
                guard let dict = dictionary else {
                    return
                }
                let array = Array(dict.keys)
                print(array)
                completion(.success(array))
            } else {
                completion(.success([]))
            }
            
        })
    }
    
    func deleteExcrusion(with id: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        var ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("my_excursions").child(id).removeValue()
        ref = Database.database().reference(withPath: "excursions")
        ref.child(id).removeValue()
    }
    
    func getAddedExcursionsIdByUser(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users")
        let userForBase = UserBase(user: currentUser)
        let userRef = ref.child(userForBase.uid)
        userRef.child("my_excursions").observe(.value, with: { [weak self] snapshot in
            
            if snapshot.exists() {
                let dictionary = snapshot.value as? [String: AnyObject]
                guard let dict = dictionary else {
                    return
                }
                let array = Array(dict.keys)
                print(array)
                completion(.success(array))
            } else {
                completion(.success([]))
            }
            
        })
    }
}
