//
//  GosistTourMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.04.2022.
//

import Foundation
import UIKit

final class GosistTourAssembler {
    static func make(idExcursion: String) -> UIViewController {
        let viewController = GosistTourViewController()
        viewController.setIdExcursion(idExcursion: idExcursion)
        let presenter = GosistTourPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
