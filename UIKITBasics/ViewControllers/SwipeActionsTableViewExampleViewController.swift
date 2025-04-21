//
//  12.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// SwipeActionsTableViewExampleViewController demonstrates how to add custom swipe actions to UITableView rows.
/// The table view displays a list of items, and users can swipe to reveal actions.
class SwipeActionsTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Sample data items.
    private var items: [String] = ["Item A", "Item B", "Item C", "Item D", "Item E"]
    
    /// The table view to display items.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SwipeCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "TableView Swipe Actions"
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension SwipeActionsTableViewExampleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return items.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeCell", for: indexPath)
         cell.textLabel?.text = items[indexPath.row]
         return cell
    }
}

// MARK: - UITableViewDelegate
extension SwipeActionsTableViewExampleViewController: UITableViewDelegate {
    
    // Trailing swipe actions: e.g., delete action.
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create a delete action.
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            // Remove the item from the data source.
            self?.items.remove(at: indexPath.row)
            // Delete the corresponding row.
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        // Return the configuration containing the delete action.
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    // Leading swipe actions: e.g., favorite action.
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { action, view, completionHandler in
            print("Favorited: \(self.items[indexPath.row])")
            completionHandler(true)
        }
        favoriteAction.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    // Optional: Handle row selection.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("Selected: \(items[indexPath.row])")
         tableView.deselectRow(at: indexPath, animated: true)
    }
}
