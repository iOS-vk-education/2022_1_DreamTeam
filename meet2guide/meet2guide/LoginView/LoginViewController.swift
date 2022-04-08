//
//  MainViewController.swift
//  meet2guide
//
//  Created by user on 08.04.2022.
//

import Foundation
import UIKit
import PinLayout

class LoginViewController: UIViewController {
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let textInLabble: String = "Найдите лучшие экскурсии рядом с вами"
    private let titleLable: UILabel = UILabel()
    private let logIn: UIButton = UIButton()
    private let registration: UIButton = UIButton()
    private let imageLogo: UIImage? = UIImage(named: "logo")
    private let imageViewLogo: UIImageView = UIImageView();
    private let imageShadow: UIImage? = UIImage(named: "shadow")
    private let imageViewShadow: UIImageView = UIImageView();

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        titleLable.text = textInLabble
        titleLable.numberOfLines = 0
        titleLable.textAlignment = .center
        titleLable.textColor = colorBlueCustom
        titleLable.font = UIFont(name: "Avenir", size: 32)

        configButton(logIn, "Вход", .white, colorBlueCustom)
        configButton(registration, "Регистрация", colorBlueCustom, .white)
        
        imageViewLogo.contentMode = .scaleAspectFill
        imageViewLogo.transform = CGAffineTransform.identity.rotated(by: -90)
        imageViewLogo.image = imageLogo
        
        imageViewShadow.image = imageShadow
        
        view.addSubview(titleLable)
        view.addSubview(imageViewShadow)
        view.addSubview(imageViewLogo)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        titleLable.pin
            .top(view.safeAreaInsets.top + 40)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        imageViewLogo.pin
            .below(of: titleLable)
            .marginTop(6%)
            .hCenter(10%)
            .width(60%)
            .height(40%)
        
        imageViewShadow.pin
            .below(of: imageViewLogo)
            .marginTop(-10)
            .hCenter()
            .width(60%)
            .height(10%)
        
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
        
    }
    
    func configButton (_ button: UIButton, _ name: String, _ backGrColor: UIColor, _ textColor: UIColor){
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
        view.addSubview(button)
    }
}
