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
            .width(80)
            .height(25)

        information
            .pin
            .left(100)
            .top(self.contentView.frame.height / 2 - 20)
            .width(250)
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
        titleLabel.text = config.tableLabel
        information.text = config.textIn
    }
    
    func getInfo() -> String {
        return information.text
    }

}
