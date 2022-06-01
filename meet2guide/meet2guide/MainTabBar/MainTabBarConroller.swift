import UIKit

protocol MainTabBar: AnyObject {
}

class MainTabBarController: UITabBarController, MainTabBar {
    var output: MainTabBarPresenterProtocol?
    
    override func viewDidLoad() {
        tabBar.backgroundColor = .systemBackground
        self.navigationItem.hidesBackButton = true
        let accountView = AccountAssembler.make()
        let accountPage = UINavigationController(rootViewController: accountView)
        
        let mapView = MapAssembler.make()
        let mapPage = UINavigationController(rootViewController: mapView)
        
        let excursionView = ListAssembler.make()
        let excursionPage = UINavigationController(rootViewController: excursionView)
        
        let addedExcursionsView = AddedExcursionsAssembler.make()
        let addedExcursionsPage = UINavigationController(rootViewController: addedExcursionsView)
        
        setViewControllers([mapPage, excursionPage, addedExcursionsPage, accountPage], animated: true)
        
        self.tabBar.items?[0].image = UIImage(systemName: "map")
        self.tabBar.items?[1].image = UIImage(systemName: "list.bullet")
        self.tabBar.items?[2].image = UIImage(systemName: "ticket")
        self.tabBar.items?[3].image = UIImage(systemName: "person")
        
        self.tabBar.items?[0].title = "карта"
        self.tabBar.items?[1].title = "поиск"
        self.tabBar.items?[2].title = "билеты"
        self.tabBar.items?[3].title = "аккаунт"
    }
}
