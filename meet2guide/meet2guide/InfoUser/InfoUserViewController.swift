import UIKit
import PinLayout

struct UserConfig {
    let title: String?
    var textIn: String?
}

protocol InfoUserView: AnyObject {
    func reloadData(with user: User)
}


class InfoUserViewController: UIViewController, InfoUserView {
    var output: InfoUserPresenterProtocol?
    
    //private let label: UILabel = UILabel()
    
    private var userAvatar: UIImageView = UIImageView()
    
    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
    
    private var tableViewUserConfiguration: UITableView = UITableView()
    
    private var userConfiguration: [UserConfig] = [UserConfig(title: "Имя", textIn: "Иван"), UserConfig(title: "Фамилия", textIn: "Иванов"), UserConfig(title: "Телефон", textIn: "8 (800) 555-35-35"), UserConfig(title: "Почта", textIn: "pochta@bmstu.student.ru")]
    
    
    private let titleView = "Информация"
    
    private var saveButton: UIButton = UIButton()
    
    private var changeImageButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpLabel()
        self.title = "Информация"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clickedCloseButton))
        
        setUpUserAvatar()
        
        setUpChangeImageButton()
        
        setUpTableViewUserConfiguration()
        
        setUpSaveButton()
        output?.didLoadView()
    }
    
    @objc
    private func clickedCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    private func setUpLabel() {
        label.text = titleView
        label.font = UIFont(name: "Montserrat-Regular", size: 36)
        label.textColor = colorBlue
        
        view.addSubview(label)
    }*/
    
    private func setUpUserAvatar() {
        userAvatar.image = UIImage(systemName: "person")
        userAvatar.layer.cornerRadius = 140
        userAvatar.clipsToBounds = true
        userAvatar.backgroundColor = .systemGray5
        
        view.addSubview(userAvatar)
    }
    
    private func setUpTableViewUserConfiguration() {
        tableViewUserConfiguration.frame = view.bounds
        
        tableViewUserConfiguration.delegate = self
        tableViewUserConfiguration.dataSource = self
        tableViewUserConfiguration.register(InfoUserCell.self, forCellReuseIdentifier: "InfoUserCell")
        
        tableViewUserConfiguration.separatorStyle = .none
        
        view.addSubview(tableViewUserConfiguration)
    }
    
    private func setUpSaveButton() {
        saveButton.setTitle("Coхранить", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
        saveButton.backgroundColor = .systemBackground
        
        saveButton.setTitleColor(colorBlue, for: .normal)
        
        saveButton.addTarget(self, action: #selector(clickedSaveButton), for: .touchUpInside)
        
        
        view.addSubview(saveButton)
    }
    
    private func setUpChangeImageButton() {
        changeImageButton.setTitle("Изменить фото", for: .normal)
        changeImageButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
        changeImageButton.backgroundColor = .systemBackground
        changeImageButton.setTitleColor(colorBlue, for: .normal)
        
        view.addSubview(changeImageButton)
    }
    
    @objc
    private func clickedSaveButton() {
    }
    
    func reloadData(with user: User) {
        userConfiguration[0].textIn = user.name
        userConfiguration[1].textIn = user.surname
        userConfiguration[2].textIn = user.phone
        userConfiguration[3].textIn = user.email
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        
        /*label
            .pin
            .top(0)
            .margin(20)
            .hCenter()
            .sizeToFit()*/
        
        userAvatar
            .pin
            .top(view.safeAreaInsets.top)
            .margin(40)
            .height(275)
            .width(275)
            .hCenter()
        
        changeImageButton
            .pin
            .topCenter(to: userAvatar.anchor.bottomCenter)
            .margin(20)
            .width((self.view.window?.frame.width ?? 310) - 100)
            .height(40)
        
        tableViewUserConfiguration
            .pin
            .topCenter(to: changeImageButton.anchor.bottomCenter)
            .margin(10)
            .width((self.view.window?.frame.width ?? 310))
            .height((self.view.window?.frame.height ?? 310) - 600)
        
        saveButton
            .pin
            .topCenter(to: tableViewUserConfiguration.anchor.bottomCenter)
            .margin(10)
            .width((self.view.window?.frame.width ?? 310) - 100)
            .height(40)
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
