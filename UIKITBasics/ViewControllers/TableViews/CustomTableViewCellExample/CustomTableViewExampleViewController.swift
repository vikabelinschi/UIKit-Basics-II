//
//  CustomTableViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// CustomTableViewExampleViewController demonstrates how to use a custom UITableViewCell
/// (FruitTableViewCell) in a table view.
///
/// It implements UITableViewDataSource and UITableViewDelegate to manage data and handle interactions.
///
/// Theory:
/// - **UITableViewDataSource:** Provides the data and cell configuration for the table view.
///   This includes methods for the number of rows and creating each cell.
/// - **UITableViewDelegate:** Manages user interactions such as cell selection and optionally the layout (e.g., row heights).
/// - Using a custom cell allows for a richer display (combining image and text in this case) compared to standard cells.
class CustomTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// An array of fruit names to display in the table view.
    private var fruits: [String] = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    
    /// An array of system image names used as placeholders for the fruit images.
    /// In a real application, these might be custom images from your asset catalog.
    private var fruitImages: [String] = ["applelogo", "iphone", "globe", "star", "bolt.fill"]
    
    /// The UITableView that will display the list of fruits using custom cells.
    private let tableView: UITableView = {
        let table = UITableView()
        // Register our custom cell class with a reuse identifier.
        table.register(FruitTableViewCell.self, forCellReuseIdentifier: "FruitCustomCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    
    /// Called when the view has been loaded into memory.
    /// Configures the view by setting the background color, title, and setting up the table view.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Custom Cell TableView"
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    /// Adds the table view to the view, sets its data source and delegate, and applies Auto Layout constraints.
    ///
    /// Theory:
    /// - By assigning the view controller as the data source and delegate, we enable the custom
    ///   implementation of methods to populate cells and handle selections.
    /// - Constraints ensure the table view fills the screen appropriately.
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Constrain the table view to the safe area of the main view.
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension CustomTableViewExampleViewController: UITableViewDataSource {
    
    /// Returns the number of sections in the table view.
    /// In this example, there is only one section.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Returns the number of rows in the section, which is the count of the fruits array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    /// Dequeues and configures a custom cell for the given index path.
    ///
    /// Theory:
    /// - The cell is dequeued using the reuse identifier "FruitCustomCell" (registered in setupTableView).
    /// - The custom cell (FruitTableViewCell) is cast so that we can access its subviews (fruitImageView and fruitNameLabel).
    /// - The cell is configured by setting its label and image based on the corresponding fruit and image arrays.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Dequeue a reusable cell of type FruitTableViewCell.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCustomCell", for: indexPath) as? FruitTableViewCell else {
            fatalError("Unable to dequeue FruitTableViewCell")
        }
        
        // Configure the cell's label with the fruit name.
        cell.fruitNameLabel.text = fruits[indexPath.row]
        
        // For demonstration, use a system image. In a real app, you might load actual images.
        // The fruitImages array cycles through the available image names.
        let imageName = fruitImages[indexPath.row % fruitImages.count]
        cell.fruitImageView.image = UIImage(systemName: imageName)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CustomTableViewExampleViewController: UITableViewDelegate {
    
    /// Handles the event when a user selects a cell.
    ///
    /// Theory:
    /// - Selecting a cell typically triggers an action, such as navigating to a detail view.
    /// - Here we print the selected fruit and then deselect the cell to remove the highlight.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected fruit: \(fruits[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Provides the height for each row.
    /// In this example, a fixed height of 60 points is returned.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
