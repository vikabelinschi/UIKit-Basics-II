//
//  CustomLayoutCollectionViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// CustomLayoutCollectionViewExampleViewController demonstrates how to use a custom collection view layout.
/// In this example, we utilize the CustomCollectionViewLayout to create a waterfall layout where cells
/// are arranged in two columns with varying heights.
///
/// The view controller:
/// - Loads mock data (an array of color names) from a JSON file using DataLoader.
/// - Uses a helper method to convert a color name (String) into a UIColor.
/// - Configures a UICollectionView with the custom layout.
/// - Implements UICollectionViewDataSource and UICollectionViewDelegate methods with detailed inline explanations.
class CustomLayoutCollectionViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// An array of color names loaded from the JSON file.
    /// Example data: ["systemRed", "systemBlue", "systemGreen", ...]
    private var colors: [String] = []
    
    /// The collection view using our custom waterfall layout.
    /// It is created programmatically and configured with the custom layout.
    private lazy var collectionView: UICollectionView = {
        // Initialize the custom layout.
        let layout = CustomCollectionViewLayout()
        layout.numberOfColumns = 2     // Define a two-column layout.
        layout.cellPadding = 8.0       // Set padding around each cell.
        
        // Initialize the collection view with the custom layout.
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        // Register a default cell class with a reuse identifier.
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CustomColorCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Lifecycle Methods
    
    /// Called after the view controller's view has loaded.
    /// Responsibilities:
    /// - Configure the view (background color, title).
    /// - Load mock color data from a JSON file.
    /// - Setup the collection view with Auto Layout constraints.
    /// - Assign self as the collection view's data source and delegate.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Custom Layout CollectionView"
        
        // Load the mock data.
        loadMockData()
        
        // Setup the collection view's layout and add it to the view hierarchy.
        setupCollectionView()
        
        // Set self as the data source and delegate for handling data and user interactions.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Data Loading
    
    /// Loads mock color data from the JSON file using the DataLoader helper.
    ///
    /// Theory:
    /// - Centralizing mock data in a JSON file facilitates updates and reuse across examples.
    private func loadMockData() {
        if let mockData = DataLoader.loadMockData() {
            self.colors = mockData.colors
        } else {
            self.colors = ["No Data"]
        }
    }
    
    // MARK: - Setup Methods
    
    /// Adds the collection view to the view hierarchy and applies Auto Layout constraints.
    /// The constraints ensure that the collection view fills the view's safe area, with custom side margins.
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Helper Methods
    
    /// Converts a given color name (String) into a corresponding UIColor.
    ///
    /// Theory:
    /// - This method maps string values from the JSON file to actual UIColor values used to color cells.
    /// - In production code, a more comprehensive mapping or a dedicated model might be used.
    ///
    /// - Parameter colorName: A String representing the color (e.g., "systemRed").
    /// - Returns: A UIColor corresponding to the given name, defaulting to .black if no match is found.
    private func colorFromString(_ colorName: String) -> UIColor {
        switch colorName {
        case "systemRed": return .systemRed
        case "systemBlue": return .systemBlue
        case "systemGreen": return .systemGreen
        case "systemOrange": return .systemOrange
        case "systemPurple": return .systemPurple
        case "systemYellow": return .systemYellow
        case "brown": return .brown
        case "magenta": return .magenta
        case "cyan": return .cyan
        default: return .black
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CustomLayoutCollectionViewExampleViewController: UICollectionViewDataSource {
    
    /// Returns the number of items in the section.
    /// The count is based on the number of color names loaded from the JSON file.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    /// Asks for the cell for a given index path.
    /// The cell is configured by setting its background color using the helper method `colorFromString(_:)`.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell using the "CustomColorCell" identifier.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomColorCell", for: indexPath)
        let colorName = colors[indexPath.item]
        cell.backgroundColor = colorFromString(colorName)
        
        // Optional customization: You could add labels or images to the cell here.
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CustomLayoutCollectionViewExampleViewController: UICollectionViewDelegate {
    
    /// Called when the user selects an item in the collection view.
    /// Prints the selected color's name and deselects the item.
    ///
    /// Theory:
    /// - This method handles user interactions. In a real-world app, selection might trigger navigation
    ///   or detailed view presentation.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorName = colors[indexPath.item]
        print("Selected color:", colorName)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
