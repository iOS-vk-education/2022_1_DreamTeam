//
//  MapShowExcursionPresenter.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 28.05.2022.
//

import Foundation
import YandexMapsMobile

protocol MapShowExcursionPresenterProtocol: AnyObject {
}

final class MapShowExcursionPresenter {
    weak var viewController: MapShowExcursionView?
    

    init(view: MapShowExcursionView) {
        viewController = view
    }
}

extension MapShowExcursionPresenter: MapShowExcursionPresenterProtocol {
}

