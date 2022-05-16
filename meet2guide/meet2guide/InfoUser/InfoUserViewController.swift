import UIKit
import PinLayout


struct UserConfig {
    let title: String?
    var textIn: String?
    var color: UIColor
    var isLoaded: Bool
}

protocol InfoUserView: AnyObject {
    func reloadData(with user: UserData)
    
    func openStartWindow()
    
    func showAlert(alert: UIAlertController)
    
    func loadImage(image: UIImage?)
    
    func openImagePicker(output: ImagePickerProtocol)
}


class InfoUserViewController: UIViewController {
    var output: InfoUserPresenterProtocol?
    
    private var scrollView: UIScrollView = UIScrollView()
    
    private var userAvatar: UIImageView = UIImageView()
    
    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
    
    private var tableViewUserConfiguration: UITableView = UITableView()
    
    private var userConfiguration: [UserConfig] =
    [UserConfig(title: "Имя", textIn: "", color: UIColor.systemGray5, isLoaded: false),
     UserConfig(title: "Фамилия", textIn: "", color: UIColor.systemGray5, isLoaded: false),
     UserConfig(title: "Телефон", textIn: "", color: UIColor.systemGray5, isLoaded: false),
     UserConfig(title: "Почта", textIn: "", color: UIColor.systemGray5, isLoaded: false)]
    
    
    private let titleView = "Информация"
    
    private var saveButton: UIButton = UIButton()
    
    private var changeImageButton: UIButton = UIButton()
    
    private var exitButton: UIButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        output?.didLoadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Информация"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorBlue]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clickedCloseButton))
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        
        view.addSubview(scrollView)
        
        setUpUserAvatar()
        
        setUpChangeImageButton()
        
        setUpTableViewUserConfiguration()
        
        setUpSaveButton()
        
        setUpExitButton()
    }
    
    private func setUpUserAvatar() {
        userAvatar.image = UIImage()
        userAvatar.layer.cornerRadius = 140
        userAvatar.clipsToBounds = true
        userAvatar.backgroundColor = .systemGray5
        userAvatar.layer.backgroundColor = UIColor.systemGray.cgColor
        userAvatar.layer.masksToBounds = true
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: [.repeat, .autoreverse],
                       animations: { self.userAvatar.alpha = 0.5}
                      )
        
        scrollView.addSubview(userAvatar)
    }
    
    private func setUpTableViewUserConfiguration() {
        tableViewUserConfiguration.frame = view.bounds
        
        tableViewUserConfiguration.delegate = self
        tableViewUserConfiguration.dataSource = self
        tableViewUserConfiguration.register(InfoUserCell.self, forCellReuseIdentifier: "InfoUserCell")
        
        tableViewUserConfiguration.separatorStyle = .none
        
        scrollView.addSubview(tableViewUserConfiguration)
    }
    
    private func setUpSaveButton() {
        saveButton.setTitle("Coхранить", for: .normal)
        saveButton.addTarget(self, action: #selector(clickedSaveButton), for: .touchUpInside)
        saveButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        saveButton.backgroundColor = .systemBackground
        
        saveButton.setTitleColor(colorBlue, for: .normal)
        
        saveButton.addTarget(self, action: #selector(clickedSaveButton), for: .touchUpInside)
        
        
        scrollView.addSubview(saveButton)
    }
    
    private func setUpChangeImageButton() {
        changeImageButton.setTitle("Изменить фото", for: .normal)
        changeImageButton.addTarget(self, action: #selector(clickedChangeImageButton), for: .touchUpInside)
        changeImageButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        changeImageButton.backgroundColor = .systemBackground
        changeImageButton.setTitleColor(colorBlue, for: .normal)
        
        scrollView.addSubview(changeImageButton)
    }
    
    private func setUpExitButton() {
        exitButton.setTitle("Выход", for: .normal)
        exitButton.addTarget(self, action: #selector(clickedExitButton), for: .touchUpInside)
        exitButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        exitButton.backgroundColor = .systemBackground
        exitButton.setTitleColor(.red, for: .normal)
        
        scrollView.addSubview(exitButton)
    }
    
    @objc
    private func clickedSaveButton() {
        var cell = tableViewUserConfiguration.cellForRow(at: IndexPath(row: 0, section: 0)) as! InfoUserCell
        guard let name = cell.getInfo(), !name.isEmpty else {
            return
        }
        
        cell = tableViewUserConfiguration.cellForRow(at: IndexPath(row: 1, section: 0)) as! InfoUserCell
        
        guard let surname = cell.getInfo(), !surname.isEmpty else {
            return
        }
        
        cell = tableViewUserConfiguration.cellForRow(at: IndexPath(row: 2, section: 0)) as! InfoUserCell
        
        guard let phone = cell.getInfo(), !phone.isEmpty else {
            return
        }
        
        cell = tableViewUserConfiguration.cellForRow(at: IndexPath(row: 3, section: 0)) as! InfoUserCell
        
        guard let email = cell.getInfo(), !email.isEmpty else {
            return
        }
        
        guard let image = userAvatar.image else {
            return
        }
        
        let user = UserData(email: email,
                            name: name,
                            surname: surname,
                            phone: phone,
                            image: image)
        output?.didUpdateUser(user: user)
    }
    
    @objc
    private func clickedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func clickedExitButton() {
        output?.logOut()
    }
    
    @objc
    private func clickedChangeImageButton() {
        output?.didTapChangeImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        scrollView.backgroundColor = .systemBackground
        
        scrollView.pin
            .all(view.pin.safeArea)
        
        userAvatar.pin
            .top(view.safeAreaInsets.top)
            .height(275)
            .width(275)
            .hCenter()
        
        changeImageButton.pin
            .topCenter(to: userAvatar.anchor.bottomCenter)
            .margin(20)
            .width((self.view.window?.frame.width ?? 310) - 100)
            .height(40)
        
        tableViewUserConfiguration.pin
            .topCenter(to: changeImageButton.anchor.bottomCenter)
            .margin(10)
            .width((self.view.window?.frame.width ?? 310))
            .height(240)
        
        saveButton.pin
            .topCenter(to: tableViewUserConfiguration.anchor.bottomCenter)
            .margin(10)
            .width((self.view.window?.frame.width ?? 310) - 100)
            .height(40)
        
        exitButton.pin
            .topCenter(to: saveButton.anchor.bottomCenter)
            .margin(10)
            .width((self.view.window?.frame.width ?? 310) - 100)
            .height(30)
    }
}


extension InfoUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoUserCell", for: indexPath) as? InfoUserCell
        
        cell?.configure(with: userConfiguration[indexPath.row])
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}


extension InfoUserViewController: InfoUserView {
    func openImagePicker(output: ImagePickerProtocol) {
        let imagePicker = ImagePicker()
        imagePicker.output = output
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadImage(image: UIImage?) {
        userAvatar.image = image
    }
    
    func reloadData(with user: UserData) {
        userConfiguration[0].textIn = user.name
        userConfiguration[1].textIn = user.surname
        userConfiguration[2].textIn = user.phone
        userConfiguration[3].textIn = user.email
        for i in (0..<userConfiguration.count) {
            userConfiguration[i].isLoaded = true
            userConfiguration[i].color = UIColor.systemBackground
        }
        userAvatar.image = user.profileImage
        userAvatar.layer.removeAllAnimations()
        userAvatar.alpha = 1
        userAvatar.layer.backgroundColor = UIColor.systemBackground.cgColor
        tableViewUserConfiguration.reloadData()
    }
    
    func openStartWindow() {
        let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
        let startWindow = UINavigationController(rootViewController: WelcomeViewController())
        sceneDelegate.window!.rootViewController = startWindow
        sceneDelegate.window!.makeKeyAndVisible()
        
        UIView.transition(with: sceneDelegate.window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}

