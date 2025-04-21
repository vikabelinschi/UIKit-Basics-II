//
//  CustomCollectionViewLayout.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// CustomCollectionViewLayout is a subclass of UICollectionViewLayout that creates a simple waterfall layout.
/// In a waterfall layout, cells in multiple columns have different heights and are positioned to balance the overall height.
///
/// Key Concepts:
/// - **Cache:** Stores computed layout attributes for performance.
/// - **Content Size:** Calculated based on the tallest column after positioning cells.
/// - **prepare():** Calculates cell frames for the entire layout and populates the cache.
/// - **layoutAttributesForElements(in:):** Returns layout attributes for all items in a given rectangle.
/// - **invalidateLayout():** Clears the cache so that layout is recalculated when changes occur.
class CustomCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Layout Properties
    
    /// The number of columns in the layout.
    var numberOfColumns = 2
    /// The amount of padding between cells.
    var cellPadding: CGFloat = 8.0
    
    /// Cached layout attributes to avoid recalculating frames for every layout pass.
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    /// Calculated height of the entire content.
    private var contentHeight: CGFloat = 0
    
    /// The available content width, determined by the collection view's bounds minus its content insets.
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // MARK: - Layout Preparation
    
    /// Prepares the layout by calculating the frame for each cell and storing it in the cache.
    /// In this implementation, cells are arranged in a waterfall style:
    /// - We calculate each cell’s frame based on a fixed column width and a "dynamic" height.
    /// - The height is determined here using a simple function (varying with the item index).
    /// - Each cell is placed in the column with the smallest current height to balance the columns.
    override func prepare() {
        // Ensure that the cache is empty before calculations.
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        // Calculate the width of each column.
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        // X-offset for each column.
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        // Y-offset for each column (initially zero).
        var yOffset: [CGFloat] = Array(repeating: 0, count: numberOfColumns)
        
        // Iterate through all the items in the section (assuming one section).
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            // Create an indexPath for the current item.
            let indexPath = IndexPath(item: item, section: 0)
            
            // Find the column with the minimum yOffset (i.e., the shortest column so far).
            let column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
 
            // For demonstration, set the height as a function of the item index.
            // This produces cells with varying heights: 100, 130, 160, then repeats.
            let height = CGFloat(100 + (item % 3) * 30)
            
            // Frame for the cell before applying padding.
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            
            // Apply padding to the frame.
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Create layout attributes and assign the calculated frame.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Update the yOffset for the current column with the cell's height.
            yOffset[column] = yOffset[column] + height
            
            // Track the maximum yOffset value.
            contentHeight = max(contentHeight, yOffset[column])
        }
    }
    
    /// Returns the size of the entire content.
    /// This value is used by the collection view to configure the scrollable area.
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    /// Returns layout attributes for all cells that are within the given rect.
    /// The system calls this method to determine which cells are visible.
    ///
    /// - Parameter rect: The rectangle (in collection view’s coordinate system) for which layout attributes are needed.
    /// - Returns: An array of UICollectionViewLayoutAttributes for cells intersecting the rect.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Filter cached attributes to those whose frames intersect the provided rect.
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    /// Returns the layout attributes for the cell at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the item.
    /// - Returns: The layout attributes for the specified cell.
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }
    
    /// Invalidate the layout and clear the cache.
    /// This method is called when the layout needs to be recalculated (e.g., on rotation or bounds change).
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentHeight = 0
    }
}
