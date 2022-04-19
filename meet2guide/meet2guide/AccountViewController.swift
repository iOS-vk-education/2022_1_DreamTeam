import UIKit
import PinLayout

struct Function {
    let title: String
    let image: UIImage?
}

class AccountViewController: UIViewController {
    
    private let scroll: UIScrollView = UIScrollView()
    
    private var functionsTableView: UITableView = UITableView()
    
    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
    
    private var userAvatar: UIImageView = UIImageView()
    
    private var userNameLabel: UILabel = UILabel()
    
    private var userLocationLabel: UILabel = UILabel()
    
    private var ratingView: UIView = UIView()
    
    private let starImage: UIImageView = UIImageView()
    
    private var ratingLabel: UILabel = UILabel()
    
    private let functions: [Function] = [
        Function(title: "Personal information", image: UIImage(systemName: "person.fill")),
        Function(title: "Add a tour", image: UIImage(systemName: "bell.fill")),
        Function(title: "Messages", image: UIImage(systemName: "message.fill"))]
    
    private let tabBar: UITabBar = UITabBar()
    private let mapTabBarItem: UITabBarItem = UITabBarItem()
    private let favoriteTabBarItem: UITabBarItem = UITabBarItem()
    private let accountTabBarItem: UITabBarItem = UITabBarItem()
    private let searchTabBarItem: UITabBarItem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scroll)
        scroll.contentSize = CGSize(width: (self.view.window?.frame.width ?? 310), height: 840)
        
        setUpUserAvatar()
        
        setUpUserName()
        
        setUpUserLocation()
        
        scroll.addSubview(ratingView)
        
        setUpStar()
        
        setUpRating()
        
        setUpFunctionsTableView()
        
        functionsTableView.separatorStyle = .none
        
        setUpMenu()
        
    }
    
    private func setUpUserAvatar() {
        userAvatar.image = UIImage(systemName: "person")
        userAvatar.layer.cornerRadius = 65
        userAvatar.clipsToBounds = true
        
        scroll.addSubview(userAvatar)
    }
    
    private func setUpUserName() {
        userNameLabel.text = "Екатерина Григоренко"
        userNameLabel.textColor = colorBlue
        userNameLabel.font = UIFont(name: "Montserrat-Regular", size: 26)
        userNameLabel.textAlignment = .center
        
        scroll.addSubview(userNameLabel)
    }
    
    private func setUpUserLocation() {
        userLocationLabel.text = "Санкт-Петербург, Россия"
        userLocationLabel.textColor = colorBlue
        userLocationLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        userLocationLabel.textAlignment = .center
        
        scroll.addSubview(userLocationLabel)
    }
    
    private func setUpStar() {
        starImage.image = UIImage(systemName: "star.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        ratingView.addSubview(starImage)
    }
    
    private func setUpRating() {
        ratingLabel.text = "4.87"
        ratingLabel.textColor = .gray
        ratingLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        
        ratingView.addSubview(ratingLabel)
    }
    
    private func setUpFunctionsTableView() {
        functionsTableView.frame = view.bounds
        
        functionsTableView.delegate = self
        functionsTableView.dataSource = self
        functionsTableView.register(AccountCell.self, forCellReuseIdentifier: "AccountCell")
        
        scroll.addSubview(functionsTableView)
    }
    
    private func setUpMenu() {
        mapTabBarItem.image = UIImage(systemName: "map")
        favoriteTabBarItem.image = UIImage(systemName: "star")
        accountTabBarItem.image = UIImage(systemName: "person")
        searchTabBarItem.image = UIImage(systemName: "list.bullet")
                
        mapTabBarItem.title = "карта"
        favoriteTabBarItem.title = "избранное"
        accountTabBarItem.title = "аккаунт"
        searchTabBarItem.title = "поиск"
        
        tabBar.setItems([mapTabBarItem, searchTabBarItem, favoriteTabBarItem, accountTabBarItem], animated: true)
        tabBar.selectedItem = accountTabBarItem
        
        view.addSubview(tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        scroll.pin.width(self.view.window?.frame.width ?? 600).height(self.view.window?.frame.height ?? 600).left(0).top(0)
        userAvatar.pin
            .top(view.safeAreaInsets.top + 60)
            .height(128)
            .width(128)
            .hCenter()
        
        userNameLabel.pin.topCenter(to: userAvatar.anchor.bottomCenter).margin(20)
            .sizeToFit().maxWidth((self.view.window?.frame.width ?? 310) - 100)
        
        userLocationLabel.pin.topCenter(to: userNameLabel.anchor.bottomCenter).margin(20).sizeToFit().maxWidth((self.view.window?.frame.width ?? 310) - 100)
        
        
        starImage.pin.left(0).width(20).sizeToFit()
        ratingLabel.pin.after(of: starImage).margin(10).height(20).width(50)
        
        
        ratingView.pin.topCenter(to: userLocationLabel.anchor.bottomCenter).margin(20).width(80)
        
        functionsTableView.pin.topCenter(to: ratingView.anchor.bottomCenter).margin(50).width((self.view.window?.frame.width ?? 310) - 60).height((self.view.window?.frame.height ?? 310) - 100)
        tabBar.pin
            .bottom(view.safeAreaInsets.bottom)
            .left(0)
            .right(0)
            .height(30)
            .sizeToFit(.width)
        
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as? AccountCell
        
        cell?.configure(with: functions[indexPath.row])
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

