//
//  8.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// EmbeddedCollectionViewCell is a custom UITableViewCell that contains a UICollectionView.
/// This is used to display a horizontal collection view within a table view.
class EmbeddedCollectionViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    /// The collection view inside the table view cell.
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // For horizontal scrolling, set scroll direction.
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmbeddedCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
