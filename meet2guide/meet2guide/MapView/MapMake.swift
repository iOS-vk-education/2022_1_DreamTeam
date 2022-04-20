import Foundation
import UIKit
class MapAssembler {
    static func make() -> UIViewController {
        let viewController = MapViewController()
        let presenter = MapPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
