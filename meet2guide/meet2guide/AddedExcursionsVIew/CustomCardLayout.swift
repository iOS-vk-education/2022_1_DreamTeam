//
//  CustomCardLayout.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.05.2022.
//

import Foundation
import UIKit

class CardLayoutAttributes: UICollectionViewLayoutAttributes {
    var isExpand = false
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let attribute = super.copy(with: zone) as! CardLayoutAttributes
        attribute.isExpand = isExpand
        return attribute
    }
}

class CustomCardLayout: UICollectionViewFlowLayout {
    private var insertPath = Array<IndexPath>()
    private var deletePath = Array<IndexPath>()
    private var attributeList = Array<CardLayoutAttributes>()
    
    var _selectedPath: IndexPath? {
        didSet {
            collectionView?.isScrollEnabled = (_selectedPath == nil)
        }
    }
    
    
    public var selectPath: IndexPath? {
        set {
            _selectedPath = (_selectedPath == newValue) ? nil : newValue
            collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        } get {
            return _selectedPath
        }
    }
    
    public var bottomShowCount = 3 {
        didSet {
            collectionView?.performBatchUpdates({
                collectionView?.reloadData()
            }, completion: nil)
        }
    }
    
    public var isFullScreen = false {
        didSet {
            collectionView?.performBatchUpdates({
                collectionView?.reloadData()
            }, completion: nil)
        }
    }
    
    public var titleHeight: CGFloat = 56 {
        didSet {
            self.collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        }
    }
    
    public var cardHeight: CGFloat = 320 {
        didSet {
            var c = cellSize
            c.height = cardHeight
            cellSize = c
            collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        }
    }
    
    lazy var cellSize: CGSize = {
        guard let collection = collectionView else {
            return .zero
        }
        
        let bottomPercent = 0.85
        
        let wigth = collection.bounds.width
        let height = collection.bounds.height * bottomPercent
        return CGSize(width: wigth, height: height)
    }()
    
    override public var collectionViewContentSize: CGSize {
        guard let collection = collectionView else {
            return .zero
        }
        
        let sections = collection.numberOfSections
        let total = (0..<sections).reduce(0){ (t, current) -> Int in
            t + collection.numberOfItems(inSection: current)
        }
        
        let contentHeight = titleHeight * CGFloat(total-1) + cellSize.height
        return CGSize(width: cellSize.width, height: contentHeight )
    }
    
    func updateCellSize() {
        guard let collection = collectionView else {
            return
        }
        
        cellSize.width = collection.frame.width
        cellSize.height = cardHeight * 0.85
    }
    
    override func prepare() {
        super.prepare()
        guard let collection = collectionView else {
            return
        }
        let update = collection.calculate.isNeedUpdate()
        
        if let selectPath = selectPath, !update {
            let frames = calculate(for: attributeList, choose: selectPath)
            zip(attributeList, frames).forEach { couple in
                setSelect(for: couple.0, choose: selectPath, layout: couple.1)
            }
        } else {
            _selectedPath = nil
            if !update, collection.calculate.totalCount == attributeList.count {
                attributeList.forEach({
                    setNoSelect(attribute: $0)
                })
                return
            }
            let list = generateAttributeList
            if list.count > 0 {
                attributeList.removeAll()
                attributeList += list
            }
        }
    }
    
    private func calculate(for attributes: [CardLayoutAttributes],  choose selectedIP: IndexPath) -> [CGRect] {
        
        guard let collection = collectionView else {
            return []
        }
        let noneIdx = Int(collection.contentOffset.y / titleHeight)
        if noneIdx < 0 {
            return []
        }
        let x = collection.frame.origin.x
        
        var selectedIdx = 0
        for attr in attributes {
            if attr.indexPath == selectedIP {
                break
            }
            selectedIdx += 1
        }
        
        var frames = [CGRect](repeating: .zero, count: attributes.count)
        
        // Edit here
        let offsetSelected: CGFloat = 100
        let marginBottomSelected: CGFloat = 20
        frames[selectedIdx] = CGRect(x: x, y: collection.contentOffset.y + offsetSelected, width: cellSize.width, height: cellSize.height)
        if selectedIdx > 0 {
            for i in 0...(selectedIdx - 1) {
                frames[selectedIdx - i - 1] = CGRect(x: x, y: frames[selectedIdx].origin.y - titleHeight * CGFloat(i + 1), width: cellSize.width, height: cellSize.height)
            }
        }
        if selectedIdx < (attributes.count - 1){
            for i in (selectedIdx + 1)...(attributes.count - 1) {
                frames[i] = CGRect(x: x, y: frames[selectedIdx].origin.y + marginBottomSelected + titleHeight * CGFloat(i - selectedIdx - 1) + cellSize.height, width: cellSize.width, height: cellSize.height)
            }
        }
        
        return frames
    }
    
    private func setSelect(for attribute: CardLayoutAttributes, choose selectedIP: IndexPath, layout frame: CGRect) {
        if attribute.indexPath == selectedIP {
            attribute.isExpand = true
        } else {
            attribute.isExpand = false
        }
        attribute.frame = frame
    }
    
    private func setNoSelect(attribute: CardLayoutAttributes) {
        guard let collection = collectionView else {
            return
        }
        let noneIdx = Int(collection.contentOffset.y / titleHeight)
        if noneIdx < 0 {
            return
        }
        attribute.isExpand = false
        let index = attribute.zIndex
        var currentFrame = CGRect(x: collection.frame.origin.x, y: titleHeight * CGFloat(index), width: cellSize.width, height: cellSize.height)
        if index == noneIdx {
            attribute.frame = CGRect(x: currentFrame.origin.x, y: collection.contentOffset.y, width: cellSize.width, height: cellSize.height)
        } else if index <= noneIdx, currentFrame.maxY > collection.contentOffset.y {
            currentFrame.origin.y -= (currentFrame.maxY - collection.contentOffset.y )
            attribute.frame = currentFrame
        } else {
            attribute.frame = currentFrame
        }
    }
    
    private var generateAttributeList: [CardLayoutAttributes] {
        var arr = [CardLayoutAttributes]()
        guard let collection = collectionView else {
            return arr
        }
        let offsetY = max(collection.contentOffset.y, 0)
        let startIdx = abs(Int(offsetY / titleHeight))
        let sections = collection.numberOfSections
        var itemsIdx = 0
        
        for sec in 0..<sections {
            let count = collection.numberOfItems(inSection: sec)
            if (itemsIdx + count - 1) < startIdx {
                itemsIdx += count
                continue
            }
            for item in 0..<count {
                if itemsIdx >= startIdx {
                    let indexPath = IndexPath(item: item, section: sec)
                    let attr = CardLayoutAttributes(forCellWith: indexPath)
                    attr.zIndex = itemsIdx
                    setNoSelect(attribute: attr)
                    arr.append(attr)
                }
                itemsIdx += 1
            }
        }
        return arr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let first = attributeList.first(where: { $0.indexPath == indexPath
        }) else {
            return CardLayoutAttributes(forCellWith: indexPath)
        }
        
        return first
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collection = collectionView else {
            return nil
        }
        var reset = rect
        reset.origin.y = collection.contentOffset.y
        
        let arr = attributeList.filter {
            var fix = $0.frame
            fix.size.height = titleHeight
            return fix.intersects(reset)
        }
        return arr
    }
    
    override public func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let at = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        guard let collection = collectionView, let at = at else {
            return at
        }
        if deletePath.contains(itemIndexPath) {
            if let original = attributeList.first(where: { $0.indexPath == itemIndexPath }) {
                at.frame = original.frame
            }
            let randomLoc = (itemIndexPath.row % 2 == 0) ? 1 : -1
            let x = collection.frame.width * CGFloat(randomLoc)
            at.transform = CGAffineTransform(translationX: x, y: 0)
        }
        
        return at
    }
    
    override public func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let at = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        guard let collection = collectionView, let a = at else {
            return at
        }
        if self.insertPath.contains(itemIndexPath) {
            let randomLoc = (itemIndexPath.row%2 == 0) ? 1 : -1
            let x = collection.frame.width * CGFloat(-randomLoc)
            a.transform = CGAffineTransform(translationX: x, y: 0)
        }
        return a
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override public func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        deletePath.removeAll()
        insertPath.removeAll()
        for update in updateItems {
            if update.updateAction == .delete {
                
                let path = (update.indexPathBeforeUpdate != nil) ? update.indexPathBeforeUpdate : update.indexPathAfterUpdate
                if let p = path {
                    deletePath.append(p)
                }
            }
            else if let path = update.indexPathAfterUpdate, update.updateAction == .insert {
                insertPath.append(path)
            }
        }
    }
    
    override public func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        guard let collection = collectionView else {
            return
        }
        if deletePath.count > 0 || insertPath.count > 0 {
            deletePath.removeAll()
            insertPath.removeAll()
            
            let vi = collection.subviews.sorted {
                $0.layer.zPosition < $1.layer.zPosition
            }
            
            vi.forEach({ (vi) in
                collection.addSubview(vi)
            })
            
        }
    }
    
}
