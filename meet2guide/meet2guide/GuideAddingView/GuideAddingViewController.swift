import Foundation
import UIKit
import PinLayout
import YandexMapsMobile

struct guideInfo{
    let tableLabel: String?
    var textIn: String?

}

protocol GuideAddingView: AnyObject {
    func openImagePicker(output: ImagePickerProtocol)
    
    func loadImage(image: UIImage?)
    
    func openMap()
    
    func setAddress(address: String?, coords: String?)
}

class GuideAddingViewController: UIViewController {
    var output: GuideAddingPresenterProtocol?
    private var scrollView: UIScrollView = UIScrollView()
    private var textTitle: String? = "Добавить экскурсию"
    private let nameLabel: UILabel = UILabel()
    private let nameTextField: UITextView = UITextView()
    private let dateLabel: UILabel = UILabel()
    private let dateTextField: UITextView = UITextView()
    private let adressLabel: UILabel = UILabel()
    private let adressTextField: UITextField = UITextField()
    private let descriptionLabel: UILabel = UILabel()
    private let descriptionTextField: UITextView = UITextView()
    private let addPhotoButton: UIButton = UIButton()
    private let addGuideButton: UIButton = UIButton()
    private var changeImageButton: UIButton = UIButton()
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    private let imagesFrame: UIImageView = UIImageView()
    private var tableViewGuideInfo: UITableView = UITableView()
    private var guideConfiguration: [guideInfo] =
    [guideInfo(tableLabel: "Название", textIn: ""),
     guideInfo(tableLabel: "Дата", textIn: ""),
     guideInfo(tableLabel: "Адрес", textIn: ""),
     guideInfo(tableLabel: "Описание", textIn: "")]
    
    private var coords: YMKPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = textTitle
        view.backgroundColor = .systemBackground
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                name: UIResponder.keyboardWillShowNotification,
                                object: nil)
        NotificationCenter.default.addObserver(self,
                                selector: #selector(keyboardWillHide),
                                name: UIResponder.keyboardWillHideNotification,
                                object: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorBlueCustom]
        self.navigationController?.navigationBar.tintColor = colorBlueCustom
        let barButton = UIBarButtonItem()
        barButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        view.addSubview(scrollView)
        
        /*setUpTextView(titleLabel: nameLabel, textView: nameTextField, title: "Название")
        setUpTextView(titleLabel: dateLabel, textView: dateTextField, title: "Дата")
        setUpTextView(titleLabel: descriptionLabel, textView: descriptionTextField, title: "Описание")*/

        configButton(addGuideButton, "Добавить", colorBlueCustom, .white)
        addGuideButton.addTarget(self, action: #selector(clickedAddGuideButton), for: .touchUpInside)
        configImages()
        setUpChangeImageButton()
        setUpTableViewGuideInfo()
    }
    
    private func setUpTextView(titleLabel: UILabel, textView: UITextView, title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        titleLabel.textColor = colorBlueCustom
        titleLabel.textAlignment = .left
    

        textView.text = "                  "
        textView.font = UIFont(name: "Montserrat-Medium", size: 14)
        textView.textColor = colorBlueCustom
        textView.textAlignment = .left

        textView.layer.borderColor = CGColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
        textView.layer.borderWidth = 1.0
        //information.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textView)
    }
    
    private func setUpMapTexField(titleLabel: UILabel, textField: UITextField, title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        titleLabel.textColor = colorBlueCustom
        titleLabel.textAlignment = .left
        
        textField.layer.borderColor = CGColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
        textField.layer.borderWidth = 1.0
        //information.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.backgroundColor = .systemBackground
        
        scrollView.pin
            .all(view.pin.safeArea)

        imagesFrame.pin
            .top(scrollView.safeAreaInsets.top)
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
        /*nameLabel.pin
            .*/
        
        addGuideButton.pin
            .topCenter(to: tableViewGuideInfo.anchor.bottomCenter)
            .margin(20)
            .right(5%)
            .left(5%)
            .width(90%)
            .height(60%)
            .maxHeight(50)

    }
    
    @objc
    func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height + 100)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        
        let cellMap = tableViewGuideInfo.cellForRow(at: IndexPath(row: 2, section: 0)) as! GuideAddingCellMap
        
        let address = cellMap.getInfo()
        
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
                                      price: "300",
                                      coords: coords)
        output?.addExcursion(excursion: excursion)
        self.navigationController?.popViewController(animated: true)
    }

    private func configImages() {
        imagesFrame.image = UIImage(systemName: "photo")?.withTintColor(colorBlueCustom)
        imagesFrame.layer.cornerRadius = 10
        imagesFrame.clipsToBounds = true
        imagesFrame.contentMode = .scaleAspectFit

        scrollView.addSubview(imagesFrame)
    }

    private func setUpTableViewGuideInfo() {
        tableViewGuideInfo.frame = view.bounds

        tableViewGuideInfo.delegate = self
        tableViewGuideInfo.dataSource = self
        tableViewGuideInfo.register(GuideAddingCell.self, forCellReuseIdentifier: "GuideAddingCell")
        tableViewGuideInfo.register(GuideAddingCellMap.self, forCellReuseIdentifier: "GuideAddingCellMap")

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
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideAddingCellMap", for: indexPath) as? GuideAddingCellMap
            cell?.configure(with: guideConfiguration[indexPath.row], presenter: output)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell ?? .init()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideAddingCell", for: indexPath) as? GuideAddingCell

            cell?.configure(with: guideConfiguration[indexPath.row])

            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell ?? .init()
        }
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
    func setAddress(address: String?, coords: String?) {
        adressTextField.text = address
    }
    
    func openImagePicker(output: ImagePickerProtocol) {
        let imagePicker = ImagePicker()
        imagePicker.output = output
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadImage(image: UIImage?) {
        imagesFrame.image = image
    }
    
    func openMap() {
        let viewControllerMap = MapAddExcursionAssembler.make(point: coords) { [weak self] address, coords in
            self?.guideConfiguration[2].textIn = address
            self?.coords = coords
            self?.tableViewGuideInfo.reloadData()
        }
        //present(viewControllerMap, animated: true, completion: nil)
        self.navigationController?.pushViewController(viewControllerMap, animated: true)
    }
}



