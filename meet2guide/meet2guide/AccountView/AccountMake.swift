//
//  AccountMake.swift
//  devUser
//
//  Created by Екатерина Григоренко on 18.04.2022.
//

import Foundation
import UIKit

final class AccountAssembler {
    static func make() -> UIViewController {
        let viewController = AccountViewController()
        let presenter = AccountPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
