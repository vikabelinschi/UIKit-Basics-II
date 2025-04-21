//
//  MockData.swift
//  UIKITBasics
//
//  Created by Victoria Belinschi   on 21.04.2025.
//

import UIKit

/// A model representing the mock data structure in the JSON file.
struct MockData: Codable {
    let fruits: [String]
    let colors: [String]
}

/// DataLoader is responsible for loading the mock data from the JSON file.
class DataLoader {
    
    /// Loads the mock data from MockData.json in the app bundle.
    ///
    /// - Returns: A `MockData` instance if the file could be read and parsed; otherwise, nil.
    static func loadMockData() -> MockData? {
        // Obtain a URL for the resource in the main bundle.
        guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
            print("Could not find MockData.json")
            return nil
        }
        
        do {
            // Load the data from the file.
            let data = try Data(contentsOf: url)
            // Decode the data into a MockData object.
            let decoder = JSONDecoder()
            let mockData = try decoder.decode(MockData.self, from: data)
            return mockData
        } catch {
            print("Error loading JSON data: \(error)")
            return nil
        }
    }
}
