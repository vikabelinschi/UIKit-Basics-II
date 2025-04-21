//
//  ExpandableTableViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// ExpandableTableViewExampleViewController demonstrates how to create a UITableView with expandable
/// and collapsible sections. This pattern is commonly used in settings screens, FAQs, or any interface
/// where you want to show/hide content to manage screen space efficiently.
///
/// Theory:
/// - **Section Headers as Controls:** Section headers can be tapped to toggle the visibility of their content.
/// - **State Management:** The controller tracks which sections are expanded/collapsed.
/// - **Dynamic Row Count:** The number of rows in a section changes based on its expanded state.
/// - **Animation:** Expanding/collapsing is animated to provide visual feedback to the user.
class ExpandableTableViewExampleViewController: UIViewController {
    
    // MARK: - Models
    
    /// Represents a section with a title and its content items
    struct Section {
        let title: String
        let items: [String]
        var isExpanded: Bool = false
    }
    
    // MARK: - Properties
    
    /// The sections data with their content items
    private var sections: [Section] = [
        Section(title: "Fruits", items: ["Apple", "Banana", "Cherry", "Date", "Elderberry"]),
        Section(title: "Vegetables", items: ["Carrot", "Broccoli", "Spinach", "Cucumber", "Pepper"]),
        Section(title: "Dairy", items: ["Milk", "Cheese", "Yogurt", "Butter"]),
        Section(title: "Grains", items: ["Rice", "Wheat", "Oats", "Barley", "Corn"]),
        Section(title: "Proteins", items: ["Chicken", "Beef", "Fish", "Eggs", "Tofu"])
    ]
    
    /// The UITableView that will display the expandable sections
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ContentCell")
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Expandable Sections"
        
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the table view by adding it to the view hierarchy, configuring properties,
    /// and setting its data source and delegate.
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Hide empty separator lines
        tableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Section Management
    
    /// Toggles the expanded state of a section and updates the table view with animation.
    ///
    /// - Parameter section: The index of the section to toggle.
    private func toggleSection(_ section: Int) {
        // Toggle the section's expanded state
        sections[section].isExpanded = !sections[section].isExpanded
        
        // Get the indices of rows to insert or delete
        let indices = (0..<sections[section].items.count).map {
            IndexPath(row: $0, section: section)
        }
        
        // Update the table view with animation
        tableView.beginUpdates()
        if sections[section].isExpanded {
            tableView.insertRows(at: indices, with: .fade)
        } else {
            tableView.deleteRows(at: indices, with: .fade)
        }
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource
extension ExpandableTableViewExampleViewController: UITableViewDataSource {
    
    /// Returns the number of sections in the table view.
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /// Returns the number of rows in each section.
    /// If a section is collapsed, it returns 0 rows; otherwise, it returns the number of items in the section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].isExpanded ? sections[section].items.count : 0
    }
    
    /// Provides the cell for a given row in a section.
    /// Configures the cell with the appropriate content item.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath)
        
        // Configure the cell with the item text
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExpandableTableViewExampleViewController: UITableViewDelegate {
    
    /// Provides a custom view for the header of each section.
    /// This header will include a tap gesture to expand/collapse the section.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "SectionHeader"
        ) as? SectionHeaderView else {
            return nil
        }
        
        // Configure the header view with the section title and expanded state
        headerView.configure(
            with: sections[section].title,
            isExpanded: sections[section].isExpanded
        )
        
        // Add a tap gesture to toggle the section
        headerView.tapHandler = { [weak self] in
            self?.toggleSection(section)
        }
        
        return headerView
    }
    
    /// Provides the height for section headers.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /// Called when a row is selected.
    /// Here we print the selected item and deselect the row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        print("Selected \(item) from \(sections[indexPath.section].title)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Section Header View

/// A custom UITableViewHeaderFooterView used as the header for expandable sections.
/// It displays the section title and an indicator showing whether the section is expanded.
class SectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    /// The title label for the section
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The indicator image view showing expanded/collapsed state
    private let indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Closure to handle tap gestures on the header
    var tapHandler: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Add a background view to make the header tap-able
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray6
        self.backgroundView = backgroundView
        
        // Add subviews
        contentView.addSubview(titleLabel)
        contentView.addSubview(indicatorImageView)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            indicatorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            indicatorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicatorImageView.widthAnchor.constraint(equalToConstant: 20),
            indicatorImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    // MARK: - Configuration
    
    /// Configures the header view with a title and expanded state.
    ///
    /// - Parameters:
    ///   - title: The title to display.
    ///   - isExpanded: Whether the section is expanded.
    func configure(with title: String, isExpanded: Bool) {
        titleLabel.text = title
        
        // Choose and set the appropriate indicator image
        let imageName = isExpanded ? "chevron.down" : "chevron.right"
        indicatorImageView.image = UIImage(systemName: imageName)
        indicatorImageView.tintColor = .systemBlue
    }
    
    // MARK: - Actions
    
    @objc private func handleTap() {
        tapHandler?()
    }
}
