//
//  LoginMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 16.05.2022.
//

import Foundation
import UIKit

final class LoginAssembler {
    static func make() -> UIViewController {
        let viewController = LoginViewController()
        let presenter = LoginPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
