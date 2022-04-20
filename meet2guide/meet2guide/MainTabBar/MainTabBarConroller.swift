import UIKit

protocol MainTabBar: AnyObject {
}

class MainTabBarController: UITabBarController, MainTabBar {
    var output: MainTabBarPresenterProtocol?
    
    override func viewDidLoad() {
        tabBar.backgroundColor = .systemBackground
        let accountView = AccountAssembler.make()
        let accountPage = UINavigationController(rootViewController: accountView)
        
        let mapView = MapAssembler.make()
        let mapPage = UINavigationController(rootViewController: mapView)
        
        let accountView3 = AccountAssembler.make()
        let accountPage3 = UINavigationController(rootViewController: accountView3)
        
        let accountView4 = AccountAssembler.make()
        let accountPage4 = UINavigationController(rootViewController: accountView4)
        
        setViewControllers([mapPage, accountPage3, accountPage4, accountPage], animated: true)
        
        self.tabBar.items?[0].image = UIImage(systemName: "map")
        self.tabBar.items?[1].image = UIImage(systemName: "list.bullet")
        self.tabBar.items?[2].image = UIImage(systemName: "star")
        self.tabBar.items?[3].image = UIImage(systemName: "person")
        
        self.tabBar.items?[0].title = "карта"
        self.tabBar.items?[1].title = "поиск"
        self.tabBar.items?[2].title = "избранное"
        self.tabBar.items?[3].title = "аккаунт"
    }
}
