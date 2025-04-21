//
//  Untitled.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import Foundation

/// ItemViewModel provides data and business logic for the view.
/// It transforms model data (Item) into formats that the view can use directly.
class ItemViewModel {
    
    /// A list of items managed by the view model.
    private(set) var items: [Item] = []
    
    /// A closure that can be used to notify the view when data changes.
    var onDataUpdated: (() -> Void)?
    
    /// Loads initial data.
    func loadItems() {
        items = [
            Item(title: "First"),
            Item(title: "Second"),
            Item(title: "Third")
        ]
        onDataUpdated?()  // Notify observers of data update.
    }
    
    /// Adds a new item.
    func addItem(_ title: String) {
        items.append(Item(title: title))
        onDataUpdated?()
    }
}
