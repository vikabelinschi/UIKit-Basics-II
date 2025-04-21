//
//  7.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// TableViewWithEmbeddedCollectionViewExampleViewController demonstrates how to embed a UICollectionView inside a UITableViewCell.
class TableViewWithEmbeddedCollectionViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Sample data for the collection view embedded in each table view cell.
    private let embeddedData: [[String]] = [
        ["A1", "A2", "A3", "A4"],
        ["B1", "B2", "B3"],
        ["C1", "C2", "C3", "C4", "C5"]
    ]
    
    /// The table view to display rows with embedded collection views.
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(EmbeddedCollectionViewCell.self, forCellReuseIdentifier: "EmbeddedCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableView with Embedded CollectionView"
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TableViewWithEmbeddedCollectionViewExampleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return embeddedData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Each section will contain one cell with an embedded collection view.
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmbeddedCell", for: indexPath) as? EmbeddedCollectionViewCell else {
            fatalError("Unable to dequeue EmbeddedCollectionViewCell")
        }
        
        // Set up the embedded collection view.
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.tag = indexPath.section  // Use the section as the tag to identify data for this cell.
        cell.collectionView.reloadData()
        return cell
    }
    
    // Optionally, set a fixed height for rows.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - UICollectionViewDataSource for Embedded CollectionView
extension TableViewWithEmbeddedCollectionViewExampleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionIndex = collectionView.tag
        return embeddedData[sectionIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmbeddedCell", for: indexPath)
        cell.backgroundColor = .systemBlue
        
        // Remove any existing subviews.
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.textAlignment = .center
        label.textColor = .white
        let sectionIndex = collectionView.tag
        label.text = embeddedData[sectionIndex][indexPath.item]
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.contentView.addSubview(label)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout for Embedded CollectionView
extension TableViewWithEmbeddedCollectionViewExampleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height - 20
        return CGSize(width: height, height: height) // Square cells
    }
}
