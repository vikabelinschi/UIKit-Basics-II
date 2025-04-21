//
//  123.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// LiveUpdatingDiffableTableViewExampleViewController demonstrates how to use a diffable data source
/// for a UITableView that updates dynamically. It shows live updates by adding an item when the user taps a button.
class LiveUpdatingDiffableTableViewExampleViewController: UIViewController {
    
    // MARK: - Data Model and Section Definition
    
    enum Section {
        case main
    }
    
    /// The data model: an array of strings representing items.
    private var items: [String] = ["Alpha", "Beta", "Gamma"]
    
    /// The table view for displaying items.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "LiveCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    /// The diffable data source.
    private var dataSource: UITableViewDiffableDataSource<Section, String>!
    
    /// A button to simulate adding a new item.
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Item", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Live Updating TableView"
        setupTableView()
        setupAddButton()
        configureDataSource()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
    }
    
    /// Configures the diffable data source using a cell provider closure.
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCell", for: indexPath)
            cell.textLabel?.text = item
            return cell
        }
    }
    
    /// Applies the current snapshot to update the table view.
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    // MARK: - Actions
    
    /// Adds a new item to the data model and updates the snapshot.
    @objc private func addItem() {
        // Add a new item with a unique name.
        let newItem = "Item \(items.count + 1)"
        items.append(newItem)
        applySnapshot()
    }
}

// MARK: - UITableViewDelegate
extension LiveUpdatingDiffableTableViewExampleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            print("Selected: \(item)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
