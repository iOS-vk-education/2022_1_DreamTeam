//
//  GosistTourMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.04.2022.
//

import Foundation
import UIKit

final class GosistTourAssembler {
    static func make() -> UIViewController {
        let viewController = GosistTourViewController()
        let presenter = GosistTourPresenter(view: viewController)
        viewController.output = presenter
        return viewController
    }
}
