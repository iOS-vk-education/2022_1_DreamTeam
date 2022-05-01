import UIKit
import PinLayout

class InfoUserCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()
    
    private var information: UITextField = UITextField()
    
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
            .width(100)
            .height(25)
        
        information
            .pin
            .left(150)
            .top(self.contentView.frame.height / 2 - 20)
            .width(55%)
            .height(40)
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
        information.borderStyle = .roundedRect
        information.layer.masksToBounds = true
        information.layer.cornerRadius = 10
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(information)
    }
    
    func configure(with config: UserConfig) {
        titleLabel.text = config.title
        information.text = config.textIn
    }
    
}
