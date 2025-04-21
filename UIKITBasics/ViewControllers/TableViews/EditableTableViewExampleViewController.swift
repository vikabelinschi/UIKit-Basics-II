//
//  EditableTableViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// EditableTableViewExampleViewController demonstrates table view editing functionality including:
/// - Row deletion using swipe actions or edit mode
/// - Row reordering with drag handles in edit mode
/// - Adding new items with an Add button
///
/// Key UITableView editing concepts:
/// 1. **Editing Mode**: A state that shows deletion controls and reordering controls
/// 2. **Data Model Synchronization**: Keeping your data model updated when rows are moved or deleted
/// 3. **EditButton**: Using the system-provided edit button to toggle editing mode
/// 4. **Swipe-to-Delete**: Enabling swipe actions for deletion outside of editing mode
class EditableTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Data model for the table view.
    /// When items change due to user edits, the data model must be updated accordingly.
    private var items: [String] = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    
    /// The table view displaying the items.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "EditableCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    /// Button to add new items to the list
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Item", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Editable & Reorder TableView"
        setupTableView()
        setupAddButton()
        
        // Set up the navigation bar edit button
        setupNavigationBarButtons()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the table view with constraints and assigns delegate/datasource
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // By default, set tableView.allowsSelection to true (default)
        // and tableView.allowsSelectionDuringEditing to false (default)
        // This means cells can be selected normally, but not when in editing mode
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    /// Sets up the Add button with constraints and action
    private func setupAddButton() {
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    /// Sets up navigation bar buttons including the Edit button
    private func setupNavigationBarButtons() {
        // The editButtonItem is a built-in UIBarButtonItem that toggles the view controller's
        // editing state and changes its title between "Edit" and "Done" automatically
        navigationItem.rightBarButtonItem = editButtonItem
        
        // You can also customize the edit button's appearance:
        // let customEditButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        // navigationItem.rightBarButtonItem = customEditButton
    }
    
    // MARK: - Editing Mode
    
    /// Called when the editing state of the view controller changes.
    /// This method propagates the editing state to the table view.
    ///
    /// The system automatically calls this method when:
    /// - The user taps the Edit/Done button (editButtonItem)
    /// - The `isEditing` property of the view controller changes
    ///
    /// Theory:
    /// - When a table view enters editing mode, it shows:
    ///   - Red deletion controls on the left side of cells
    ///   - Reordering controls on the right side of cells if canMoveRowAt returns true
    /// - When not in editing mode, cells appear normally
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Set the table view's editing mode to match the view controller's
        tableView.setEditing(editing, animated: animated)
        
        // You can also update other UI elements based on editing state
        // For example, disable the Add button while in editing mode
        addButton.isEnabled = !editing
    }
    
    // MARK: - Actions
    
    /// Adds a new item to the table view when the Add button is tapped
    @objc private func addButtonTapped() {
        // Create an alert with a text field to enter a new item
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter item name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let text = alert.textFields?.first?.text,
                  !text.isEmpty else { return }
            
            // Update the data model
            self.items.append(text)
            
            // Insert the new row with animation
            let newIndexPath = IndexPath(row: self.items.count - 1, section: 0)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
    
    /// Custom method to toggle editing mode (alternative to using editButtonItem)
    @objc private func toggleEditing() {
        // Toggle the isEditing property with animation
        setEditing(!isEditing, animated: true)
        
        // If using a custom button, update its title
        // let buttonTitle = isEditing ? "Done" : "Edit"
        // navigationItem.rightBarButtonItem?.title = buttonTitle
    }
}

// MARK: - UITableViewDataSource
extension EditableTableViewExampleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditableCell", for: indexPath)
        
        // Configure cell with content configuration (modern approach)
        var content = cell.defaultContentConfiguration()
        content.text = items[indexPath.row]
        cell.contentConfiguration = content
        
        // Standard cell configuration (traditional approach)
        // cell.textLabel?.text = items[indexPath.row]
        
        // Set the insertion and deletion animation styles
        cell.showsReorderControl = true  // Shows the reorder control in edit mode
        
        return cell
    }
    
    /// Tells the table view whether a row can be moved.
    /// Return true to enable reordering for all rows, or customize which rows can be moved.
    ///
    /// Theory:
    /// - When this returns true for a row, the reorder control appears on the right side in edit mode.
    /// - If it returns false, the row cannot be reordered.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true  // All rows can be moved
        
        // Example of selective reordering:
        // return indexPath.row != 0  // Can't move the first row
    }
    
    /// Called when a row is moved from one location to another.
    /// This is the critical method for updating your data model when rows are reordered.
    ///
    /// Theory:
    /// - The table view automatically handles the UI aspects of moving the cell.
    /// - Your responsibility is to update the underlying data model to match the new order.
    /// - If you don't update the data model, it will get out of sync with the UI.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Remove the item from its original position
        let movedItem = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        
        // Insert it at the destination position
        items.insert(movedItem, at: destinationIndexPath.row)
        
        // Note: No need to call tableView.moveRow() here - the table view already moved the cell visually
    }
    
    /// Handles commit of editing style (e.g., deletion) for a row.
    /// This method is called when:
    /// - The user taps the delete button in edit mode
    /// - The user completes a swipe-to-delete gesture
    ///
    /// Theory:
    /// - For deletion, you must:
    ///   1. Update your data model first (remove the item)
    ///   2. Then tell the table view to delete the row
    /// - The order is important to maintain consistency
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1. Update the data model
            items.remove(at: indexPath.row)
            
            // 2. Delete the row from the table view with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        else if editingStyle == .insert {
            // Handle insertion (if enabled)
            // This is rarely used - most apps use custom UI for insertion
        }
    }
    
    /// Optional: Control whether the specific editing control (insertion or deletion) is shown.
    /// This can be used to disable deletion for certain rows, or enable insertion controls.
    ///
    /// Default behavior if this method is not implemented:
    /// - All rows show deletion controls in editing mode
    /// - No rows show insertion controls unless editingStyle is explicitly set to .insert
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete  // Show deletion controls for all rows
        
        // Example of customizing by row:
        // if indexPath.row == 0 {
        //     return .none  // First row cannot be deleted
        // } else {
        //     return .delete  // All other rows can be deleted
        // }
    }
    
    /// Optional: Provide a title for the delete button.
    /// Default is "Delete" if this method is not implemented.
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"  // Custom delete button title
    }
}

// MARK: - UITableViewDelegate
extension EditableTableViewExampleViewController: UITableViewDelegate {
    
    /// Called when a row is selected.
    /// In a table view that supports both selection and editing, you may want to handle
    /// selections differently based on whether the table is in editing mode.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.isEditing {
            // Handle selection during editing mode (if needed)
            print("Selected row \(indexPath.row) during editing")
        } else {
            // Handle normal selection
            print("Selected item: \(items[indexPath.row])")
        }
    }
    
    /// Optional: Modern swipe actions configuration (iOS 11+)
    /// This provides more customization options than the commit editingStyle method.
    ///
    /// Theory:
    /// - Swipe actions can be configured for both leading and trailing edges
    /// - Multiple actions can be provided, with different colors and icons
    /// - This approach is more modern and flexible than commit editingStyle
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            // Update the data model
            self.items.remove(at: indexPath.row)
            
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Indicate the action was performed
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        // Create an edit action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            // Show alert to edit the item
            let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = self.items[indexPath.row]
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let self = self,
                      let text = alert.textFields?.first?.text,
                      !text.isEmpty else {
                    completionHandler(false)
                    return
                }
                
                // Update the data model
                self.items[indexPath.row] = text
                
                // Reload the row
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                completionHandler(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
            self.present(alert, animated: true)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        // Create and return the configuration with both actions
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true  // Enable full swipe for first action
        
        return configuration
    }
    
    /// Optional: Leading edge swipe actions (iOS 11+)
    /// Similar to trailing actions, but appears when swiping from left to right
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (_, _, completionHandler) in
            print("Marked \(self.items[indexPath.row]) as favorite")
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemOrange
        favoriteAction.image = UIImage(systemName: "star")
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    /// Optional: Controls whether the row should indent when editing mode begins
    /// Default is true if not implemented
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Optional: Informs the table view which rows can be edited
    /// Default is all rows if not implemented
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
        // Example of selective editing:
        // return indexPath.row != 0  // First row cannot be edited
    }
    
    /// Optional: Controls target index path for a proposed move
    /// Useful if you want to restrict where rows can be moved
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath
        
        // Example of restricted movement:
        // if proposedDestinationIndexPath.row == 0 {
        //     return IndexPath(row: 1, section: 0)  // Can't move to row 0
        // }
        // return proposedDestinationIndexPath
    }
}
