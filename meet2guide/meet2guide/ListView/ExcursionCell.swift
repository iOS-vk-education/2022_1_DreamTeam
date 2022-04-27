import UIKit
import PinLayout

class ExcursionCell: UITableViewCell {
    static let reuseIdentifier = "ExcursionCell"
    
    private let mainView = UIView()
    private let rightView = UIView()
    private let nameLabel = UILabel()
    private let mainImage = UIImageView()
    private let ratingText = UITextView()
    private let priceText = UITextView()
    private let starImage = UIImage(systemName: "star.fill")?.withTintColor(UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.2))
    private let starImageView = UIImageView()
    
    private let colorGrayCustom: UIColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.2)
    private let colorGrayText: UIColor = UIColor(red: 0.561, green: 0.561, blue: 0.608, alpha: 1.0)
    
    private let margin: CGFloat = 8
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        backgroundColor = .white
        contentView.addSubview(mainView)
        
        mainView.backgroundColor = colorGrayCustom
        mainView.layer.cornerRadius = 15.0
        
        nameLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        nameLabel.textColor = .black
        nameLabel.text = "Государственный Исторический \nМузей"
        nameLabel.lineBreakMode = .byTruncatingHead
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(nameLabel)
        
        ratingText.textColor = colorGrayText
        ratingText.font = UIFont(name: "Montserrat-Regular", size: 12)
        mainView.addSubview(ratingText)
        
        priceText.textColor = .black
        priceText.font = UIFont(name: "Montserrat-Bold", size: 15)
        
        
        ratingText.text = "4.78"
        priceText.text = "₽300.00"
        
        mainImage.image = UIImage(systemName: "photo")
        mainView.addSubview(mainImage)
        starImageView.image = starImage
        mainView.addSubview(starImageView)
        mainView.addSubview(priceText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImage
            .pin
            .top(20)
            .left(20)
            .width(125)
            .height(100)
        nameLabel
            .pin
            .top(15)
            .after(of: mainImage).margin(10).sizeToFit()
        
        starImageView
            .pin
            .top(60)
            .after(of: mainImage).margin(10).sizeToFit()
        ratingText
            .pin
            .top(65)
            .after(of: starImageView).sizeToFit()
        priceText
            .pin
            .after(of: mainImage).margin(10)
            .top(80)
            .sizeToFit()
            
    }
    
    func configure(excursion: Excursion) {
        nameLabel.text = excursion.name
        if let data = try? Data(contentsOf: excursion.mainImageURL) {
            mainImage.image = UIImage(data: data)
            mainImage.contentMode = .scaleAspectFill
        }
        else {
            mainImage.backgroundColor = .white
            mainImage.contentMode = .scaleAspectFill
        }
        ratingText.text = String(excursion.rating)
        priceText.text = String(excursion.price)
    }
}
