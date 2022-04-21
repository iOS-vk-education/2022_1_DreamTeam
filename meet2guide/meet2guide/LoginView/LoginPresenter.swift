//
//  File.swift
//  meet2guide
//
//  Created by user on 15.04.2022.
//

import Foundation

protocol LoginPresenterProtocol: AnyObject {
     func didLoginButtonTapped()
     func didRegistrationButtonTapped()
}

final class LoginPresenter {
    weak var viewController: LoginViewControllerProtocol?
    
    init(view: LoginViewControllerProtocol) {
           self.viewController = view
    }
}

extension LoginPresenter: LoginPresenterProtocol {

     func didLoginButtonTapped() {
         self.viewController?.open("Вход")
     }
     func didRegistrationButtonTapped() {
         self.viewController?.open("Регистрация")
     }

}
