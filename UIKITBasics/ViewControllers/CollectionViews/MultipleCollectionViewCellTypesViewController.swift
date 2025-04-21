//
//  MultipleCollectionViewCellTypesViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// MultipleCollectionViewCellTypesViewController demonstrates how to use different cell types
/// in a single UICollectionView. This technique is commonly used in modern app interfaces
/// like news feeds, shopping apps, or content-rich home screens.
///
/// Theory:
/// - **Cell Reuse Identifiers:** Different cell types require unique reuse identifiers.
/// - **Cell Identification:** The collection view data source determines which cell type to use for each item.
/// - **Data Model Diversity:** The data model must accommodate different content types.
/// - **Polymorphic Cell Handling:** The collection view must be able to handle cells with different layouts and behaviors.
class MultipleCollectionViewCellTypesViewController: UIViewController {
    
    // MARK: - Model
    
    /// An enum representing different types of content items
    enum ItemType {
        case featured    // A large featured item (e.g., a banner)
        case regular     // A standard content item
        case compact     // A smaller, compact content item
    }
    
    /// A struct representing a content item with a type, title, and color
    struct ContentItem {
        let type: ItemType
        let title: String
        let color: UIColor
    }
    
    // MARK: - Properties
    
    /// Sample data items with different types
    private var items: [ContentItem] = [
        ContentItem(type: .featured, title: "Featured Item", color: .systemRed),
        ContentItem(type: .regular, title: "Regular Item 1", color: .systemBlue),
        ContentItem(type: .regular, title: "Regular Item 2", color: .systemGreen),
        ContentItem(type: .compact, title: "Compact 1", color: .systemOrange),
        ContentItem(type: .compact, title: "Compact 2", color: .systemPurple),
        ContentItem(type: .compact, title: "Compact 3", color: .systemTeal),
        ContentItem(type: .regular, title: "Regular Item 3", color: .systemIndigo),
        ContentItem(type: .featured, title: "Another Featured Item", color: .systemYellow),
        ContentItem(type: .compact, title: "Compact 4", color: .systemGray),
        ContentItem(type: .regular, title: "Regular Item 4", color: .systemPink)
    ]
    
    /// The collection view configured with a compositional layout.
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Register different cell classes with unique reuse identifiers
        cv.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: "FeaturedCell")
        cv.register(RegularCollectionViewCell.self, forCellWithReuseIdentifier: "RegularCell")
        cv.register(CompactCollectionViewCell.self, forCellWithReuseIdentifier: "CompactCell")
        
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Multiple Cell Types"
        
        setupCollectionView()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the collection view by adding it to the view hierarchy and setting its data source and delegate.
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Creates a compositional layout for the collection view.
    /// This uses different section layouts based on the cell type.
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // Since we're not using sections to distinguish between cell types,
            // we'll use a uniform grid layout for simplicity
            
            // Create a standard grid layout with 2 items per row
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(100)  // Use estimated height for dynamic sizing
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)  // Use estimated height for dynamic sizing
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
            
            return section
        }
        
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension MultipleCollectionViewCellTypesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        
        // Determine which cell type to use based on the item type
        switch item.type {
        case .featured:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FeaturedCell",
                for: indexPath
            ) as! FeaturedCollectionViewCell
            
            cell.configure(with: item.title, color: item.color)
            return cell
            
        case .regular:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "RegularCell",
                for: indexPath
            ) as! RegularCollectionViewCell
            
            cell.configure(with: item.title, color: item.color)
            return cell
            
        case .compact:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CompactCell",
                for: indexPath
            ) as! CompactCollectionViewCell
            
            cell.configure(with: item.title, color: item.color)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MultipleCollectionViewCellTypesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        print("Selected \(item.type) item: \(item.title)")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Cell Classes

/// FeaturedCollectionViewCell represents a large, prominent cell type
class FeaturedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let featuredImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "star.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        contentView.addSubview(featuredImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Featured Image
            featuredImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            featuredImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            featuredImageView.widthAnchor.constraint(equalToConstant: 40),
            featuredImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: featuredImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Set a specific height for featured cells
            contentView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with title: String, color: UIColor) {
        titleLabel.text = title
        backgroundColor = color
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        backgroundColor = nil
    }
}

/// RegularCollectionViewCell represents a standard content cell
class RegularCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Set a specific height for regular cells
            contentView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with title: String, color: UIColor) {
        titleLabel.text = title
        backgroundColor = color
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        backgroundColor = nil
    }
}

/// CompactCollectionViewCell represents a small, compact content cell
class CompactCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Set a specific height for compact cells
            contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with title: String, color: UIColor) {
        titleLabel.text = title
        backgroundColor = color
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        backgroundColor = nil
    }
}
