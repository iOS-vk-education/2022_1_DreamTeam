//
//  AddedExcursionsViewController.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.05.2022.
//

import Foundation
import UIKit
import PinLayout


protocol AddedExcursionsView: AnyObject {
    func reloadData(with listExcursions: [ExcursionData])
}

class AddedExcursionsViewController: UIViewController {
    var output: AddedExcursionsPresenterProtocol?
    
    fileprivate var transition = CustomFlipTransition(duration: 0.5)
    
    private var listAddedExcursions = [ExcursionData]()
    
    private var isLoaded: Bool = false
    
    var countAnimations = 0
    
    private let cardCollection: ExcursionsCollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        
        return ExcursionsCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    }()
    
    var currentTableAnimation: TableAnimation = .moveUpWithFade(rowHeight: 50, duration: 0.5, delay: 0.05)
    var animationDuration: TimeInterval = 0.85
    var delay: TimeInterval = 0.05
    var fontSize: CGFloat = 26
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isLoaded = false
        countAnimations = 0
        cardCollection.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.didLoadView()
        view.backgroundColor = .systemBackground
        cardCollection.dataSource = self
        //cardCollection.delegate = self
        self.transitioningDelegate = self
        self.transitioningDelegate = self
        
        
        cardCollection.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        
        if let layout = cardCollection.collectionViewLayout as? CustomCardLayout {
            layout.titleHeight = 100
            layout.bottomShowCount = 20
            layout.cardHeight = 300
        }
        
        view.addSubview(cardCollection)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cardCollection.pin.all(view.pin.safeArea)
    }
}

extension AddedExcursionsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listAddedExcursions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell
        
        guard let cell = cell else {
            return .init()
        }
        
        cell.configure(with: listAddedExcursions[indexPath.row])
        
        if !isLoaded {
            let animation = currentTableAnimation.getAnimation()
            let animator = TableViewAnimator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: collectionView)
            print(indexPath.row)
            if countAnimations > 8 {
                isLoaded = true
            }
            countAnimations += 1
        }
        
        
        return cell
    }
}



extension AddedExcursionsViewController: AddedExcursionsView {
    func reloadData(with listExcursions: [ExcursionData]) {
        listAddedExcursions = listExcursions
        cardCollection.reloadData()
    }
}

extension AddedExcursionsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        if let custom = cardCollection.collectionViewLayout as? CustomCardLayout, let path = custom.selectPath {
            transition.cardView = cardCollection.cellForItem(at: path)
            custom.isFullScreen = true
        }
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        if let custom = cardCollection.collectionViewLayout as? CustomCardLayout {
            custom.isFullScreen = false
        }
        
        return transition
    }
}
