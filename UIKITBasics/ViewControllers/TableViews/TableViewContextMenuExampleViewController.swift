//
//  5.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// TableViewContextMenuExampleViewController demonstrates using context menus in a UITableView.
/// When a cell is long-pressed, a menu appears with defined actions.
class TableViewContextMenuExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Sample data for the table view.
    private var items: [String] = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    
    /// Table view to display items.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ContextCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "TableView Context Menus"
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self  // Needed to support context menus
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension TableViewContextMenuExampleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return items.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ContextCell", for: indexPath)
         cell.textLabel?.text = items[indexPath.row]
         return cell
    }
}

// MARK: - UITableViewDelegate (for context menus)
extension TableViewContextMenuExampleViewController: UITableViewDelegate {
    
    /// Provides a context menu configuration for the given index path.
    /// When the user long-presses the cell, this configuration is used to create the menu.
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = "\(indexPath.row)" as NSString
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            // Create actions for the context menu.
            let viewAction = UIAction(title: "View", image: UIImage(systemName: "eye")) { action in
                print("View \(self.items[indexPath.row])")
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Share \(self.items[indexPath.row])")
            }
            return UIMenu(title: "", children: [viewAction, shareAction])
        }
    }
}
