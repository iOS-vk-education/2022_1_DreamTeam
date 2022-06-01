import UIKit
import PinLayout

class ExcursionCell: UITableViewCell {
    static let reuseIdentifier = "ExcursionCell"
    
    private var idExcursion: String = ""
    
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
        backgroundColor = .systemBackground
        contentView.addSubview(mainView)
        
        mainView.backgroundColor = colorGrayCustom
        mainView.layer.cornerRadius = 15.0
        
        nameLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        nameLabel.textColor = UIColor(named: "LabelColor")
        nameLabel.text = "Государственный Исторический \nМузей"
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(nameLabel)
        
        ratingText.textColor = colorGrayText
        ratingText.backgroundColor = .clear
        ratingText.font = UIFont(name: "Montserrat-Regular", size: 12)
        mainView.addSubview(ratingText)
        
        priceText.textColor = UIColor(named: "LabelColor")
        priceText.font = UIFont(name: "Montserrat-Bold", size: 15)
        priceText.backgroundColor = .clear
        
        
        ratingText.text = "   "
        priceText.text = "    "
        
        mainImage.image = UIImage(systemName: "photo")
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true
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
            .width(100)
            .height(80)
        nameLabel
            .pin
            .right(20)
            .after(of: mainImage, aligned: .top)
            .marginLeft(30)
            .height(30)
            .width(200)
        
        starImageView
            .pin
            .top(60)
            .after(of: mainImage)
            .marginLeft(30)
            .sizeToFit()
        ratingText
            .pin
            .top(60)
            .after(of: starImageView)
            .sizeToFit()
        priceText
            .pin
            .after(of: mainImage)
            .marginLeft(30)
            .top(80)
            .width(100)
            .height(30)
            
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
    
    func configure(excursion: ExcursionData) {
        nameLabel.text = excursion.name
        mainImage.image = excursion.image
        //mainImage.contentMode = .scaleAspectFill
        ratingText.text = String(excursion.rating)
        priceText.text = excursion.price + "₽"
        idExcursion = excursion.id
    }
    
    func getId() -> String {
        return idExcursion
    }
}
