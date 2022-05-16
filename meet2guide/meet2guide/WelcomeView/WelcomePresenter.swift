//
//  File.swift
//  meet2guide
//
//  Created by user on 15.04.2022.
//

import Foundation

protocol WelcomePresenterProtocol: AnyObject {
     func didLoginButtonTapped()
     func didRegistrationButtonTapped()
}

final class WelcomePresenter {
    weak var viewController: WelcomeViewControllerProtocol?
    
    init(view: WelcomeViewControllerProtocol) {
           self.viewController = view
    }
}

extension WelcomePresenter: WelcomePresenterProtocol {

     func didLoginButtonTapped() {
         self.viewController?.openLogin()
     }
     func didRegistrationButtonTapped() {
         self.viewController?.openRegistration()
     }

}
