//
//  PerformanceOptimizedTableViewExampleViewController.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// PerformanceOptimizedTableViewExampleViewController demonstrates various performance optimization
/// techniques for UITableView, including:
/// - Cell prefetching to prepare data before cells become visible
/// - Self-sizing cells with proper cache management
/// - Asynchronous image loading with cancellation
/// - Smooth scrolling optimizations
///
/// Theory:
/// - **Prefetching:** Improves perceived performance by preloading data for cells before they're visible.
/// - **Cell Reuse Optimization:** Properly managing cell reuse reduces memory usage and improves scrolling performance.
/// - **Image Loading Management:** Asynchronous loading with proper cancellation prevents blocking the main thread.
/// - **Height Caching:** Avoiding recalculation of cell heights improves scrolling smoothness.

/// Represents an item with a title and an image URL
struct FeedItem {
    let id: UUID
    let title: String
    let subtitle: String
    let imageUrl: URL?
    
    // Simulate varying content lengths for dynamic cell heights
    var description: String {
        return String(repeating: "This is a description of the item. ", count: Int.random(in: 1...5))
    }
}

class PerformanceOptimizedTableViewExampleViewController: UIViewController {
    
    // MARK: - Models
    
    // MARK: - Properties
    
    /// Data items for the table view
    private var items: [FeedItem] = []
    
    /// Cache for cell heights to avoid recalculation
    private var cellHeightCache: [UUID: CGFloat] = [:]
    
    /// Used to track image download operations
    private var imageLoadOperations: [UUID: URLSessionDataTask] = [:]
    
    /// In-memory image cache
    private var imageCache: [URL: UIImage] = [:]
    
    /// The table view configured with performance optimizations
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(PerformanceOptimizedTableViewCell.self, forCellReuseIdentifier: "PerformanceCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    /// Activity indicator shown during initial data load
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Performance Optimizations"
        
        setupUI()
        
        // Enable prefetching for performance optimization
        tableView.prefetchDataSource = self
        
        // Load sample data
        loadSampleData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Cancel any ongoing image loading operations when the view disappears
        cancelAllImageLoadOperations()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        // Add and configure the activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        
        // Add and configure the table view
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set estimated row height for performance optimization
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Apply Auto Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Initially hide the table view until data is loaded
        tableView.alpha = 0
    }
    
    // MARK: - Data Loading
    
    /// Loads sample data with a simulated delay to demonstrate asynchronous data loading.
    private func loadSampleData() {
        // Simulate network delay with DispatchQueue
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Create sample items
            var sampleItems: [FeedItem] = []
            
            for i in 1...30 {
                let id = UUID()
                let item = FeedItem(
                    id: id,
                    title: "Item \(i)",
                    subtitle: "A performance optimized item",
                    imageUrl: URL(string: "https://picsum.photos/200/300?random=\(i)")
                )
                sampleItems.append(item)
            }
            
            // Simulate network delay
            Thread.sleep(forTimeInterval: 1.0)
            
            // Update UI on main thread
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.items = sampleItems
                self.tableView.reloadData()
                
                // Show the table view with animation and hide the activity indicator
                UIView.animate(withDuration: 0.3) {
                    self.tableView.alpha = 1.0
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Image Loading
    
    /// Loads an image asynchronously with caching and cancellation support.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to load
    ///   - itemId: The UUID of the associated item for tracking and cancellation
    ///   - completion: A closure called when the image is loaded, with the loaded UIImage or nil if failed
    private func loadImage(from url: URL, for itemId: UUID, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already cached
        if let cachedImage = imageCache[url] {
            completion(cachedImage)
            return
        }
        
        // Cancel any existing operation for this item
        cancelImageLoadOperation(for: itemId)
        
        // Create and start a new download task
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Cache the downloaded image
            self.imageCache[url] = image
            
            // Remove the task from tracking
            self.imageLoadOperations.removeValue(forKey: itemId)
            
            // Complete on the main thread
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        // Store the task for potential cancellation
        imageLoadOperations[itemId] = task
        
        // Start the download
        task.resume()
    }
    
    /// Cancels an image loading operation for a specific item.
    ///
    /// - Parameter itemId: The UUID of the item whose image loading should be cancelled
    private func cancelImageLoadOperation(for itemId: UUID) {
        if let operation = imageLoadOperations[itemId] {
            operation.cancel()
            imageLoadOperations.removeValue(forKey: itemId)
        }
    }
    
    /// Cancels all ongoing image loading operations.
    private func cancelAllImageLoadOperations() {
        imageLoadOperations.values.forEach { $0.cancel() }
        imageLoadOperations.removeAll()
    }
    
    // MARK: - Cell Height Management
    
    /// Calculates and caches the height for a cell.
    ///
    /// - Parameter item: The item to calculate height for
    /// - Returns: The cached or calculated height
    private func cachedHeightForItem(_ item: FeedItem) -> CGFloat {
        // Return cached height if available
        if let cachedHeight = cellHeightCache[item.id] {
            return cachedHeight
        }
        
        // Calculate height based on content (this would be more sophisticated in a real app)
        let baseHeight: CGFloat = 80
        let descriptionHeight = item.description.count / 10 * 5
        let height = baseHeight + CGFloat(descriptionHeight)
        
        // Cache the calculated height
        cellHeightCache[item.id] = height
        
        return height
    }
    
    /// Prepares cells that will soon be visible by pre-loading their images.
    ///
    /// - Parameter indexPaths: The index paths of cells to prepare
    private func prepareCellsAtIndexPaths(_ indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row < items.count else { continue }
            
            let item = items[indexPath.row]
            guard let imageUrl = item.imageUrl else { continue }
            
            // Pre-load the image if it's not already cached
            if imageCache[imageUrl] == nil {
                loadImage(from: imageUrl, for: item.id) { _ in }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PerformanceOptimizedTableViewExampleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PerformanceCell",
            for: indexPath
        ) as? PerformanceOptimizedTableViewCell else {
            fatalError("Could not dequeue PerformanceOptimizedTableViewCell")
        }
        
        let item = items[indexPath.row]
        
        // Configure cell with item data
        cell.configure(with: item)
        cell.imageView?.image = nil  // Reset image before loading
        
        // Load image asynchronously if available
        if let imageUrl = item.imageUrl {
            loadImage(from: imageUrl, for: item.id) { [weak cell] image in
                // Ensure the cell is still visible and for the correct item
                guard let cell = cell, cell.imageUrl == imageUrl else { return }
                cell.setImage(image)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PerformanceOptimizedTableViewExampleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected item: \(item.title)")
    }
    
    // Optional: Provide estimated heights for better scrolling performance
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < items.count else { return 100 }
        
        let item = items[indexPath.row]
        return cachedHeightForItem(item)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension PerformanceOptimizedTableViewExampleViewController: UITableViewDataSourcePrefetching {
    
    /// Prefetches data for cells that will soon become visible during scrolling.
    /// This helps avoid delays when cells actually appear on screen.
    ///
    /// Theory:
    /// - **Prefetching** preloads data for cells that aren't yet visible but will be soon.
    /// - This is particularly useful for image loading or expensive data processing.
    /// - The system determines which cells might become visible based on scroll direction and speed.
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Prepare cells by preloading their images
        prepareCellsAtIndexPaths(indexPaths)
    }
    
    /// Called when previously requested prefetching is no longer needed,
    /// typically because the user changed scroll direction.
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // Cancel image loading operations for cells that won't be displayed soon
        for indexPath in indexPaths {
            guard indexPath.row < items.count else { continue }
            let item = items[indexPath.row]
            cancelImageLoadOperation(for: item.id)
        }
    }
}

// MARK: - PerformanceOptimizedTableViewCell
class PerformanceOptimizedTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var imageUrl: URL?
    
    // MARK: - UI Elements
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Add subviews
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(descriptionLabel)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            // Image view
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 60),
            itemImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Subtitle label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        // Set corner radius for the image view
        itemImageView.layer.cornerRadius = 30
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with item data.
    ///
    /// - Parameter item: The FeedItem to display
    func configure(with item: FeedItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description
        imageUrl = item.imageUrl
        
        // Reset image view to placeholder
        itemImageView.image = nil
        itemImageView.backgroundColor = .systemGray6
    }
    
    /// Sets the image for the cell.
    ///
    /// - Parameter image: The UIImage to display
    func setImage(_ image: UIImage?) {
        itemImageView.image = image
        itemImageView.backgroundColor = image == nil ? .systemGray6 : .clear
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset cell state
        itemImageView.image = nil
        itemImageView.backgroundColor = .systemGray6
        titleLabel.text = nil
        subtitleLabel.text = nil
        descriptionLabel.text = nil
        imageUrl = nil
    }
}
