//
//  Untitled.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// AnimatedCollectionViewExampleViewController demonstrates adding custom animations to a UICollectionView.
/// When a cell is tapped, it scales down briefly before returning to its original size.
class AnimatedCollectionViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Sample data items.
    private var items = Array(1...12).map { "Cell \($0)" }
    
    /// The collection view with a basic flow layout.
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AnimatedCell")
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Animated CollectionView"
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
extension AnimatedCollectionViewExampleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimatedCell", for: indexPath)
         cell.backgroundColor = .systemIndigo
         
         // Remove any existing label to prevent duplication.
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

// MARK: - UICollectionViewDelegateFlowLayout
extension AnimatedCollectionViewExampleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
         // Calculate a 3-column layout.
         let totalSpacing: CGFloat = 20 // Considering insets and inter-item spacing.
         let width = (collectionView.bounds.width - totalSpacing) / 3
         return CGSize(width: width, height: width)
    }
}

// MARK: - UICollectionViewDelegate
extension AnimatedCollectionViewExampleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         // Retrieve the cell and animate a scale effect.
         if let cell = collectionView.cellForItem(at: indexPath) {
             UIView.animate(withDuration: 0.2, animations: {
                 cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2) {
                     cell.transform = .identity
                 }
             })
             print("Selected: \(items[indexPath.item])")
         }
         collectionView.deselectItem(at: indexPath, animated: true)
    }
}
