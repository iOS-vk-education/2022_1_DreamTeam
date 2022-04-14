//
//  GosistTourViewController.swift
//  meet2guide
//
//  Created by user on 11.04.2022.
//

import Foundation
import UIKit
import PinLayout

class GosistTourViewController: UIViewController {
    private let textTitle: String? = "Описание"
    private let titleLabel: UILabel = UILabel()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let colorGrayCustom: UIColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.2)
    private let formContainerView = UIView()
    private let tourImageView = UIImageView()
    private var tourName: String? = "Государственный Исторический Музей"
    private let formTitleLabel = UILabel()
    private let labelTourPlace: String = "Расположение"
    private var textTourPlace: String = "Красная площадь 1"
    private var tourPlaceTextView = UITextView()
    private let labelDescription: String = "Описание"
    private var textDescription: String = "Крупнейший национальный исторический музей России. Основан в 1872 году, здание на Красной площади Москвы было построено в 1875-1883 годах по проекту архитектора Владимира Шервуда и инженера Анатолия Семёнова"
    private var tourDescriptionTextView = UITextView()
    private let addTourButton: UIButton = UIButton()
    private let textButton: String = "ADD TO CART"
    private var prizeValue: Double = 300.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        titleLabel.text = textTitle
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = colorBlueCustom
        titleLabel.font = UIFont(name: "Avenir", size: 32)
        
        formContainerView.backgroundColor = colorGrayCustom
        formContainerView.layer.cornerRadius = 15.0

        formContainerView.layer.shadowColor = colorGrayCustom.cgColor
        formContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        formContainerView.layer.shadowRadius = 4
        formContainerView.layer.shadowOpacity = 1
        formContainerView.clipsToBounds = true
        formContainerView.layer.masksToBounds = false
        view.addSubview(formContainerView)
        
        formTitleLabel.text = tourName
        formTitleLabel.textColor = colorBlueCustom
        formTitleLabel.font = UIFont(name: "Avenir", size: 20)
        formTitleLabel.textAlignment = .center
        formTitleLabel.sizeToFit()
        formTitleLabel.numberOfLines = 2
        formContainerView.addSubview(formTitleLabel)
        
        tourImageView.backgroundColor = .white
        tourImageView.layer.cornerRadius = 10.0
        formContainerView.addSubview(tourImageView)
        
        tourPlaceTextView.textColor = .black
        tourPlaceTextView.font = UIFont(name: "Avenir", size: 13)
        tourPlaceTextView.textAlignment = .left
        tourPlaceTextView.backgroundColor = .clear
        tourPlaceTextView.text = labelTourPlace + ": " + textTourPlace
        formContainerView.addSubview(tourPlaceTextView)
        
        tourDescriptionTextView.textColor = .black
        tourDescriptionTextView.font = UIFont(name: "Avenir", size: 13)
        tourDescriptionTextView.textAlignment = .left
        tourDescriptionTextView.backgroundColor = .clear
        tourDescriptionTextView.text = labelDescription + ": " + textDescription
        formContainerView.addSubview(tourDescriptionTextView)

        addTourButton.setTitle(textButton + " " + String(prizeValue) + " ₽", for: .normal)
        addTourButton.backgroundColor = colorBlueCustom
        addTourButton.setTitleColor(.white, for: .normal)
        addTourButton.contentHorizontalAlignment = .center
        addTourButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        addTourButton.layer.cornerRadius = 20
        addTourButton.layer.borderWidth = 5.0
        addTourButton.layer.borderColor = (colorBlueCustom).cgColor

        addTourButton.layer.shadowColor = UIColor.darkGray.cgColor
        addTourButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addTourButton.layer.shadowRadius = 4
        addTourButton.layer.shadowOpacity = 1
        addTourButton.clipsToBounds = true
        addTourButton.layer.masksToBounds = false
        formContainerView.addSubview(addTourButton)
        
        view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.pin
            .top(view.safeAreaInsets.top)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        formContainerView.pin
            .below(of: titleLabel)
            .left(5%)
            .right(5%)
            .bottom(view.safeAreaInsets.bottom)
        
        addTourButton.pin
            .bottom(view.safeAreaInsets.bottom)
            .marginTop(10%)
            .left(5%)
            .right(5%)
            .height(15%)
            .maxHeight(60)
        
        tourDescriptionTextView.pin
            .above(of: addTourButton)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
            .minHeight(10)
        
        tourPlaceTextView.pin
            .above(of: tourDescriptionTextView)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
            .minHeight(10)
        
        formTitleLabel.pin
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        tourImageView.pin
            .below(of: formTitleLabel)
            .left(5%)
            .right(5%)
            .above(of: tourPlaceTextView)
            .minHeight(100)
    }
}
