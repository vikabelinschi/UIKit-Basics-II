//
//  FruitTableViewCell.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// FruitTableViewCell is a custom subclass of UITableViewCell.
/// It is designed to display a fruit image and its name.
///
/// Theory:
/// - Custom cells allow for richer, tailored layouts than the standard UITableViewCell.
/// - Creating a custom cell programmatically provides full control over its subviews and layout.
/// - In this example, a UIImageView is used for the fruit image, and a UILabel displays the fruit name.
class FruitTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    /// An image view to display the fruit's image.
    let fruitImageView: UIImageView = {
        let imageView = UIImageView()
        // Set content mode to maintain aspect ratio.
        imageView.contentMode = .scaleAspectFill
        // Enable clipping so that the image does not overflow its bounds.
        imageView.clipsToBounds = true
        // Enable Auto Layout.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// A label to display the fruit's name.
    let fruitNameLabel: UILabel = {
        let label = UILabel()
        // Configure the font and style of the label.
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    /// Initializes the custom cell with the given style and reuse identifier.
    /// This is called when the cell is created programmatically.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Add the image view and label to the cell's content view.
        contentView.addSubview(fruitImageView)
        contentView.addSubview(fruitNameLabel)
        // Setup Auto Layout constraints for subviews.
        setupConstraints()
    }
    
    /// Required initializer for using the cell from a storyboard or XIB.
    /// Since we’re creating the UI programmatically, this initializer is not used.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Methods
    
    /// Sets up Auto Layout constraints for the fruitImageView and fruitNameLabel.
    ///
    /// Theory:
    /// - Proper constraint setup ensures the cell's subviews are laid out correctly on different devices.
    /// - The image view is placed at the left with fixed dimensions, and the label occupies the remaining horizontal space.
    private func setupConstraints() {
        // Constraint for the fruitImageView:
        NSLayoutConstraint.activate([
            // Place the image view 10 points from the left edge.
            fruitImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            // Center vertically in the content view.
            fruitImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            // Fixed width and height for the image view.
            fruitImageView.widthAnchor.constraint(equalToConstant: 40),
            fruitImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraint for the fruitNameLabel:
        NSLayoutConstraint.activate([
            // Position the label to the right of the image view with a 10-point gap.
            fruitNameLabel.leadingAnchor.constraint(equalTo: fruitImageView.trailingAnchor, constant: 10),
            // Ensure the label doesn’t extend beyond the right edge (10 points margin).
            fruitNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            // Center the label vertically in the content view.
            fruitNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
