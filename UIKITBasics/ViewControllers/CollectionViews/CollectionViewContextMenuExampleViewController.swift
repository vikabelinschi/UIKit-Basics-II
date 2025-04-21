//
//  6.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// CollectionViewContextMenuExampleViewController demonstrates how to use context menus in a UICollectionView.
/// When an item is long-pressed, a menu with actions appears.
class CollectionViewContextMenuExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Sample data for the collection view.
    private var items: [String] = ["Red", "Blue", "Green", "Orange", "Purple"]
    
    /// The collection view configured with a simple flow layout.
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ContextCollectionCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CollectionView Context Menus"
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewContextMenuExampleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return items.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContextCollectionCell", for: indexPath)
         cell.backgroundColor = .systemGray
         // Add a label to show the item text.
         cell.contentView.subviews.forEach { $0.removeFromSuperview() }
         let label = UILabel(frame: cell.contentView.bounds)
         label.textAlignment = .center
         label.textColor = .white
         label.text = items[indexPath.item]
         label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         cell.contentView.addSubview(label)
         return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewContextMenuExampleViewController: UICollectionViewDelegate {
    /// Provides a context menu configuration for the specified item.
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = "\(indexPath.item)" as NSString
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            // Create actions for the context menu.
            let infoAction = UIAction(title: "Info", image: UIImage(systemName: "info.circle")) { action in
                print("Info on \(self.items[indexPath.item])")
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Share \(self.items[indexPath.item])")
            }
            return UIMenu(title: "", children: [infoAction, shareAction])
        }
    }
}
