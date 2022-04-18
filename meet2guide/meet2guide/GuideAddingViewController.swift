
import Foundation
import UIKit
import PinLayout


class GuideAddingViewController: UIViewController {
    private var textTitle: String? = "Добавить экскурсию"
    private let titleLabel: UILabel = UILabel()
    private let nameTextField: UITextField = UITextField()
    private let dateTextField: UITextField = UITextField()
    private let adressTextField: UITextField = UITextField()
    private let descriptionTextField: UITextField = UITextField()
    private let addPhotoButton: UIButton = UIButton()
    private let addGuideButton: UIButton = UIButton()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private var imagesFrame: UIImage? = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        titleLabel.text = textTitle
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = colorBlueCustom
        titleLabel.font = UIFont(name: "Avenir", size: 25)
        view.addSubview(titleLabel)
        
        
        
        
        
        configButton(addGuideButton, "Добавить", colorBlueCustom, .white)
        
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        titleLabel.pin
            .top(view.safeAreaInsets.top)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        addGuideButton.pin
            .bottom(view.safeAreaInsets.bottom + 20)
            .right(5%)
            .left(5%)
            .width(90%)
            .height(50%)
            .maxHeight(40)

    }
    
    
    func configButton (_ button: UIButton, _ name: String, _ backGrColor: UIColor, _ textColor: UIColor){
        button.setTitle(name, for: .normal)
        button.backgroundColor = backGrColor
        button.setTitleColor(textColor, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font =  UIFont(name: "Avenir", size: 15)
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

