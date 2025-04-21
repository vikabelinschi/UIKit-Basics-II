//
//  4.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// SearchableTableViewExampleViewController demonstrates integrating a UISearchController
/// with a UITableView. The table view displays a list of items that can be filtered by the search bar.
class SearchableTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Sample data for the table view.
    private var allItems: [String] = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    /// Data that is displayed after filtering.
    private var filteredItems: [String] = []
    /// Boolean to track whether the search is active.
    private var isFiltering: Bool = false
    
    /// The table view to display items.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    /// The search controller for filtering items.
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Searchable TableView"
        filteredItems = allItems  // Start with all items displayed
        setupTableView()
        setupSearchController()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false  // So that the background is not dimmed
        searchController.searchBar.placeholder = "Search fruits"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UITableViewDataSource
extension SearchableTableViewExampleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filteredItems.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
         cell.textLabel?.text = filteredItems[indexPath.row]
         return cell
    }
}

// MARK: - UISearchResultsUpdating
extension SearchableTableViewExampleViewController: UISearchResultsUpdating {
    /// Called when the search bar text or scope changes.
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        // Filter the items based on search text.
        filteredItems = searchText.isEmpty ? allItems : allItems.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}
