//
//  AddedExcursionMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.05.2022.
//

import Foundation
import UIKit

final class AddedExcursionsAssembler {
    static func make() -> UIViewController {
        let viewController = AddedExcursionsViewController()
        let presenter = AddedExcursionsPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
