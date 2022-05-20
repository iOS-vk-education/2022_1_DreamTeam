//
//  GosistTourViewController.swift
//  meet2guide
//
//  Created by user on 11.04.2022.
//

import Foundation
import UIKit
import PinLayout

protocol GosistTourView: AnyObject {
    func reloadData(with excursion: ExcursionData)
}

class GosistTourViewController: UIViewController {
    var output: GosistTourPresenterProtocol?
    private var idExcursion: String = ""
    private let textTitle: String? = "Описание"
    private let titleLabel: UILabel = UILabel()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let colorGrayCustom: UIColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.2)
    private let formContainerView = UIView()
    private let tourImageView = UIImageView()
    private var tourName: String? = "                              "
    private let formTitleLabel = UILabel()
    private let labelTourPlace: String = "Расположение"
    private var textTourPlace: String = "                   "
    private var tourPlaceTextView = UITextView()
    private let labelDescription: String = "Описание"
    private var textDescription: String = "                            "
    private var tourDescriptionTextView = UITextView()
    private let addTourButton: UIButton = UIButton()
    private let textButton: String = "Добавить"
    private var prizeValue: Double = 300.00
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.didLoadView(with: idExcursion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.title = "Описание"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorBlueCustom]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clickedCloseButton))
        
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

        addTourButton.setTitle(textButton, for: .normal)
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
    
    func setIdExcursion(idExcursion: String) {
        self.idExcursion = idExcursion
    }
    
    @objc
    private func clickedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        formContainerView.pin
            .top(view.safeAreaInsets.top + 20)
            .left(5%)
            .right(5%)
            .bottom(view.safeAreaInsets.bottom)
        
        
        formTitleLabel.pin
            .top(formContainerView.safeAreaInsets.top + 10)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        tourImageView.pin
            .topCenter(to: formTitleLabel.anchor.bottomCenter)
            .margin(10)
            .width(300)
            .height(300)
        
        tourPlaceTextView.pin
            .topCenter(to: tourImageView.anchor.bottomCenter)
            .margin(20)
            .width(300)
            .height(30)
        
        tourDescriptionTextView.pin
            .topCenter(to: tourPlaceTextView.anchor.bottomCenter)
            .margin(10)
            .width(300)
            .height(100)
        
        addTourButton.pin
            .bottom(view.safeAreaInsets.bottom)
            .marginTop(10%)
            .left(5%)
            .right(5%)
            .height(15%)
            .maxHeight(60)
        
        
    }
}

extension GosistTourViewController: GosistTourView {
    func reloadData(with excursion: ExcursionData) {
        formTitleLabel.text = excursion.name
        tourImageView.image = excursion.image
        tourPlaceTextView.text = labelTourPlace + ": " + excursion.address
        tourDescriptionTextView.text = labelDescription + ": " + (excursion.description ?? String(""))
    }
}
