//
//  CollectionViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// CollectionViewExampleViewController demonstrates how to create a UICollectionView programmatically
/// using a flow layout. It loads an array of color names from a JSON file (via DataLoader) and displays
/// each color in a cell. Tapping a cell prints the selected color's name.
///
/// The view controller implements the following protocols:
/// - **UICollectionViewDataSource**: Supplies the collection view with data and configures cells.
/// - **UICollectionViewDelegateFlowLayout**: Manages the layout, including cell sizing and spacing.
/// - **UICollectionViewDelegate**: Handles user interactions, such as selection.
class CollectionViewExampleViewController: UIViewController {

    // MARK: - Properties
    
    /// Holds an array of color names loaded from a JSON file.
    /// The JSON file should provide a string representation for each color (e.g., "systemRed", "systemBlue").
    private var colors: [String] = []
    
    /// The UICollectionView that displays the colored cells.
    /// It is configured with a flow layout that manages inter-item spacing and cell arrangement.
    private lazy var collectionView: UICollectionView = {
        // Create a flow layout object which arranges cells in a grid-like format.
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10    // Space between cells in the same row.
        layout.minimumLineSpacing = 10         // Space between rows.
        
        // Initialize the collection view with the flow layout.
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Register a cell class for reuse, using the reuse identifier "ColorCell".
        // Reuse identifiers allow cells to be recycled, which improves performance.
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    // MARK: - Lifecycle Methods
    
    /// Called once the view controller's view has been loaded.
    /// Responsibilities:
    /// - Configure the UI (background color, title).
    /// - Load mock data from the JSON file.
    /// - Setup and add the collection view to the view hierarchy.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "CollectionView Example"
        
        // Load mock data from the JSON file using DataLoader.
        loadMockData()
        
        // Setup the collection view's layout and constraints.
        setupCollectionView()
        
        // Set self as the data source and delegate to handle data and interactions.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Data Loading
    
    /// Loads the mock color data from the JSON file using the DataLoader helper.
    ///
    /// Theory:
    /// - The DataLoader is responsible for reading and decoding a JSON file into a model,
    ///   ensuring centralized data management across the app.
    /// - The `colors` property is updated with an array of strings representing color names.
    private func loadMockData() {
        if let mockData = DataLoader.loadMockData() {
            self.colors = mockData.colors
        } else {
            self.colors = ["No Data"]
        }
    }
    
    // MARK: - Setup Methods
    
    /// Adds the collection view to the view hierarchy and applies Auto Layout constraints.
    ///
    /// Theory:
    /// - By adding the collection view programmatically, we have full control over its layout,
    ///   constraints, and behavior without relying on Interface Builder.
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        // Constrain the collection view to the safe area of the main view.
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
    /// - This method acts as a mapper between our mock JSON data (color names) and actual UIColor objects.
    /// - In a production environment, more sophisticated methods (or a complete mapping) might be used.
    ///
    /// - Parameter colorName: A string representing the color (e.g., "systemRed").
    /// - Returns: The corresponding UIColor; returns .black if no match is found.
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
//
// The UICollectionViewDataSource protocol provides the necessary methods to supply
// data for the collection view, including the number of items and how to configure each cell.
extension CollectionViewExampleViewController: UICollectionViewDataSource {
    
    /// Tells the collection view how many items (cells) to display in a given section.
    /// In this example, the number is derived from the count of the `colors` array.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: The section index (we have a single section).
    /// - Returns: The number of items to display.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    /// Asks the data source for the cell to display at the specified index path.
    ///
    /// Theory:
    /// - This method dequeues a reusable cell using the reuse identifier "ColorCell".
    /// - The cell is configured with a background color determined by the color name.
    /// - The reuse mechanism ensures that cells are recycled, which is critical for performance.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting the cell.
    ///   - indexPath: The index path of the cell.
    /// - Returns: A fully configured UICollectionViewCell object.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        
        // Convert the color name from the data into a UIColor.
        let colorName = colors[indexPath.item]
        cell.backgroundColor = colorFromString(colorName)
        
        // Optionally, configure the cell further by adding a label, border, etc.
        // For instance, you could add a label to display the colorName.
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout & UICollectionViewDelegate
//
// UICollectionViewDelegateFlowLayout extends the basic delegate methods,
// allowing you to customize the size of cells, spacing between them, and overall layout.
// UICollectionViewDelegate handles user interactions like cell selection.
extension CollectionViewExampleViewController: UICollectionViewDelegateFlowLayout {
    
    /// Asks the delegate for the size of the cell at a given index path.
    ///
    /// Theory:
    /// - You can dynamically calculate the cell size based on the collection view’s dimensions
    ///   or return a fixed size. In this example, we aim for a two-column layout.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting the cell size.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - indexPath: The index path of the cell.
    /// - Returns: The size (width and height) of the cell.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the available width by subtracting total spacing.
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 3   // two cells require three spacing segments: left, middle, right.
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        // We desire two columns of equal width.
        let cellWidth = availableWidth / 2
        
        // Returning a square cell (width and height are equal).
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    /// Called when the user selects an item (cell) in the collection view.
    ///
    /// Theory:
    /// - This delegate method handles selection events.
    /// - In this example, when a cell is tapped, we print the selected color’s name,
    ///   and you could extend this to navigate or perform other actions.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view informing the delegate of the selection.
    ///   - indexPath: The index path of the selected item.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorName = colors[indexPath.item]
        print("Selected color:", colorName)
        
        // Optionally, you could deselect the cell or add additional actions.
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    /// Optional: Specifies the inset (margins) for the section.
    ///
    /// Theory:
    /// - Section insets add padding around the items in a section.
    /// - Here, we add a 10-point inset on all sides.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting the insets.
    ///   - collectionViewLayout: The layout object requesting the information.
    ///   - section: The index of the section.
    /// - Returns: The insets for the section.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
