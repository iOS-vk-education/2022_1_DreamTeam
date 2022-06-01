//
//  GosistTourMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.04.2022.
//

import Foundation
import UIKit

final class GosistTourAssembler {
    static func make(idExcursion: String, isAdding: Bool, isAdded: Bool = false) -> UIViewController {
        let viewController = GosistTourViewController()
        viewController.setIdExcursion(idExcursion: idExcursion)
        viewController.setAdding(isAdding: isAdding)
        viewController.setAdded(isAdded: isAdded)
        let presenter = GosistTourPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
