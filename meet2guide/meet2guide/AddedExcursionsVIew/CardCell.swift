//
//  CardCell.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.05.2022.
//

import Foundation
import UIKit
import PinLayout


class CardCell: UICollectionViewCell {
    var collectionView: UICollectionView!
    var reloadBlock: (() -> Void)?
    var customCardLayout: CardLayoutAttributes?
    
    var originTouchY: CGFloat = 0.0
    var panGesture: UIPanGestureRecognizer?
    
    var text = UILabel()
    
    var imageView = UIImageView()
    
    var button = UIButton()
    
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
        
        contentView.addSubview(text)
        
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
            .width(100)
            .height(25)
        
        imageView.pin.all()

        text.pin
            .top(20)
            .left(10)
            .sizeToFit()
    }
    
    @objc
    func didTapButton() {
        
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
    
    func configure(with excursion: ExcursionData) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = excursion.image
        text.text = excursion.name
    }
}

extension CardCell: UIGestureRecognizerDelegate {
    
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

extension UIView {
    
    func setShadow(offset:CGSize,radius:CGFloat,opacity:Float) {
     
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
    
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
