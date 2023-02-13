//
//  ColorPickerViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 10/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import UIKit

class ColorPickerViewController: UICollectionViewController {

    var storageManager: StorageManager { .shared }

    let reuseIdentifier = "ColorPickerCell"
    let columnCount = 3
    let margin : CGFloat = 10

    weak var selectionDelegate: IndexSelectionDelegate?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ViewHelper.setCollectionViewLayout(collectionView: collectionView, margin: margin)
    }
}

// MARK: - UICollectionViewDataSource protocol
extension ColorPickerViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AvatarPalette.allCases.count //  Constants.colors.count
    }
    
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        let selected = selectionDelegate?.indexIsSelected(self, at: indexPath.row) ?? false
        cell.backgroundColor = AvatarPalette(rawValue: indexPath.item)?.color
        cell.layer.borderColor = UIColor.accentColor.cgColor
        cell.layer.borderWidth = selected ? 2 : 0
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension ColorPickerViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.indexSelector(self, didSelect: indexPath.row)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ColorPickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columnCount)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
