//
//  dsa.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// CompositionalCollectionViewExampleViewController demonstrates the use of a modern UICollectionViewCompositionalLayout.
/// It creates two sections:
/// - Section 1: A standard grid (2 columns).
/// - Section 2: A horizontal scrolling section.
class CompositionalCollectionViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Sample data for demonstration.
    /// Each section is represented as an array of strings.
    private var gridItems = Array(1...10).map { "Item \($0)" }
    private var horizontalItems = Array(1...5).map { "HItem \($0)" }
    
    /// The collection view configured with a compositional layout.
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Compositional Layout"
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    // MARK: - Layout Setup
    
    /// Sets up the collection view and adds it to the view.
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Creates a compositional layout that defines two distinct sections.
    private func createCompositionalLayout() -> UICollectionViewLayout {
        // The layout uses a section provider closure that returns a layout for each section.
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            // Section 0: A simple grid layout with 2 columns.
            if sectionIndex == 0 {
                // Item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                        heightDimension: .absolute(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                // Group: 2 items in a row
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                         heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
            }
            // Section 1: A horizontal scrolling section.
            else {
                // Item: Full height and fixed width
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                                        heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                // Group: Single row group for horizontal scrolling.
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                                         heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section: Enable horizontal scrolling.
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
            }
        }
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension CompositionalCollectionViewExampleViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2  // Two sections as defined above.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return gridItems.count
        } else {
            return horizontalItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = (indexPath.section == 0) ? .systemBlue : .systemGreen
        
        // Remove any previous label (for reuse)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add a label to display the item text.
        let label = UILabel(frame: cell.contentView.bounds)
        label.textAlignment = .center
        label.textColor = .white
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.text = (indexPath.section == 0) ? gridItems[indexPath.item] : horizontalItems[indexPath.item]
        cell.contentView.addSubview(label)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CompositionalCollectionViewExampleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Simple selection print.
        if indexPath.section == 0 {
            print("Selected grid item: \(gridItems[indexPath.item])")
        } else {
            print("Selected horizontal item: \(horizontalItems[indexPath.item])")
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
