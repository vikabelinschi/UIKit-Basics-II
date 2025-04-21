//
//  ViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// MainViewController serves as the entry point of the app, displaying buttons that navigate to various example screens.
/// The buttons are added inside a UIScrollView so that they can be scrolled if they don't fit on screen.
class MainViewController: UIViewController {

    // MARK: - UI Elements

    /// Scroll view that contains all the buttons.
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    /// Content view that holds the stack view.
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Button: TableView (Delegate/DataSource)
    let tableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Delegate/DataSource)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView (Diffable Data Source)
    let diffableTableViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Diffable Data Source)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: CollectionView (Flow Layout)
    let collectionViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CollectionView (Flow Layout)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: CollectionView (Custom Layout)
    let customLayoutCollectionViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CollectionView (Custom Layout)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView (Custom Cell)
    let customTableViewExampleViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Custom Cell)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: CollectionView (Compositional Layout)
    let compositionalCollectionViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CollectionView (Compositional Layout)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView (Swipe Actions)
    let swipeActionsTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Swipe Actions)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView (Live Updating - Diffable)
    let liveUpdatingDiffableTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Live Updating TableView", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: CollectionView (Drag & Drop)
    let dragDropCollectionViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CollectionView (Drag & Drop)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView (MVVM Example)
    let mvvmTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("MVVM TableView", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: CollectionView (Animated Transitions)
    let animatedCollectionViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Animated CollectionView", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Additional Examples
    
    /// Button: TableView (Context Menus)
    let tableViewContextMenuExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Context Menus)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView (Searchable)
    let searchableTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Searchable)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView (Editable/Reorder)
    let editableTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Editable/Reorder)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: CollectionView (Context Menus)
    let collectionViewContextMenuExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CollectionView (Context Menus)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView with Embedded CollectionView
    let embeddedCollectionViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Embedded CollectionView)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView with Sections and Index
    let sectionedIndexTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Sections & Index)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: CollectionView with Different Cell Types
    let multipleCollectionViewCellTypesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CollectionView (Multiple Cell Types)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: TableView with Expandable Sections
    let expandableTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Expandable Sections)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Button: Performance Optimized TableView
    let performanceOptimizedTableViewExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TableView (Performance Optimized)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "UIKit Examples"
        setupUI()
    }
    
    // MARK: - UI Setup
    
    /// Configures the view by adding a scroll view that contains a vertical stack view with all the example buttons.
    private func setupUI() {
        // Add the scroll view as a child view.
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Add the content view to the scroll view.
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // The width of the content view should match the scroll view's width.
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Create a vertical stack view with all buttons.
        let stackView = UIStackView(arrangedSubviews: [
            tableViewExampleButton,
            diffableTableViewButton,
            collectionViewExampleButton,
            customLayoutCollectionViewButton,
            customTableViewExampleViewButton,
            compositionalCollectionViewExampleButton,
            swipeActionsTableViewExampleButton,
            liveUpdatingDiffableTableViewExampleButton,
            dragDropCollectionViewExampleButton,
            mvvmTableViewExampleButton,
            animatedCollectionViewExampleButton,
            tableViewContextMenuExampleButton,
            searchableTableViewExampleButton,
            editableTableViewExampleButton,
            collectionViewContextMenuExampleButton,
            embeddedCollectionViewExampleButton,
            sectionedIndexTableViewExampleButton,
            multipleCollectionViewCellTypesButton,
            expandableTableViewExampleButton,
            performanceOptimizedTableViewExampleButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .center  // Center each button horizontally.
        stackView.spacing = 20         // 20 points spacing between buttons.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the stack view to the content view.
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            // Pin the stack view to the content view's edges.
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Attach button action handlers.
        tableViewExampleButton.addTarget(self, action: #selector(didTapTableViewExample), for: .touchUpInside)
        diffableTableViewButton.addTarget(self, action: #selector(didTapDiffableTableView), for: .touchUpInside)
        collectionViewExampleButton.addTarget(self, action: #selector(didTapCollectionViewExample), for: .touchUpInside)
        customLayoutCollectionViewButton.addTarget(self, action: #selector(didTapCustomLayoutCollectionView), for: .touchUpInside)
        customTableViewExampleViewButton.addTarget(self, action: #selector(didTapCustomTableView), for: .touchUpInside)
        compositionalCollectionViewExampleButton.addTarget(self, action: #selector(didTapCompositionalCollectionView), for: .touchUpInside)
        swipeActionsTableViewExampleButton.addTarget(self, action: #selector(didTapSwipeActionsTableView), for: .touchUpInside)
        liveUpdatingDiffableTableViewExampleButton.addTarget(self, action: #selector(didTapLiveUpdatingDiffableTableView), for: .touchUpInside)
        dragDropCollectionViewExampleButton.addTarget(self, action: #selector(didTapDragDropCollectionView), for: .touchUpInside)
        mvvmTableViewExampleButton.addTarget(self, action: #selector(didTapMVVMTableView), for: .touchUpInside)
        animatedCollectionViewExampleButton.addTarget(self, action: #selector(didTapAnimatedCollectionView), for: .touchUpInside)
        tableViewContextMenuExampleButton.addTarget(self, action: #selector(didTapTableViewContextMenu), for: .touchUpInside)
        searchableTableViewExampleButton.addTarget(self, action: #selector(didTapSearchableTableView), for: .touchUpInside)
        editableTableViewExampleButton.addTarget(self, action: #selector(didTapEditableTableView), for: .touchUpInside)
        collectionViewContextMenuExampleButton.addTarget(self, action: #selector(didTapCollectionViewContextMenu), for: .touchUpInside)
        embeddedCollectionViewExampleButton.addTarget(self, action: #selector(didTapEmbeddedCollectionView), for: .touchUpInside)
        sectionedIndexTableViewExampleButton.addTarget(self, action: #selector(didTapSectionedIndexTableView), for: .touchUpInside)
        multipleCollectionViewCellTypesButton.addTarget(self, action: #selector(didTapMultipleCollectionViewCellTypes), for: .touchUpInside)
        expandableTableViewExampleButton.addTarget(self, action: #selector(didTapExpandableTableView), for: .touchUpInside)
        performanceOptimizedTableViewExampleButton.addTarget(self, action: #selector(didTapPerformanceOptimizedTableView), for: .touchUpInside)
    }
    
    // MARK: - Button Action Handlers
    
    /// Navigates to the TableView (Delegate/DataSource) example screen.
    @objc private func didTapTableViewExample() {
        let vc = TableViewExampleViewController()
        vc.title = "TableView Example"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView (Diffable Data Source) example screen.
    @objc private func didTapDiffableTableView() {
        let vc = DiffableTableViewExampleViewController()
        vc.title = "Diffable TableView"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the CollectionView (Flow Layout) example screen.
    @objc private func didTapCollectionViewExample() {
        let vc = CollectionViewExampleViewController()
        vc.title = "CollectionView Flow Layout"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the CollectionView (Custom Layout) example screen.
    @objc private func didTapCustomLayoutCollectionView() {
        let vc = CustomLayoutCollectionViewExampleViewController()
        vc.title = "Custom Layout CollectionView"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView (Custom Cell) example screen.
    @objc private func didTapCustomTableView() {
        let vc = CustomTableViewExampleViewController()
        vc.title = "TableView (Custom Cell)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the CollectionView (Compositional Layout) example screen.
    @objc private func didTapCompositionalCollectionView() {
        let vc = CompositionalCollectionViewExampleViewController()
        vc.title = "Compositional Layout"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView (Swipe Actions) example screen.
    @objc private func didTapSwipeActionsTableView() {
        let vc = SwipeActionsTableViewExampleViewController()
        vc.title = "Swipe Actions TableView"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the Live Updating TableView (Diffable Data Source) example screen.
    @objc private func didTapLiveUpdatingDiffableTableView() {
        let vc = LiveUpdatingDiffableTableViewExampleViewController()
        vc.title = "Live Updating TableView"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the CollectionView (Drag & Drop) example screen.
    @objc private func didTapDragDropCollectionView() {
        let vc = DragDropCollectionViewExampleViewController()
        vc.title = "Drag & Drop CollectionView"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the MVVM TableView example screen.
    @objc private func didTapMVVMTableView() {
        let vc = MVVMTableViewExampleViewController()
        vc.title = "MVVM TableView"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the Animated CollectionView example screen.
    @objc private func didTapAnimatedCollectionView() {
        let vc = AnimatedCollectionViewExampleViewController()
        vc.title = "Animated CollectionView"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView (Context Menus) example screen.
    @objc private func didTapTableViewContextMenu() {
        let vc = TableViewContextMenuExampleViewController()
        vc.title = "TableView (Context Menus)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView (Searchable) example screen.
    @objc private func didTapSearchableTableView() {
        let vc = SearchableTableViewExampleViewController()
        vc.title = "TableView (Searchable)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView (Editable/Reorder) example screen.
    @objc private func didTapEditableTableView() {
        let vc = EditableTableViewExampleViewController()
        vc.title = "TableView (Editable/Reorder)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the CollectionView (Context Menus) example screen.
    @objc private func didTapCollectionViewContextMenu() {
        let vc = CollectionViewContextMenuExampleViewController()
        vc.title = "CollectionView (Context Menus)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView with Embedded CollectionView example screen.
    @objc private func didTapEmbeddedCollectionView() {
        let vc = TableViewWithEmbeddedCollectionViewExampleViewController()
        vc.title = "TableView (Embedded CollectionView)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView with Sections and Index example screen.
    @objc private func didTapSectionedIndexTableView() {
        let vc = SectionedIndexTableViewExampleViewController()
        vc.title = "TableView (Sections & Index)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the CollectionView with Multiple Cell Types example screen.
    @objc private func didTapMultipleCollectionViewCellTypes() {
        let vc = MultipleCollectionViewCellTypesViewController()
        vc.title = "CollectionView (Multiple Cell Types)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView with Expandable Sections example screen.
    @objc private func didTapExpandableTableView() {
        let vc = ExpandableTableViewExampleViewController()
        vc.title = "TableView (Expandable Sections)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Navigates to the TableView with Expandable Sections example screen.
    @objc private func didTapPerformanceOptimizedTableView() {
        let vc = PerformanceOptimizedTableViewExampleViewController()
        vc.title = "TableView (Performance Optimized)"
        navigationController?.pushViewController(vc, animated: true)
    }
}
