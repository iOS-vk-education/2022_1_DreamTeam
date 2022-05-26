//
//  MapAddExcursionMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 25.05.2022.
//

import Foundation
import UIKit
import YandexMapsMobile

class MapAddExcursionAssembler {
    static func make(point: YMKPoint?, closure: @escaping (String?, YMKPoint?) -> ()) -> UIViewController {
        let viewController = MapAddExcursionViewController()
        viewController.setCoords(coords: point)
        let presenter = MapAddExcursionPresenter(view: viewController)
        presenter.setClosure(closure: closure)
        viewController.output = presenter
        
        return viewController
    }
}
