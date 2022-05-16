//
//  LoginPresenter.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 16.05.2022.
//

import Foundation
import UIKit

protocol LoginPresenterProtocol: AnyObject {
    func didLogin(email: String, password: String)
    func openMainWindow()
}

final class LoginPresenter {
    weak var viewController: LoginView?
    
    let networkManager = NetworkManager.shared
    
    init(view: LoginView) {
        viewController = view
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func didLogin(email: String, password: String) {
        networkManager.checkUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.openMainWindow()
            case .failure(let error):
                self?.failedLogin(error: error)
            }
        }
    }
    
    func openMainWindow() {
        viewController?.open()
    }
    
    func failedLogin(error: Error) {
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

