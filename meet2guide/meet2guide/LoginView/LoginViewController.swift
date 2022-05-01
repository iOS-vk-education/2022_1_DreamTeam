//
//  MainViewController.swift
//  meet2guide
//
//  Created by user on 08.04.2022.
//

import Foundation
import UIKit
import PinLayout

protocol LoginViewControllerProtocol: AnyObject {
    func open(_ titleView: String)
}

class LoginViewController: UIViewController {
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let textInLabel: String = "Найдите лучшие экскурсии рядом с вами"
    private let titleLabel: UILabel = UILabel()
    private let logIn: UIButton = UIButton()
    private let registration: UIButton = UIButton()
    private let imageLogo: UIImage? = UIImage(named: "logo")
    private let imageViewLogo: UIImageView = UIImageView()
    private let imageShadow: UIImage? = UIImage(named: "shadow")
    private let imageViewShadow: UIImageView = UIImageView()
    private var loginPresenter: LoginPresenterProtocol?

    @objc func loginButtonAction() {
        loginPresenter?.didLoginButtonTapped()
    }
    
    @objc func registrationButtonAction() {
        loginPresenter?.didRegistrationButtonTapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        titleLabel.text = textInLabel
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = colorBlueCustom
        titleLabel.font = UIFont(name: "Avenir", size: 32)
        
        imageViewLogo.contentMode = .scaleAspectFill
        imageViewLogo.image = imageLogo
        
        imageViewShadow.image = imageShadow
        
        view.addSubview(imageViewShadow)
        view.addSubview(imageViewLogo)
        view.addSubview(titleLabel)
        configButton(logIn, "Вход", .white, colorBlueCustom, #selector(loginButtonAction))
        configButton(registration, "Регистрация", colorBlueCustom, .white, #selector(registrationButtonAction))
        loginPresenter = LoginPresenter(view: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        titleLabel.pin
            .top(view.safeAreaInsets.top)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        logIn.pin
            .bottom(view.safeAreaInsets.bottom + 20)
            .left(5%)
            .sizeToFit(.width)
            .width(40%)
            .height(10%)
        
        registration.pin
            .bottom(view.safeAreaInsets.bottom + 20)
            .right(5%)
            .sizeToFit(.width)
            .width(40%)
            .height(10%)
        
        imageViewLogo.pin
            .verticallyBetween(titleLabel, and: logIn).marginVertical(10%)
            .hCenter()
            .aspectRatio()

        imageViewShadow.pin
            .below(of: imageViewLogo)
            .marginTop(-4%)
            .hCenter()
            .width(of: imageViewLogo)
            .aspectRatio(3)
    }
    
    func configButton (_ button: UIButton, _ name: String, _ backGrColor: UIColor, _ textColor: UIColor, _ funcAction: Selector){
        button.setTitle(name, for: .normal)
        button.backgroundColor = backGrColor
        button.setTitleColor(textColor, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font =  UIFont(name: "Avenir", size: 14)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2.0
        button.layer.borderColor = (colorBlueCustom).cgColor

        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 1
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.addTarget(self, action: funcAction, for: .touchUpInside)
        view.addSubview(button)
    }
}

extension LoginViewController: LoginViewControllerProtocol {
    func open(_ titleView: String){
        let registrationView = RegistrationAssembler.make(with: titleView)
        self.navigationController?.pushViewController(registrationView, animated: true)
    }
}
