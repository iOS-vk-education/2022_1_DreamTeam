//
//  MainViewController.swift
//  meet2guide
//
//  Created by user on 08.04.2022.
//

import Foundation
import UIKit
import PinLayout

class MainViewController: UIViewController {
    private let TextInLabble: String = "Найдите лучшие экскурсии рядом с вами"
    private let TitleLable: UILabel = UILabel()
    private let LogIn: UIButton = UIButton()
    private let Registration: UIButton = UIButton()
    private let ImageLogo: UIImage? = UIImage(named: "logo")
    private let ImageViewLogo: UIImageView = UIImageView();
    private let ImageShadow: UIImage? = UIImage(named: "shadow")
    private let ImageViewShadow: UIImageView = UIImageView();

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        TitleLable.text = TextInLabble
        TitleLable.numberOfLines = 0
        TitleLable.textAlignment = .center
        TitleLable.textColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
        TitleLable.font = UIFont(name: "Avenir", size: 32)

        configButton(LogIn, "Вход", .white, UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1))
        configButton(Registration, "Регистрация", UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1), .white)
        
        ImageViewLogo.contentMode = .scaleAspectFill
        ImageViewLogo.transform = CGAffineTransform.identity.rotated(by: -90)
        ImageViewLogo.image = ImageLogo
        
        ImageViewShadow.image = ImageShadow
        
        view.addSubview(TitleLable)
        view.addSubview(ImageViewShadow)
        view.addSubview(ImageViewLogo)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        TitleLable.pin
            .top(view.safeAreaInsets.top + 40)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        ImageViewLogo.pin
            .below(of: TitleLable)
            .marginTop(6%)
            .hCenter(10%)
            .width(60%)
            .height(40%)
        
        ImageViewShadow.pin
            .below(of: ImageViewLogo)
            .marginTop(-10)
            .hCenter()
            .width(60%)
            .height(10%)
        
        LogIn.pin
            .bottom(view.safeAreaInsets.bottom + 20)
            .left(5%)
            .sizeToFit(.width)
            .width(40%)
            .height(10%)
        
        Registration.pin
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
        button.layer.borderColor = (UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)).cgColor

        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 1
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        view.addSubview(button)
    }

}
