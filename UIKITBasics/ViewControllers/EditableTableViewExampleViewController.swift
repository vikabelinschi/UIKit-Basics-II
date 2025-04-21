//
//  7.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// EditableTableViewExampleViewController demonstrates inline editing and reordering in a UITableView.
/// Users can delete rows via swipe actions and move rows to new positions.
class EditableTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Data model for the table view.
    private var items: [String] = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    
    /// The table view displaying the items.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "EditableCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Editable & Reorder TableView"
        setupTableView()
        // Enable editing mode to allow reordering.
        navigationItem.rightBarButtonItem = editButtonItem
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
extension EditableTableViewExampleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return items.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "EditableCell", for: indexPath)
         cell.textLabel?.text = items[indexPath.row]
         return cell
    }
    
    // Allow rows to be moved.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         return true
    }
    
    // Update the data model when a row is moved.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         let movedItem = items[sourceIndexPath.row]
         items.remove(at: sourceIndexPath.row)
         items.insert(movedItem, at: destinationIndexPath.row)
    }
    
    // Enable deletion of rows.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             items.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .automatic)
         }
    }
}

// MARK: - UITableViewDelegate
extension EditableTableViewExampleViewController: UITableViewDelegate { }
