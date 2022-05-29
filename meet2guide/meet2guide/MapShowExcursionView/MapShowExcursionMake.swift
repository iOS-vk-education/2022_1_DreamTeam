//
//  MapShowExcursionMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 28.05.2022.
//

import Foundation
import UIKit
import YandexMapsMobile

class MapShowExcursionAssembler {
    static func make(point: YMKPoint) -> UIViewController {
        let viewController = MapShowExcursionViewController()
        viewController.setPoint(with: point)
        let presenter = MapShowExcursionPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
