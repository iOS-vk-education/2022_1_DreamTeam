import UIKit
class MainTabBarAssembler {
    static func make() -> UIViewController{
        let viewController = MainTabBarController()
        let presenter = MainTabBarPresenter(view: viewController)
        viewController.output = presenter
        
        return viewController
    }
}
