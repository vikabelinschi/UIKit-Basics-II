//
//  123.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// DragDropCollectionViewExampleViewController demonstrates basic drag and drop functionality
/// in a UICollectionView. It allows the user to reorder cells within the collection view.
class DragDropCollectionViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Data model for the collection view.
    private var items: [String] = Array(1...10).map { "Item \($0)" }
    
    /// The collection view configured with a simple flow layout.
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DragCell")
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dragInteractionEnabled = true  // Enable drag interactions.
        cv.dataSource = self
        cv.delegate = self
        cv.dragDelegate = self    // Set self as the drag delegate.
        cv.dropDelegate = self    // Set self as the drop delegate.
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drag & Drop CollectionView"
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    // MARK: - Setup Methods
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension DragDropCollectionViewExampleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DragCell", for: indexPath)
        cell.backgroundColor = .systemTeal
        
        // Remove previous label (for reuse).
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel(frame: cell.contentView.bounds)
        label.textAlignment = .center
        label.textColor = .white
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.text = items[indexPath.item]
        cell.contentView.addSubview(label)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DragDropCollectionViewExampleViewController: UICollectionViewDelegateFlowLayout {
    // Provide cell size for a simple grid.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 3 // three columns
        return CGSize(width: width, height: width)
    }
}

// MARK: - UICollectionViewDragDelegate
extension DragDropCollectionViewExampleViewController: UICollectionViewDragDelegate {
    
    // Provide drag items for the given index path.
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        let item = items[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

// MARK: - UICollectionViewDropDelegate
extension DragDropCollectionViewExampleViewController: UICollectionViewDropDelegate {
    
    // Handle dropping items into the collection view.
    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.sourceIndexPath,
               let item = dropItem.dragItem.localObject as? String {
                collectionView.performBatchUpdates({
                    // Update data model.
                    items.remove(at: sourceIndexPath.item)
                    items.insert(item, at: destinationIndexPath.item)
                    // Move the item in the collection view.
                    collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                })
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    // Optional: Specify the drop proposal.
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
