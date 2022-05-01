//
//  RegistrationMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 29.04.2022.
//

import Foundation
import UIKit

final class RegistrationAssembler {
    static func make(with title: String?) -> UIViewController {
        let viewController = RegistrationViewController()
        viewController.configTitle(with: title)
        let presenter = RegistrationPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
