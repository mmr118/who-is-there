//
//  AvatarPickerViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 10/07/2017.
//  Copyright (c) 2017 Efe Kocabas. All rights reserved.
//

import UIKit

protocol IndexSelectionDelegate: AnyObject {
    func indexIsSelected(_ valueSelector: UICollectionViewController, at index: Int) -> Bool
    func indexSelector(_ valueSelector: UICollectionViewController, didSelect valueIndex: Int)
}

class AvatarPickerViewController: UICollectionViewController {

    let avatarCellReuseIdentifier = "AvatarPickerCell"
    let columnCount = 3
    let margin : CGFloat = 10
    let avatarCount = 8

    weak var selectionDelegate: IndexSelectionDelegate?
    
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewHelper.setCollectionViewLayout(collectionView: collectionView, margin: margin)
    }
}


// MARK: - UICollectionViewDataSource protocol
extension AvatarPickerViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Avatar.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: avatarCellReuseIdentifier, for: indexPath as IndexPath) as! AvatarPickerCell
        let selected = selectionDelegate?.indexIsSelected(self, at: indexPath.row) ?? false
        let avatar = Avatar(rawValue: indexPath.row) ?? .none
        cell.avatarImageView.image = avatar.uiImage
        cell.layer.borderColor = UIColor.accentColor.cgColor
        cell.layer.borderWidth = selected ? 2 : 0
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension AvatarPickerViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.indexSelector(self, didSelect: indexPath.item)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AvatarPickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columnCount)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}
