//
//  UserExcursionCell.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 01.06.2022.
//
import UIKit

class ExcursionCardCell: UICollectionViewCell {
    var collectionView: UICollectionView!
    var reloadBlock: (() -> Void)?
    var customCardLayout: CardLayoutAttributes?
    
    weak var output: UserExcursionPresenterProtocol?
    
    var originTouchY: CGFloat = 0.0
    var panGesture: UIPanGestureRecognizer?
    
    var text = UILabel()
    
    var imageView = UIImageView()
    
    //var deleteButton = UIButton()
    
    var infoButton = UIButton()
    
    private var excursionId: String?
    
    private let colorBlueCustom: UIColor = UIColor(red: 0.205, green: 0.369, blue: 0.792, alpha: 1)
    
    @objc
    func pan(rec: UIPanGestureRecognizer) {
        let point = rec.location(in: collectionView)
        let shiftY = max(point.y - originTouchY, 0)
        switch rec.state {
        case .began:
            originTouchY = point.y
        case .changed:
            self.transform = CGAffineTransform(translationX: 0, y: shiftY)
        default:
            let isNeedReload = (shiftY > self.contentView.frame.height / 3) ? true : false
            let resetY = (isNeedReload) ? self.contentView.bounds.height * 1.2 : 0
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: resetY)
            }, completion: { (finish) in
                if let reload = self.reloadBlock , isNeedReload ,finish {
                    reload()
                }
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(imageView)
        imageView.image = UIImage(systemName: "map")
        imageView.alpha = 0.5
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        self.setShadow(offset: CGSize(width: 0, height: -4), radius: 8, opacity: 0.5)
        
        
        text.text = "test"
        text.font = UIFont(name: "Montserrat-Medium", size: 20)
        text.textColor = .white
        text.textAlignment = .left
        text.alpha = 1
        text.numberOfLines = 0
        
        contentView.addSubview(text)
        
        /*deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.backgroundColor = .systemBackground
        deleteButton.layer.cornerRadius = 20
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        contentView.addSubview(deleteButton)*/
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.tintColor = colorBlueCustom
        infoButton.backgroundColor = .systemBackground
        infoButton.layer.cornerRadius = 20
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        
        contentView.addSubview(infoButton)
        
        if panGesture == nil {
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(CardCell.pan(rec:)))
            panGesture?.delegate = self
            guard let panGesture = panGesture else {
                return
            }

            self.addGestureRecognizer(panGesture)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        text.pin
            .left(20)
            .top(self.contentView.frame.height / 2 - 12.5)
            .width(self.contentView.frame.width - 20)
            .height(25)
        
        imageView.pin.all()

        text.pin
            .top(20)
            .left(10)
            .sizeToFit()
        
        /*deleteButton.pin
            .left(20)
            .bottom(20)
            .height(40)
            .width(40)*/
        
        infoButton.pin
            .right(20)
            .bottom(20)
            .height(40)
            .width(40)
    }
    
    @objc
    func didTapDeleteButton() {
        guard let excursionId = excursionId else {
            return
        }

        output?.didDeleteCard(with: excursionId)
    }
    
    @objc
    func didTapInfoButton() {
        guard let excursionId = excursionId else {
            return
        }
        
        output?.didInfo(with: excursionId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layer.zPosition = CGFloat(layoutAttributes.zIndex)
        if let layout = layoutAttributes as? CardLayoutAttributes {
            customCardLayout = layout
        }
    }
    
    func configure(with excursion: ExcursionData, output: UserExcursionPresenterProtocol?) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = excursion.image
        text.text = excursion.name
        excursionId = excursion.id
        self.output = output
    }
}

extension ExcursionCardCell: UIGestureRecognizerDelegate {
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let layout = customCardLayout, layout.isExpand  {
            return layout.isExpand
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let layout = customCardLayout, layout.isExpand  {
            return layout.isExpand
        }
        return false
    }
}


