//
//  Untitled.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// MVVMTableViewExampleViewController demonstrates the Model-View-ViewModel (MVVM) architecture.
/// The view controller binds to the view model to present data in a UITableView.
class MVVMTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The table view to display items.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MVVMCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    /// The view model that manages the data and business logic.
    private let viewModel = ItemViewModel()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM TableView Example"
        view.backgroundColor = .white
        setupTableView()
        bindViewModel()
        viewModel.loadItems() // Load initial data.
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
    
    /// Binds the view model's data update event to reloading the table view.
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MVVMTableViewExampleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.items.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MVVMCell", for: indexPath)
         let item = viewModel.items[indexPath.row]
         cell.textLabel?.text = item.title
         return cell
    }
}
