import Foundation
import UIKit
import PinLayout

struct guideInfo{
    let tableLabel: String?
    var textIn: String?

}

protocol GuideAddingView: AnyObject {
    func openImagePicker(output: ImagePickerProtocol)
    
    func loadImage(image: UIImage?)
}

class GuideAddingViewController: UIViewController {
    var output: GuideAddingPresenterProtocol?
    private var scrollView: UIScrollView = UIScrollView()
    private var textTitle: String? = "Добавить экскурсию"
    private let titleLabel: UILabel = UILabel()
    private let nameTextField: UITextField = UITextField()
    private let dateTextField: UITextField = UITextField()
    private let adressTextField: UITextField = UITextField()
    private let descriptionTextField: UITextField = UITextField()
    private let addPhotoButton: UIButton = UIButton()
    private let addGuideButton: UIButton = UIButton()
    private var changeImageButton: UIButton = UIButton()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let imagesFrame: UIImageView = UIImageView()
    private var tableViewGuideInfo: UITableView = UITableView()
    private var guideConfiguration: [guideInfo] =
    [guideInfo(tableLabel: "Название", textIn: "Достопримечательности Москвы"),
     guideInfo(tableLabel: "Дата", textIn: "10.04.2003"),
     guideInfo(tableLabel: "Адрес", textIn: "Красная пл. 1, г. Москва"),
     guideInfo(tableLabel: "Описание", textIn: "траляля, тополя")]


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        
        view.addSubview(scrollView)

        titleLabel.text = textTitle
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = colorBlueCustom
        tableViewGuideInfo.estimatedRowHeight = 44.0
        tableViewGuideInfo.rowHeight = UITableView.automaticDimension
        titleLabel.font = UIFont(name: "Avenir", size: 25)
        scrollView.addSubview(titleLabel)

        configButton(addGuideButton, "Добавить", colorBlueCustom, .white)
        addGuideButton.addTarget(self, action: #selector(clickedAddGuideButton), for: .touchUpInside)
        configImages()
        setUpChangeImageButton()
        setUpTableViewGuideInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.backgroundColor = .systemBackground
        
        scrollView.pin
            .all(view.pin.safeArea)

        titleLabel.pin
            .top(scrollView.safeAreaInsets.top)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)

        imagesFrame.pin
            .topCenter(to: titleLabel.anchor.bottomCenter)
            .margin(30)
            .height(180)
            .width(60%)
            .hCenter()
        
        changeImageButton.pin
            .topCenter(to: imagesFrame.anchor.bottomCenter)
            .margin(20)
            .width((self.scrollView.window?.frame.width ?? 310) - 100)
            .height(40)

        tableViewGuideInfo.pin
            .topCenter(to: changeImageButton.anchor.bottomCenter)
            .margin(30)
            .width((self.scrollView.window?.frame.width ?? 310))
            .height(300)
        
        addGuideButton.pin
            .topCenter(to: tableViewGuideInfo.anchor.bottomCenter)
            .margin(20)
            .right(5%)
            .left(5%)
            .width(90%)
            .height(60%)
            .maxHeight(50)

    }
    
    private func setUpChangeImageButton() {
        changeImageButton.setTitle("Изменить фото", for: .normal)
        changeImageButton.addTarget(self, action: #selector(clickedChangeImageButton), for: .touchUpInside)
        changeImageButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        changeImageButton.backgroundColor = .systemBackground
        changeImageButton.setTitleColor(colorBlueCustom, for: .normal)
        
        scrollView.addSubview(changeImageButton)
    }
    
    @objc
    private func clickedChangeImageButton() {
        output?.didTapChangeImage()
    }
    
    @objc
    private func clickedAddGuideButton() {
        var cell = tableViewGuideInfo.cellForRow(at: IndexPath(row: 0, section: 0)) as! GuideAddingCell
        
        let name = cell.getInfo()
        if name.isEmpty {
            return
        }
        
        cell = tableViewGuideInfo.cellForRow(at: IndexPath(row: 1, section: 0)) as! GuideAddingCell
        
        let date = cell.getInfo()
        
        if date.isEmpty {
            return
        }
        
        cell = tableViewGuideInfo.cellForRow(at: IndexPath(row: 2, section: 0)) as! GuideAddingCell
        
        let address = cell.getInfo()
        
        if address.isEmpty {
            return
        }
        
        cell = tableViewGuideInfo.cellForRow(at: IndexPath(row: 3, section: 0)) as! GuideAddingCell
        
        let description = cell.getInfo()
        
        guard let image = imagesFrame.image else {
            return
        }
        
        let excursion = ExcursionData(name: name,
                                      date: date,
                                      address: address,
                                      description: description,
                                      image: image,
                                      price: "300")
        output?.addExcursion(excursion: excursion)
        self.navigationController?.popViewController(animated: true)
    }

    private func configImages() {
        imagesFrame.image = UIImage(systemName: "mappin.square")
        imagesFrame.layer.cornerRadius = 10
        imagesFrame.clipsToBounds = true

        scrollView.addSubview(imagesFrame)
    }

    private func setUpTableViewGuideInfo() {
        tableViewGuideInfo.frame = view.bounds

        tableViewGuideInfo.delegate = self
        tableViewGuideInfo.dataSource = self
        tableViewGuideInfo.register(GuideAddingCell.self, forCellReuseIdentifier: "GuideAddingCell")

        tableViewGuideInfo.separatorStyle = .none

        scrollView.addSubview(tableViewGuideInfo)
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

        scrollView.addSubview(button)
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
        if indexPath.row == 3 {
            return 100
        }
        return 50
    }
}

extension GuideAddingViewController: GuideAddingView {
    func openImagePicker(output: ImagePickerProtocol) {
        let imagePicker = ImagePicker()
        imagePicker.output = output
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadImage(image: UIImage?) {
        imagesFrame.image = image
    }
}
