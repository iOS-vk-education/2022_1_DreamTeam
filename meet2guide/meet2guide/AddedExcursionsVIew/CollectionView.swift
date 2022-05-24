//
//  CollectionView.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.05.2022.
//

import Foundation
import UIKit

class ExcursionsCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.delegate = self
        self.collectionViewLayout = CustomCardLayout()
    }
    
    override var bounds: CGRect {
        didSet {
            if oldValue != bounds, bounds.size != .zero {
                if let l = collectionViewLayout as? CustomCardLayout {
                    l.updateCellSize()
                }
            }
            
            self.reloadData()
        }
    }
}

extension ExcursionsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? CardCell {
            cell.collectionView = collectionView
            cell.reloadBlock = {
                if let custom = collectionView.collectionViewLayout as? CustomCardLayout {
                    custom.selectPath = nil
                }
            }
            cell.isHidden = false
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let layout = collectionView.collectionViewLayout as? CustomCardLayout {
            layout.selectPath = indexPath
        }
    }
}


/*extension ExcursionsCollectionView: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        if let custom = collectionViewLayout as? CustomCardLayout, let path = custom.selectPath {
            transition.cardView = self.cellForItem(at: path)
            custom.isFullScreen = true
        }
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        if let custom = collectionViewLayout as? CustomCardLayout {
            custom.isFullScreen = false
        }
        
        return transition
    }
}*/
