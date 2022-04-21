//
//  MainViewController.swift
//  meet2guide
//
//  Created by user on 08.04.2022.
//

import Foundation
import UIKit
import PinLayout

class RegistrationViewController: UIViewController {
    private var textTitle: String? = "Регистрация"
    private let titleLabel: UILabel = UILabel()
    private let mailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let nextButton: UIButton = UIButton()
    private let showPasswordButton: UIButton = UIButton()
    private let backButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configTextField(mailTextField, "example@example.ru", .emailAddress, false, .username)
        configTextField(passwordTextField, "password", .default, true, .password)
        
        titleLabel.text = textTitle
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = colorBlueCustom
        titleLabel.font = UIFont(name: "Avenir", size: 32)
        
        nextButton.setTitle("Далее", for: .normal)
        nextButton.backgroundColor = colorBlueCustom
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.contentHorizontalAlignment = .center
        nextButton.titleLabel?.font =  UIFont(name: "Avenir", size: 20)
        nextButton.layer.cornerRadius = 5
        nextButton.layer.borderWidth = 2.0
        nextButton.layer.borderColor = (colorBlueCustom).cgColor

        nextButton.layer.shadowColor = UIColor.darkGray.cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        nextButton.layer.shadowRadius = 4
        nextButton.layer.shadowOpacity = 1
        nextButton.clipsToBounds = true
        nextButton.layer.masksToBounds = false
        
        showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        showPasswordButton.contentHorizontalAlignment = .center
        showPasswordButton.tintColor = colorBlueCustom
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = colorBlueCustom
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorBlueCustom]
        backButton.title = "назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        title = textTitle

        view.addSubview(nextButton)
        passwordTextField.addSubview(showPasswordButton)
    }
    
    func popToRoot(sender:UIBarButtonItem){
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        mailTextField.pin
            .top(view.safeAreaInsets.top + 40)
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
        textField.backgroundColor = .white
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
        view.addSubview(textField)
    }
}
