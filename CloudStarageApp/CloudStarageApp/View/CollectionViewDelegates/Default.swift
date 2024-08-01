//
//  DefaultGrid.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 24.07.2024.
//

import UIKit

protocol CollectionViewSelectableItemDelegate: AnyObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
//    var didSelectItem: ((_ indexPath: IndexPath) -> Void)? { get set }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration?
}

class DefaultCollectionViewDelegate: NSObject, CollectionViewSelectableItemDelegate {
    var didSelectItem: ((_ indexPath: IndexPath) -> Void)?
    let sectionInsets = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
    var cellDataSource = [CellDataModel]()
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        //let name = cellDataSource[indexPath.item].name
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                NetworkManager.shared.deleteReqest(name: "")
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                // TODO: shareUrl
            }
            let renameAction = UIAction(title: "Rename", image: UIImage(systemName: "pencil.circle")) { _ in
                // TODO: renameReqest
            }
            return UIMenu(title: "", children: [deleteAction, shareAction, renameAction])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
}
