//
//  UserExcursionMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 01.06.2022.
//

import Foundation
import UIKit

final class UserExcursionAssembler {
    static func make() -> UIViewController {
        let viewController = UserExcursionViewController()
        let presenter = UserExcursionPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
