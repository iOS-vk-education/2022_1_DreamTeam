import Foundation
import UIKit
import PinLayout

class AccountCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()
    private let iconImage: UIImageView = UIImageView()
    
    private var colorBlue: UIColor = UIColor(red: 52 / 255, green: 94 / 255, blue: 202 / 255, alpha: 100)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImage.pin.left(20).top(self.contentView.frame.height / 2 - 12.5).width(25).height(25)
        
        titleLabel.pin.right(0).top(self.contentView.frame.height / 2 - 20).width(self.contentView.frame.width - 80).height(40)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCell() {
        titleLabel.text = "Test text"
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        titleLabel.textColor = .lightGray
        titleLabel.textAlignment = .left
        
        iconImage.image = UIImage(systemName: "person")
        
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLabel)
    }
    
    func configure(with function: Function) {
        titleLabel.text = function.title
        iconImage.image = function.image ?? UIImage(systemName: "questionmark.circle")
        iconImage.image?.withTintColor(colorBlue)
    }

}
