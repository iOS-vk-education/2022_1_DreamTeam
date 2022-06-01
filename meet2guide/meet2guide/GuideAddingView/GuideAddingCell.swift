import UIKit
import PinLayout

class GuideAddingCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()

    private var information: UITextView = UITextView()

    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel
            .pin
            .left(20)
            .top(self.contentView.frame.height / 2 - 12.5)
            .sizeToFit()

        information
            .pin
            .right(20)
            .top(self.contentView.frame.height / 2 - 20)
            .width(60%)
            .height(self.contentView.frame.height - 10)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCell() {
        titleLabel.text = "test"
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        titleLabel.textColor = colorBlue
        titleLabel.textAlignment = .left
    

        information.text = "test"
        information.font = UIFont(name: "Montserrat-Medium", size: 14)
        information.textColor = colorBlue
        information.textAlignment = .left

        information.layer.borderColor = CGColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
        information.layer.borderWidth = 1.0
        //information.layer.masksToBounds = true
        information.layer.cornerRadius = 10
        information.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        contentView.addSubview(titleLabel)
        contentView.addSubview(information)
    }

    func configure(with config: guideInfo) {
        if config.tableLabel == "Цена" {
            information.keyboardType = .numberPad
            print("price")
        }
        titleLabel.text = config.tableLabel
        information.text = config.textIn
    }

    
    func getInfo() -> String {
        return information.text
    }

}


class GuideAddingCellMap: UITableViewCell {
    private let titleLabel: UILabel = UILabel()

    var information: MapTextField = MapTextField()
    
    private weak var output: GuideAddingPresenterProtocol?
    
    private var mapButton: UIButton = UIButton()

    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel
            .pin
            .left(20)
            .top(self.contentView.frame.height / 2 - 12.5)
            .sizeToFit()

        information
            .pin
            .right(20)
            .top(self.contentView.frame.height / 2 - 20)
            .width(60%)
            .height(self.contentView.frame.height - 10)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCell() {
        titleLabel.text = "test"
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        titleLabel.textColor = colorBlue
        titleLabel.textAlignment = .left
    

        information.text = "test"
        information.font = UIFont(name: "Montserrat-Medium", size: 14)
        information.textColor = colorBlue
        information.textAlignment = .left

        information.layer.borderColor = CGColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
        information.layer.borderWidth = 1.0
        information.layer.cornerRadius = 10
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.setImage(UIImage(systemName: "map"), for: .selected)
        mapButton.addTarget(self, action: #selector(clickedMapButton), for: .touchUpInside)
        information.rightView = mapButton
        information.rightViewMode = .always
        mapButton.alpha = 0.8
        information.indent(size: 10)

        contentView.addSubview(titleLabel)
        contentView.addSubview(information)
    }

    func configure(with config: guideInfo, presenter: GuideAddingPresenterProtocol?) {
        titleLabel.text = config.tableLabel
        information.text = config.textIn
        output = presenter
    }
    
    func getInfo() -> String {
        return information.text ?? ""
    }
    
    @objc
    private func clickedMapButton() {
        output?.didTapOpenMap()
    }
}

class MapTextField: UITextField {
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 10
        return textRect
    }
}

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}

class GuideAddingCellDate: UITableViewCell {
    private let titleLabel: UILabel = UILabel()

    private var information: UITextView = UITextView()

    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
    
    let datePicker = UIDatePicker()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel
            .pin
            .left(20)
            .top(self.contentView.frame.height / 2 - 12.5)
            .sizeToFit()

        information
            .pin
            .right(20)
            .top(self.contentView.frame.height / 2 - 20)
            .width(60%)
            .height(self.contentView.frame.height - 10)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCell() {
        //titleLabel.text = "test"
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        titleLabel.textColor = colorBlue
        titleLabel.textAlignment = .left
    

        //information.text = "test"
        information.font = UIFont(name: "Montserrat-Medium", size: 14)
        information.textColor = colorBlue
        information.textAlignment = .left

        information.layer.borderColor = CGColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
        information.layer.borderWidth = 1.0
        //information.layer.masksToBounds = true
        information.layer.cornerRadius = 10
        information.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        contentView.addSubview(titleLabel)
        contentView.addSubview(information)
    }

    func configure(with config: guideInfo) {
        createDatePicker()
        titleLabel.text = config.tableLabel
        information.text = config.textIn
    }
    
    private func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        information.inputView = datePicker
        information.inputAccessoryView = toolbar
    }
    
    func getInfo() -> String {
        return information.text
    }
    
    @objc
    func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        dateFormatter.timeStyle = .short
        information.text = dateFormatter.string(from: datePicker.date)
        self.contentView.endEditing(true)
    }

}
