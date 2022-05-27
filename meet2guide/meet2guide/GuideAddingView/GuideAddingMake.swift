import Foundation
import UIKit

class GuideAddingAssemler {
    static func make() -> UIViewController {
        let viewController = GuideAddingViewController()
        let presenter = GuideAddingPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
