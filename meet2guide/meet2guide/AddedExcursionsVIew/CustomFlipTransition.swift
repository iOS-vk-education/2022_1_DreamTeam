//
//  CustomFlipTransition.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.05.2022.
//

import Foundation
import UIKit

enum TransitionMode {
    case present
    case dismiss
}


class CustomFlipTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 0.3
    var transitionMode = TransitionMode.present
    
    var cardView: UICollectionViewCell!
    var originalCardFrame = CGRect.zero
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.0
        return blurEffectView
    }()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let viewRadius = self.cardView.layer.cornerRadius
        
        if transitionMode == .present {
            originalCardFrame = cardView.frame
            let toViewF = cardView.superview!.convert(cardView.frame, to: nil)
            toView?.frame = cardView.bounds
            toView?.layer.cornerRadius = viewRadius
            self.cardView?.addSubview(toView!)
            
            UIView.transition(with: cardView, duration: self.duration, options: [.transitionFlipFromRight,.curveEaseIn], animations: {
                self.cardView.frame = CGRect.init(x: self.originalCardFrame.origin.x, y: self.originalCardFrame.origin.y, width: toViewF.width, height: toViewF.height)
                }, completion: { (finish) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.blurView.alpha = 1.0
                    })
                    toView?.frame = toViewF
                    toView?.removeFromSuperview()
                    containerView.addSubview(toView!)
                    transitionContext.completeTransition(true)
            })
        } else {
            cardView.isHidden = true
            let content = cardView.contentView
            let originalColor = content.backgroundColor
            content.backgroundColor = cardView.backgroundColor
            content.layer.cornerRadius = viewRadius
            fromView?.addSubview(content)
            UIView.transition(with: fromView!, duration: self.duration, options: [.transitionFlipFromLeft,.curveEaseInOut], animations: {
                self.blurView.alpha = 0.0
                }, completion: { (finish) in
                    self.blurView.removeFromSuperview()
                    content.backgroundColor = originalColor
                    content.removeFromSuperview()
                    self.cardView.addSubview(content)
                    self.cardView.isHidden = false
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    
    convenience init(duration: TimeInterval) {
        self.init()
        self.duration = duration
    }
}
