//
//  TableViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// TableViewExampleViewController demonstrates how to create a UITableView programmatically,
/// using mock data loaded from a separate JSON file.
///
/// The view controller implements the protocols:
/// - **UITableViewDataSource**: Provides the data and cells for the table view.
/// - **UITableViewDelegate**: Manages user interactions and appearance customization.
///
/// These protocols work together to create a dynamic and responsive table view.
class TableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Holds the fruit data loaded from a JSON file.
    /// This array is used as the data source for our table view.
    private var fruits: [String] = []
    
    /// The UITableView that will display the list of fruits.
    /// Configured programmatically, this table view uses auto-layout and is added to the view hierarchy.
    private let tableView: UITableView = {
        let table = UITableView()
        
        // Register a cell class with a reuse identifier.
        // The reuse identifier "FruitCell" is crucial because it allows the table view
        // to recycle cells when scrolling rather than creating new ones for every row.
        // This mechanism enhances performance and reduces memory usage.
        table.register(UITableViewCell.self, forCellReuseIdentifier: "FruitCell")
        
        // Disable autoresizing mask translation, as we are using Auto Layout constraints.
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    
    /// Called after the view controller's view has been loaded into memory.
    /// Responsibilities:
    /// - Set basic UI properties (background color, title).
    /// - Load the data to be displayed (in this case, fruits).
    /// - Setup and layout the table view in the view hierarchy.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "TableView Example"
        
        // Load the mock data from the external JSON file.
        loadMockData()
        // Configure and layout the table view.
        setupTableView()
    }
    
    // MARK: - Data Loading
    
    /// Loads mock data from a JSON file using the DataLoader helper class.
    ///
    /// Theory:
    /// - The DataLoader class encapsulates the logic needed to read a JSON file from the app bundle,
    ///   decode it into model objects (via the Codable protocol), and provide that data for use.
    /// - In this method, we assign the fruits property with the resulting data.
    private func loadMockData() {
        if let mockData = DataLoader.loadMockData() {
            self.fruits = mockData.fruits
        } else {
            // Provide a fallback if the data fails to load.
            self.fruits = ["No Data"]
        }
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the table view:
    /// - Adds it to the view hierarchy.
    /// - Sets self as its data source and delegate.
    /// - Applies Auto Layout constraints to position it relative to the view's safe area.
    ///
    /// Theory:
    /// - **Data Source Role**: Supplies the table view with data (number of rows, cells configuration).
    /// - **Delegate Role**: Manages user interactions and customizes display (cell selection, cell height, etc.).
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Activate constraints to fix the table view's edges to the view's safe area.
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
//
// The UITableViewDataSource protocol provides the data and cells for the table view.
// It is responsible for creating and configuring cells, as well as supplying section and row counts.
extension TableViewExampleViewController: UITableViewDataSource {
    
    /// Returns the number of sections in the table view.
    /// Theory:
    /// - A table view can have multiple sections (each section can have its own header, footer, and cells).
    /// - In this example, we return 1 because our data is simple.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Tells the table view how many rows to display in a given section.
    /// - Parameter tableView: The table view requesting this information.
    /// - Parameter section: The index number of the section.
    /// - Returns: The number of rows (cells) to display.
    ///
    /// Theory:
    /// - Here, we return the count of our data array (`fruits`), meaning one row per fruit.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    /// Provides the cell for a given index path.
    /// - Parameter tableView: The table view requesting the cell.
    /// - Parameter indexPath: The index path specifying the location of the cell.
    /// - Returns: A fully configured UITableViewCell object.
    ///
    /// Theory:
    /// - The method dequeues a reusable cell using the reuse identifier ("FruitCell").
    /// - Reusability is key to performance: cells that scroll offscreen are recycled for new rows.
    /// - The cell is then configured with data from the `fruits` array.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell", for: indexPath)
        cell.textLabel?.text = fruits[indexPath.row]
        return cell
    }
    
    /// Provides a title for the header of the specified section.
    /// - Parameter tableView: The table view requesting the title.
    /// - Parameter section: The index number of the section.
    /// - Returns: A string to be displayed as the section header.
    ///
    /// Theory:
    /// - Section headers can be used to label and organize groups of rows.
    /// - Even when there's only one section, providing a header can help give context to the displayed data.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Fruits List"
    }
    
    /// Indicates whether a row can be edited (e.g., for deletion).
    /// - Parameter tableView: The table view requesting this information.
    /// - Parameter indexPath: The index path of the row.
    /// - Returns: A Boolean value indicating whether the row is editable.
    ///
    /// Theory:
    /// - Allowing row editing provides users with options like deletion or insertion.
    /// - Here, all rows are editable, so we return true.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Commits an editing action (such as deletion) for a specified row.
    /// - Parameter tableView: The table view requesting the commit.
    /// - Parameter editingStyle: The style of editing being committed (e.g., delete).
    /// - Parameter indexPath: The index path of the row being edited.
    ///
    /// Theory:
    /// - This method updates the data model and the UI when a row is deleted or inserted.
    /// - In this example, we handle the delete action by removing the data from the `fruits` array
    ///   and then updating the table view with an animation.
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the data element from the model.
            fruits.remove(at: indexPath.row)
            // Update the UI by deleting the corresponding row.
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    /// Asks whether a row can be moved to a different location in the table view.
    /// - Parameter tableView: The table view requesting this information.
    /// - Parameter indexPath: The index path of the row.
    /// - Returns: A Boolean value indicating whether the row is movable.
    ///
    /// Theory:
    /// - This functionality is useful when users need to reorder items.
    /// - In this example, all rows are allowed to be moved, so we return true.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Informs the data source that a row has been moved from one location to another.
    /// - Parameter tableView: The table view performing the move.
    /// - Parameter sourceIndexPath: The original index path of the row.
    /// - Parameter destinationIndexPath: The new index path of the row.
    ///
    /// Theory:
    /// - When a row is moved, the underlying data model must also be updated to reflect the change.
    /// - This method adjusts the `fruits` array accordingly by removing the item from its original position
    ///   and inserting it at the new position.
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        let movedFruit = fruits[sourceIndexPath.row]
        fruits.remove(at: sourceIndexPath.row)
        fruits.insert(movedFruit, at: destinationIndexPath.row)
    }
}

// MARK: - UITableViewDelegate
//
// The UITableViewDelegate protocol defines methods that manage the appearance and behavior of the table view.
// It handles user interactions, such as selecting rows, and allows customization of cells before they appear.
extension TableViewExampleViewController: UITableViewDelegate {
    
    /// Notifies the delegate that a cell is about to be displayed in the table view.
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - cell: The cell that is about to be displayed.
    ///   - indexPath: The index path where the cell will be displayed.
    ///
    /// Theory:
    /// - This method is a chance to further customize or animate cells before they appear on the screen.
    ///   For example, you might change the cell background color or apply a custom animation.
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    /// Tells the delegate that a row was selected.
    /// - Parameters:
    ///   - tableView: The table view informing the delegate about the row selection.
    ///   - indexPath: The index path of the selected row.
    ///
    /// Theory:
    /// - Called when a user taps a cell.
    /// - Common uses include navigating to a detail view, updating the UI, or logging the selection.
    /// - After handling the selection, it’s customary to deselect the row so it does not remain highlighted.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Display the selected fruit in the console.
        print("Selected fruit:", fruits[indexPath.row])
        // Deselect the row with animation.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Specifies the height for the row at the given index path.
    /// - Parameters:
    ///   - tableView: The table view requesting the height.
    ///   - indexPath: The index path of the row.
    /// - Returns: The height (in points) for the row.
    ///
    /// Theory:
    /// - It allows custom row heights depending on content.
    /// - Here, a fixed height of 60 points is returned for each row.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    /// Notifies the delegate that editing of a row has ended.
    /// - Parameters:
    ///   - tableView: The table view informing the delegate.
    ///   - indexPath: The index path of the row that ended editing (optional).
    ///
    /// Theory:
    /// - This method can be used to perform cleanup or further updates once editing actions like deletion have completed.
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("Finished editing row")
    }
    
    /// Asks the delegate to return the index path that should be selected.
    /// - Parameters:
    ///   - tableView: The table view requesting the selection.
    ///   - indexPath: The index path proposed for selection.
    /// - Returns: The index path that should be selected, or nil if the row should not be selected.
    ///
    /// Theory:
    /// - This method allows you to control if a row can be selected.
    /// - You may use conditions to prevent selection of certain rows.
    /// - In this example, we simply return the provided index path to allow all selections.
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
}
