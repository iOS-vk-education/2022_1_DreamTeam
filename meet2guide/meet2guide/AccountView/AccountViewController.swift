import UIKit
import PinLayout

import CoreLocation

struct Function {
    let title: String
    let image: UIImage?
}

protocol AccountView: AnyObject {
    func reloadData(with user: UserData)
    func openInfoUser()
    func openGuideAdding()
    func showAlert(alert: UIAlertController)
    func openMyExcursions()
}

class AccountViewController: UIViewController {
    var output: AccountPresenterProtocol?
    
    private var scrollView: UIScrollView = UIScrollView()
    
    private var functionsTableView: UITableView = UITableView()
    
    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
    
    private var userAvatar: UIImageView = UIImageView()
    
    private var userNameLabel: UILabel = UILabel()
    
    private var userLocationLabel: UILabel = UILabel()
    
    private var ratingView: UIView = UIView()
    
    private let starImage: UIImageView = UIImageView()
    
    private var ratingLabel: UILabel = UILabel()
    
    private let functions: [Function] = [
        Function(title: "Персональная информация", image: UIImage(systemName: "person.fill")),
        Function(title: "Добавить экскурсию", image: UIImage(systemName: "plus")),
        Function(title: "Мои экскурсии", image: UIImage(systemName: "map.fill"))]
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.didLoadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
        title = "Аккаунт"
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        
        view.addSubview(scrollView)
        
        setUpUserAvatar()
        
        setUpUserName()
        
        setUpUserLocation()
        
        scrollView.addSubview(ratingView)
        
        setUpStar()
        
        setUpRating()
        
        setUpFunctionsTableView()
        
        functionsTableView.separatorStyle = .none
        
    }
    
    private func setUpUserAvatar() {
        userAvatar.image = UIImage()
        userAvatar.layer.cornerRadius = 65
        userAvatar.clipsToBounds = true
        userAvatar.layer.backgroundColor = UIColor.systemGray.cgColor
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: [.repeat, .autoreverse],
                       animations: { self.userAvatar.alpha = 0.5
            print(self.userNameLabel.alpha)
        }
                      )
        
        scrollView.addSubview(userAvatar)
    }
    
    private func setUpUserName() {
        userNameLabel.text = "                               "
        userNameLabel.textColor = colorBlue
        userNameLabel.font = UIFont(name: "Montserrat-Regular", size: 26)
        userNameLabel.textAlignment = .center
        userNameLabel.layer.backgroundColor = UIColor.systemGray.cgColor
        userNameLabel.layer.cornerRadius = 7
        userNameLabel.layer.masksToBounds = true
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: [.repeat, .autoreverse],
                       animations: { self.userNameLabel.alpha = 0.5
            print(self.userNameLabel.alpha)}
                      )
        
        scrollView.addSubview(userNameLabel)
    }
    
    private func setUpUserLocation() {
        userLocationLabel.text = "                                    "
        userLocationLabel.textColor = colorBlue
        userLocationLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        userLocationLabel.textAlignment = .center
        
        scrollView.addSubview(userLocationLabel)
    }
    
    private func setUpStar() {
        starImage.image = UIImage(systemName: "star.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        ratingView.addSubview(starImage)
    }
    
    private func setUpRating() {
        ratingLabel.text = ""
        ratingLabel.textColor = .gray
        ratingLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        
        ratingLabel.layer.backgroundColor = UIColor.systemGray.cgColor
        ratingLabel.layer.cornerRadius = 7
        ratingLabel.layer.masksToBounds = true
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: [.repeat, .autoreverse],
                       animations: { self.ratingLabel.alpha = 0.5
            print(self.userNameLabel.alpha)}
                      )
        
        ratingView.addSubview(ratingLabel)
    }
    
    private func setUpFunctionsTableView() {
        functionsTableView.frame = view.bounds
        
        functionsTableView.delegate = self
        functionsTableView.dataSource = self
        functionsTableView.register(AccountCell.self, forCellReuseIdentifier: "AccountCell")
        
        scrollView.addSubview(functionsTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        scrollView.backgroundColor = .systemBackground
        
        scrollView.pin
            .all(view.pin.safeArea)
        
        userAvatar.pin
            .top(scrollView.safeAreaInsets.top + 40)
            .height(128)
            .width(128)
            .hCenter()
        
        userNameLabel.pin
            .topCenter(to: userAvatar.anchor.bottomCenter).margin(20)
            .sizeToFit()
            .maxWidth((self.view.window?.frame.width ?? 310) - 100)
        
        userLocationLabel.pin
            .topCenter(to: userNameLabel.anchor.bottomCenter)
            .margin(20)
            .sizeToFit()
            .maxWidth((self.view.window?.frame.width ?? 310) - 100)
        
        starImage.pin
            .left(0)
            .width(20)
            .sizeToFit()
        
        ratingLabel.pin
            .after(of: starImage)
            .margin(10)
            .height(20)
            .width(50)
        
        ratingView.pin
            .topCenter(to: userLocationLabel.anchor.bottomCenter)
            .margin(20)
            .width(80)
        
        functionsTableView.pin
            .topCenter(to: ratingView.anchor.bottomCenter)
            .margin(50)
            .width((self.view.window?.frame.width ?? 310) - 60)
            .height((self.view.window?.frame.height ?? 310) - 100)
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

extension AccountViewController: AccountView {
    func openGuideAdding() {
        let guideAddingViewController = GuideAddingAssemler.make()
        self.navigationController?.pushViewController(guideAddingViewController, animated: true)
    }
    
    func reloadData(with user: UserData) {
        userNameLabel.text = user.name + " " + user.surname
        userAvatar.image = user.profileImage
        ratingLabel.text = String(user.rating)
        self.userNameLabel.layer.removeAllAnimations()
        self.userNameLabel.alpha = 1
        userNameLabel.layer.backgroundColor = UIColor.systemBackground.cgColor
        self.userAvatar.layer.removeAllAnimations()
        self.userAvatar.alpha = 1
        userAvatar.layer.backgroundColor = UIColor.systemBackground.cgColor
        self.ratingLabel.layer.removeAllAnimations()
        self.ratingLabel.alpha = 1
        ratingLabel.layer.backgroundColor = UIColor.systemBackground.cgColor
    }
    
    func openInfoUser() {
        let infoUserViewController = InfoUserAssembler.make()
        let navigationController = UINavigationController(rootViewController: infoUserViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func openMyExcursions() {
        let view = UserExcursionAssembler.make()
        self.navigationController?.pushViewController(view, animated: true)
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1)}
    }
    
    func fetchName(completion: @escaping (_ name: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.name, $1)}
    }
}

extension AccountViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        currentLocation.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.userLocationLabel.text = city + ", " + country
        }
    }
}
