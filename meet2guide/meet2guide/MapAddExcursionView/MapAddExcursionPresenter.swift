//
//  MapAddExcursionPresenter.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 25.05.2022.
//

import Foundation
import YandexMapsMobile

protocol MapAddExcursionPresenterProtocol: AnyObject {
    func didTapDoneButton(address: String?, coords: YMKPoint?)
}

final class MapAddExcursionPresenter {
    weak var viewController: MapAddExcursionView?
    
    private var closure: ((String?, YMKPoint?) -> ())?

    init(view: MapAddExcursionView) {
        viewController = view
    }
    
    func setClosure(closure: @escaping (String?, YMKPoint?) -> ()) {
        self.closure = closure
    }
}

extension MapAddExcursionPresenter: MapAddExcursionPresenterProtocol {
    func didTapDoneButton(address: String?, coords: YMKPoint?) {
        closure?(address, coords)
        viewController?.closeWindow()
    }
}
