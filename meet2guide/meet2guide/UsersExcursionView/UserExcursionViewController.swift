//
//  UserExcursionViewController.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 01.06.2022.
//

import Foundation
import UIKit
import PinLayout


protocol UserExcursionView: AnyObject {
    func reloadData(with listExcursions: [ExcursionData])
    
    func showAlert(alert: UIAlertController)
    
    func getExcursions() -> [ExcursionData]
    
    func openExcursion(with id: String)
}

class UserExcursionViewController: UIViewController {
    var output: UserExcursionPresenterProtocol?
    
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
    
    private let emptyPageLabel: UILabel = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isLoaded = false
        countAnimations = 0
        cardCollection.reloadData()
        if listAddedExcursions.isEmpty {
            emptyPageLabel.isHidden = false
        } else {
            emptyPageLabel.isHidden = true
        }
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
        
        
        cardCollection.register(ExcursionCardCell.self, forCellWithReuseIdentifier: "ExcursionCardCell")
        
        if let layout = cardCollection.collectionViewLayout as? CustomCardLayout {
            layout.titleHeight = 100
            layout.bottomShowCount = 20
            layout.cardHeight = 300
        }
        
        emptyPageLabel.text = "Пока пусто :("
        emptyPageLabel.textColor = .systemGray6
        emptyPageLabel.font = UIFont(name: "Montserrat-Bold", size: 30)
        
        view.addSubview(cardCollection)
        
        view.addSubview(emptyPageLabel)
        
        emptyPageLabel.isHidden = true
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        emptyPageLabel.pin
            .center()
            .sizeToFit()
        
        cardCollection.pin
            .all(view.pin.safeArea)
    }
}

extension UserExcursionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listAddedExcursions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExcursionCardCell", for: indexPath) as? ExcursionCardCell
        
        guard let cell = cell else {
            return .init()
        }
        
        cell.configure(with: listAddedExcursions[indexPath.row], output: output)
        
        print(listAddedExcursions.count)
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



extension UserExcursionViewController: UserExcursionView {
    func reloadData(with listExcursions: [ExcursionData]) {
        listAddedExcursions = listExcursions
        cardCollection.reloadData()
        if listExcursions.isEmpty {
            emptyPageLabel.isHidden = false
        } else {
            emptyPageLabel.isHidden = true
        }
    }
    
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func getExcursions() -> [ExcursionData] {
        return listAddedExcursions
    }
    
    func openExcursion(with id: String) {
        let excursionViewController = GosistTourAssembler.make(idExcursion: id, isAdding: false)
        let navigationController = UINavigationController(rootViewController: excursionViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension UserExcursionViewController: UIViewControllerTransitioningDelegate {
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
