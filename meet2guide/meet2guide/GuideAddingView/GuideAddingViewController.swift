import Foundation
import UIKit
import PinLayout

struct guideInfo{
    let tableLabel: String?
    var textIn: String?

}

protocol GuideAddingView: AnyObject {
    
}

class GuideAddingViewController: UIViewController {
    var output: GuideAddingPresenterProtocol?
    private var textTitle: String? = "Добавить экскурсию"
    private let titleLabel: UILabel = UILabel()
    private let nameTextField: UITextField = UITextField()
    private let dateTextField: UITextField = UITextField()
    private let adressTextField: UITextField = UITextField()
    private let descriptionTextField: UITextField = UITextField()
    private let addPhotoButton: UIButton = UIButton()
    private let addGuideButton: UIButton = UIButton()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let imagesFrame: UIImageView = UIImageView()
    private var tableViewGuideInfo: UITableView = UITableView()
    private var guideConfiguration: [guideInfo] = [guideInfo(tableLabel: "Название", textIn: "Достопримечательности Москвы"), guideInfo(tableLabel: "Дата", textIn: "10.04.2003"), guideInfo(tableLabel: "Адрес", textIn: "Красная пл. 1, г. Москва"), guideInfo(tableLabel: "Описание", textIn: "траляля, тополя")]




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
        configImages()
        setUpTableViewGuideInfo()




    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


        titleLabel
            .pin
            .top(view.safeAreaInsets.top)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)

        imagesFrame
            .pin
            .topCenter(to: titleLabel.anchor.bottomCenter).margin(30)
            .height(180)
            .width(90%)
            .hCenter()

        addGuideButton
            .pin
            .bottom(view.safeAreaInsets.bottom + 20)
            .right(5%)
            .left(5%)
            .width(90%)
            .height(60%)
            .maxHeight(50)

        tableViewGuideInfo
            .pin
            .topCenter(to: imagesFrame.anchor.bottomCenter)
            .margin(10)
            .width((self.view.window?.frame.width ?? 310))
            .height((self.view.window?.frame.height ?? 310) - 600)

    }

    private func configImages() {
        imagesFrame.image = UIImage(named: "moscow")
        imagesFrame.layer.cornerRadius = 10
        imagesFrame.clipsToBounds = true

        view.addSubview(imagesFrame)
    }

    private func setUpTableViewGuideInfo() {
        tableViewGuideInfo.frame = view.bounds

        tableViewGuideInfo.delegate = self
        tableViewGuideInfo.dataSource = self
        tableViewGuideInfo.register(GuideAddingCell.self, forCellReuseIdentifier: "GuideAddingCell")

        tableViewGuideInfo.separatorStyle = .none

        view.addSubview(tableViewGuideInfo)
    }



    func configButton (_ button: UIButton, _ name: String, _ backGrColor: UIColor, _ textColor: UIColor){
        button.setTitle(name, for: .normal)
        button.backgroundColor = backGrColor
        button.setTitleColor(textColor, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font =  UIFont(name: "Avenir", size: 15)
        button.layer.cornerRadius = 12
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

extension GuideAddingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuideAddingCell", for: indexPath) as? GuideAddingCell

        cell?.configure(with: guideConfiguration[indexPath.row])

        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

extension GuideAddingViewController: GuideAddingView {
    
}
