import UIKit
import PinLayout

struct Function {
    let title: String
    let image: UIImage?
}

protocol AccountView: AnyObject {
    func reloadData(with user: User)
    func openInfoUser()
}

class AccountViewController: UIViewController, AccountView {
    var output: AccountPresenterProtocol?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUserAvatar()
        
        setUpUserName()
        
        setUpUserLocation()
        
        view.addSubview(ratingView)
        
        setUpStar()
        
        setUpRating()
        
        setUpFunctionsTableView()
        
        functionsTableView.separatorStyle = .none
        
        output?.didLoadView()
        
    }
    
    private func setUpUserAvatar() {
        userAvatar.image = UIImage(systemName: "person")
        userAvatar.layer.cornerRadius = 65
        userAvatar.clipsToBounds = true
        
        view.addSubview(userAvatar)
    }
    
    private func setUpUserName() {
        userNameLabel.text = "Екатерина Григоренко"
        userNameLabel.textColor = colorBlue
        userNameLabel.font = UIFont(name: "Montserrat-Regular", size: 26)
        userNameLabel.textAlignment = .center
        
        view.addSubview(userNameLabel)
    }
    
    private func setUpUserLocation() {
        userLocationLabel.text = "Санкт-Петербург, Россия"
        userLocationLabel.textColor = colorBlue
        userLocationLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        userLocationLabel.textAlignment = .center
        
        view.addSubview(userLocationLabel)
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
        
        view.addSubview(functionsTableView)
    }
    
    func reloadData(with user: User) {
        userNameLabel.text = user.name + " " + user.surname
        userAvatar.image = user.image
        ratingLabel.text = String(user.rating)
    }
    
    func openInfoUser() {
        let infoUserViewController = InfoUserAssembler.make()
        let navigationController = UINavigationController(rootViewController: infoUserViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
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
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as? AccountCell
        
        cell?.configure(with: (functions[indexPath.row]))
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didRowSelect(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
