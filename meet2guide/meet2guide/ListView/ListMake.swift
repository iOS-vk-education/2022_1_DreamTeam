//
//  ListMake.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.04.2022.
//

import Foundation

import Foundation
import UIKit

final class ListAssembler {
    static func make() -> UIViewController {
        let viewController = ListViewController()
        let presenter = ListPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
