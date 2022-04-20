import UIKit

protocol MainTabBar: AnyObject {
}

class MainTabBarController: UITabBarController, MainTabBar {
    var output: MainTabBarPresenterProtocol?
    
    override func viewDidLoad() {
        let accountView = AccountAssembler.make()
        let accountPage = UINavigationController(rootViewController: accountView)
        
        let accountView2 = AccountAssembler.make()
        let accountPage2 = UINavigationController(rootViewController: accountView2)
        
        let accountView3 = AccountAssembler.make()
        let accountPage3 = UINavigationController(rootViewController: accountView3)
        
        let accountView4 = AccountAssembler.make()
        let accountPage4 = UINavigationController(rootViewController: accountView4)
        
        setViewControllers([accountPage2, accountPage3, accountPage4, accountPage], animated: true)
        
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
