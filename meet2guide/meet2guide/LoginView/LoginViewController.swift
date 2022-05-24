//
//  LoginViewController.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 16.05.2022.
//

import Foundation
import UIKit
import PinLayout

protocol LoginView: AnyObject {
    func open()
    func showAlert(alert: UIAlertController)
}

class LoginViewController: UIViewController {
    var output: LoginPresenterProtocol?
    private var scrollView: UIScrollView = UIScrollView()
    private var textTitle: String? = "Вход"
    private let titleLabel: UILabel = UILabel()
    private let mailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = PasswordTextField()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let nextButton: UIButton = UIButton()
    private let showPasswordButton: UIButton = UIButton()
    private let backButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        scrollView.backgroundColor = .systemBackground
        configTextField(mailTextField, "example@example.ru", .emailAddress, false, .username)
        configTextField(passwordTextField, "password", .default, true, .password)
        passwordTextField.enablePasswordToggle(button: showPasswordButton)
        
        titleLabel.text = textTitle
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = colorBlueCustom
        titleLabel.font = UIFont(name: "Avenir", size: 32)
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        
        view.addSubview(scrollView)
        
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
        
        nextButton.setTitle("Далее", for: .normal)
        nextButton.backgroundColor = colorBlueCustom
        nextButton.setTitleColor(.systemBackground, for: .normal)
        nextButton.contentHorizontalAlignment = .center
        nextButton.titleLabel?.font =  UIFont(name: "Montserrat-Regular", size: 20)
        nextButton.layer.cornerRadius = 5
        nextButton.layer.borderWidth = 2.0
        nextButton.layer.borderColor = (colorBlueCustom).cgColor

        nextButton.layer.shadowColor = UIColor.darkGray.cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowRadius = 4
        nextButton.layer.shadowOpacity = 1
        nextButton.clipsToBounds = true
        nextButton.layer.masksToBounds = false
        
        showPasswordButton.contentHorizontalAlignment = .center
        showPasswordButton.tintColor = colorBlueCustom
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .always
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = colorBlueCustom
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorBlueCustom]
        backButton.title = "назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        title = textTitle
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)

        scrollView.addSubview(nextButton)
    }
    
    @objc
    func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentOffset = CGPoint(x: 0, y: nextButton.frame.minY - keyboardSize.height)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: nextButton.frame.minY - keyboardSize.height, right: 0)
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func popToRoot(sender:UIBarButtonItem){
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func didTapNextButton() {
        guard let email = mailTextField.text, !email.isEmpty else {
            mailTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        output?.didLogin(email: email, password: password)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .all(view.pin.safeArea)
 
        mailTextField.pin
            .top(scrollView.safeAreaInsets.top + 40)
            .left(5%)
            .right(5%)
            .height(10%)
            .maxHeight(50)
        
        passwordTextField.pin
            .below(of: mailTextField)
            .marginTop(6%)
            .left(5%)
            .right(5%)
            .height(10%)
            .maxHeight(50)
        
        showPasswordButton.pin
            .right(20)
            .vCenter()
            .width(6%)
            .height(50%)
        
        nextButton.pin
            .below(of: passwordTextField)
            .marginTop(10%)
            .left(5%)
            .right(5%)
            .height(15%)
            .maxHeight(60)
        
    }
    func configTitle(with title: String?){
        textTitle = title
    }
    
    func configTextField (_ textField: UITextField, _ name: String, _ typeKeyboard: UIKeyboardType, _ security: Bool, _ typeContent: UITextContentType){
        textField.textContentType = typeContent
        textField.placeholder = name
        textField.backgroundColor = .systemBackground
        textField.textColor = colorBlueCustom
        textField.font = UIFont(name: "Avenir", size: 14)
        textField.keyboardType = typeKeyboard
        textField.isSecureTextEntry = security
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = (colorBlueCustom).cgColor
        textField.returnKeyType = UIReturnKeyType.done
        textField.clipsToBounds = true
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        scrollView.addSubview(textField)
    }
}

extension LoginViewController: LoginView {
    func open() {
        let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
        
        sceneDelegate.window!.rootViewController = MainTabBarAssembler.make()
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

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
