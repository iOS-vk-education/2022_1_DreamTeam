//
//  InfoUserMake.swift
//  devUser
//
//  Created by Екатерина Григоренко on 18.04.2022.
//

import Foundation
import UIKit

final class InfoUserAssembler {
    static func make() -> UIViewController {
        let viewController = InfoUserViewController()
        let presenter = InfoUserPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
