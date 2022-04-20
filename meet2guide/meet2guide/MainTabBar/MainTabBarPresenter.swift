protocol MainTabBarPresenterProtocol: AnyObject {
}

class MainTabBarPresenter: MainTabBarPresenterProtocol {
    weak var viewController: MainTabBar?
    
    init(view: MainTabBar) {
        viewController = view
    }
}
