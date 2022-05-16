//
//  RegistrationPresenter.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 29.04.2022.
//

import Foundation
import UIKit

protocol RegistrationPresenterProtocol: AnyObject {
    func didRegistration(user: UserData, password: String)
    func openMainWindow()
}

final class RegistrationPresenter {
    weak var viewController: RegistrationView?
    
    let networkManager = NetworkManager.shared
    
    init(view: RegistrationView) {
        viewController = view
    }
}

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func didRegistration(user: UserData, password: String) {
        networkManager.createUser(user: user, password: password) { result in
            switch result {
            case .success:
                self.openMainWindow()
            case .failure(let error):
                self.failedRegistration(error: error)
            }
        }
    }
    
    func openMainWindow() {
        viewController?.open()
    }
    
    func failedRegistration(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .cancel,
                                     handler: nil)
        
        alert.addAction(okAction)
        
        viewController?.showAlert(alert: alert)
    }
}
