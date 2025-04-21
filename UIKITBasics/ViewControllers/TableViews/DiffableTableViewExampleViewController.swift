//
//  DiffableTableViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// DiffableTableViewExampleViewController demonstrates how to create a UITableView that uses
/// a diffable data source (introduced in iOS 13) to manage its data.
///
/// Diffable data sources simplify updating a table view by allowing you to create a snapshot of your data
/// and then apply that snapshot to the table view. The system then automatically animates any changes
/// (insertions, deletions, moves) between snapshots.
///
/// This view controller loads mock data from a JSON file, similar to TableViewExampleViewController,
/// and uses a diffable data source to display the list of fruits.
class DiffableTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Enumeration representing the section(s) in our table view.
    /// Using an enum provides type safety and clarity.
    enum Section {
        case main
    }
    
    /// Data model: an array of fruit names loaded from the JSON file.
    private var fruits: [String] = []
    
    /// The UITableView that will display the fruit list.
    /// It is created programmatically and added to the view hierarchy.
    private let tableView: UITableView = {
        let table = UITableView()
        // Register a default UITableViewCell using a reuse identifier.
        // Reuse of cells greatly improves scrolling performance and memory efficiency.
        table.register(UITableViewCell.self, forCellReuseIdentifier: "FruitCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    /// The diffable data source for the table view.
    /// This property will manage the data and automatically update the table view using snapshots.
    private var dataSource: UITableViewDiffableDataSource<Section, String>!
    
    // MARK: - Lifecycle Methods
    
    /// Called after the view has been loaded into memory.
    /// Here, we:
    /// - Set the UI properties.
    /// - Load the data from the JSON file.
    /// - Configure the table view and its diffable data source.
    /// - Apply the initial snapshot to display the data.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Diffable TableView Example"
        
        // Load mock data from our JSON file.
        loadMockData()
        
        // Set up the table view's layout.
        setupTableView()
        
        // Configure the diffable data source.
        configureDataSource()
        
        // Apply the initial snapshot to show our data.
        applyInitialSnapshot()
    }
    
    // MARK: - Data Loading
    
    /// Loads mock data from the JSON file using the DataLoader helper.
    ///
    /// Theory:
    /// - The DataLoader is responsible for reading and decoding the JSON file into model objects.
    /// - The loaded data (an array of fruits) is then assigned to our local `fruits` property.
    private func loadMockData() {
        if let mockData = DataLoader.loadMockData() {
            self.fruits = mockData.fruits
        } else {
            self.fruits = ["No Data"]
        }
    }
    
    // MARK: - Setup Methods
    
    /// Adds the table view to the view hierarchy and applies Auto Layout constraints to position it.
    private func setupTableView() {
        view.addSubview(tableView)
        
        // Set Auto Layout constraints to anchor the table view to the view's safe area.
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Configures the diffable data source for the table view.
    ///
    /// Theory:
    /// - A diffable data source replaces the traditional UITableViewDataSource methods by relying on snapshots.
    /// - The initializer takes a table view and a cell provider closure that is responsible for dequeuing and configuring cells.
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, fruit) -> UITableViewCell? in
                // Dequeue a reusable cell using the reuse identifier "FruitCell".
                let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell", for: indexPath)
                // Configure the cell with the provided fruit.
                cell.textLabel?.text = fruit
                return cell
            }
        )
    }
    
    /// Creates and applies an initial snapshot to the diffable data source.
    ///
    /// Theory:
    /// - A snapshot is a representation of the current state of the data.
    /// - By applying a snapshot, the diffable data source computes the differences between snapshots
    ///   and automatically updates the UI with animations.
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fruits, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
//
// Although diffable data sources manage data-related methods, you can still implement
// UITableViewDelegate methods to handle user interactions and customize appearance.
extension DiffableTableViewExampleViewController: UITableViewDelegate {
    
    /// Called when a row is selected.
    /// Theory:
    /// - This delegate method notifies that the user has tapped a row.
    /// - Here, we simply print the selected fruit and deselect the row to remove the highlight.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Retrieve the fruit corresponding to the selected row.
        if let fruit = dataSource.itemIdentifier(for: indexPath) {
            print("Selected fruit:", fruit)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Optional method: Called before a cell is displayed.
    /// Theory:
    /// - Customize the cell's appearance just before it appears on-screen.
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        // Example: Set a light gray background for the cell's content view.
        cell.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    /// Optional method: Specifies the row height.
    /// Theory:
    /// - Allows dynamic or fixed row heights. Here we return a constant value.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
