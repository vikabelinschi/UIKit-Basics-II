//
//  SectionedIndexTableViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//


import UIKit

/// SectionedIndexTableViewExampleViewController demonstrates how to create a UITableView with:
/// - Multiple sections organized alphabetically
/// - Section headers displaying the section letter
/// - A section index for fast scrolling (like in Contacts app)
///
/// Theory:
/// - **Section Index:** A shortcut for quickly jumping to different sections in a large table view.
///   Especially useful for alphabetically ordered data like contacts, countries, etc.
/// - **Sections:** Dividing the data into logical groups to improve organization and navigation.
/// - **Section Headers:** Providing visual and contextual separation between groups of related rows.
class SectionedIndexTableViewExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Array of characters for section titles and section index.
    private let sectionTitles = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    /// Dictionary where keys are section titles and values are arrays of data items per section.
    private var sectionedData: [String: [String]] = [:]
    
    /// The UITableView that will display the sectioned data.
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SectionedCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Sectioned TableView with Index"
        
        // Generate sample data organized by sections
        generateSampleData()
        
        // Setup tableView and its constraints
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the table view by adding it to the view hierarchy, configuring its properties,
    /// and setting its data source and delegate.
    private func setupTableView() {
        view.addSubview(tableView)
        
        // Set self as data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Enable section index
        tableView.sectionIndexColor = .systemBlue
        tableView.sectionIndexBackgroundColor = .clear
        tableView.sectionIndexTrackingBackgroundColor = .systemGray6
        
        // Apply Auto Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Generates sample data for each section.
    /// Each section contains items that start with the section letter.
    private func generateSampleData() {
        // Sample data for each letter section
        sectionedData = [
            "A": ["Apple", "Apricot", "Avocado", "Almond", "Artichoke"],
            "B": ["Banana", "Blueberry", "Blackberry", "Broccoli"],
            "C": ["Cherry", "Coconut", "Carrot", "Cucumber", "Cauliflower"],
            "D": ["Date", "Dragonfruit", "Durian"],
            "E": ["Elderberry", "Eggplant"],
            "F": ["Fig", "Fruit salad", "Feijoa"],
            "G": ["Grape", "Grapefruit", "Guava", "Ginger"],
            "H": ["Honeydew", "Hazelnut", "Huckleberry"]
        ]
    }
}

// MARK: - UITableViewDataSource
extension SectionedIndexTableViewExampleViewController: UITableViewDataSource {
    
    /// Returns the number of sections in the table view.
    /// This corresponds to the number of distinct first letters in our data.
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    /// Returns the number of rows in each section.
    /// This corresponds to the number of items starting with the section letter.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionTitles[section]
        return sectionedData[sectionKey]?.count ?? 0
    }
    
    /// Provides the cell for a given row in a section.
    /// Configures the cell with the appropriate data item for the row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionedCell", for: indexPath)
        
        // Get the section title and corresponding data array
        let sectionKey = sectionTitles[indexPath.section]
        if let sectionItems = sectionedData[sectionKey], indexPath.row < sectionItems.count {
            cell.textLabel?.text = sectionItems[indexPath.row]
        }
        
        return cell
    }
    
    /// Provides the title for the header of each section.
    /// This is used for the floating section headers as the user scrolls.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    /// Provides the titles for the section index (the vertical list of letters on the right side).
    /// This allows for fast scrolling through large data sets.
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    /// Maps from a section index title to the corresponding section number.
    /// This ensures that tapping an index title scrolls to the correct section.
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        // Simply return the index, as our sectionTitles array is already in the correct order
        return index
    }
}

// MARK: - UITableViewDelegate
extension SectionedIndexTableViewExampleViewController: UITableViewDelegate {
    
    /// Called when a row is selected.
    /// Here we print the selected item and deselect the row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionKey = sectionTitles[indexPath.section]
        if let sectionItems = sectionedData[sectionKey], indexPath.row < sectionItems.count {
            print("Selected: \(sectionItems[indexPath.row])")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Optional: Customize the header view for each section.
    /// This allows for more advanced custom header views beyond simple text.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        
        let label = UILabel()
        label.text = "  \(sectionTitles[section])"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    /// Provides the height for section headers.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
