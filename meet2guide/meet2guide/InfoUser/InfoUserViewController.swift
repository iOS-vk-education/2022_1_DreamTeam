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
    
    private var nameTextField = UITextField()
    private var nameLabel = UILabel()
    
    private var surnameTextField = UITextField()
    private var surnameLabel = UILabel()
    
    private var phoneTextField = UITextField()
    private var phoneLabel = UILabel()
    
    private var emailTextField = UITextField()
    private var emailLabel = UILabel()
    
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                name: UIResponder.keyboardWillShowNotification,
                                object: nil)
        NotificationCenter.default.addObserver(self,
                                selector: #selector(keyboardWillHide),
                                name: UIResponder.keyboardWillHideNotification,
                                object: nil)
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
    
    @objc
    func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height + 100)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    private func setUpTextField(label: UILabel, textField: UITextField, labelText: String) {
        label.text = labelText
        label.font = UIFont(name: "Montserrat-Medium", size: 14)
        label.textColor = colorBlue
        label.textAlignment = .left
        
        textField.text = "test"
        textField.font = UIFont(name: "Montserrat-Medium", size: 14)
        textField.textColor = colorBlue
        textField.textAlignment = .left
        
        textField.layer.borderColor = CGColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
        textField.layer.borderWidth = 1.0
        textField.borderStyle = .roundedRect
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        
        textField.backgroundColor = UIColor.systemGray
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: [.repeat, .autoreverse],
                       animations: { textField.alpha = 0.2 }
                      )
        
        scrollView.addSubview(label)
        scrollView.addSubview(textField)
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
        dismiss(animated: true, completion: nil)
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
            .sizeToFit()
        
        tableViewUserConfiguration.pin
            .topCenter(to: changeImageButton.anchor.bottomCenter)
            .margin(10)
            .width((self.view.window?.frame.width ?? 310))
            .height(240)
        
        saveButton.pin
            .topCenter(to: tableViewUserConfiguration.anchor.bottomCenter)
            .margin(10)
            .sizeToFit()
        
        exitButton.pin
            .topCenter(to: saveButton.anchor.bottomCenter)
            .margin(10)
            .sizeToFit()
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    deinit {
        
    }
}


extension InfoUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoUserCell", for: indexPath) as? InfoUserCell
        
        cell?.configure(with: userConfiguration[indexPath.row])
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        if userConfiguration[indexPath.row].title == "Телефон", userConfiguration[indexPath.row].isLoaded {
            cell?.information.delegate = self
            cell?.information.keyboardType = .numberPad
        }
        
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
    
    private func formatPhoneNumber(number: String) -> String {
           let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
           let mask = "+X (XXX) XXX-XX-XX"

           var result = ""

           var index = cleanPhoneNumber.startIndex

           for ch in mask where index < cleanPhoneNumber.endIndex {

               if ch == "X" {

                   result.append(cleanPhoneNumber[index])

                   index = cleanPhoneNumber.index(after: index)

               } else {

                   result.append(ch)

               }

           }

           return result

       }
}

extension InfoUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = tableViewUserConfiguration.cellForRow(at: IndexPath(row: 2, section: 0)) as! InfoUserCell
        if textField == cell.information {
            guard let text = cell.information.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)

            cell.information.text = formatPhoneNumber(number: newString)
            return false
        }
        
        return false
    }
    
}

extension InfoUserViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


