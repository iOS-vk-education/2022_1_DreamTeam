//
//  RegistrationMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 29.04.2022.
//

import Foundation
import UIKit

final class RegistrationAssembler {
    static func make() -> UIViewController {
        let viewController = RegistrationViewController()
        let presenter = RegistrationPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
