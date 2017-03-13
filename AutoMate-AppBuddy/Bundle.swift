//
//  Bundle.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 27/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - Bundle
public extension Bundle {

    // MARK: Initialization
    /// Initialize `Bundle` with a bundle name or a bundle identifier.
    ///
    /// - Parameter stringDescription: Bundle name or a bundle identifier.
    /// - Returns: `nil` if cannot find a bundle with given name or identifier.
    public convenience init?(stringDescription: String?) {
        guard let description = stringDescription else {
            return nil
        }
        if let url = Bundle.main.url(forResource: description, withExtension: "bundle") {
            self.init(url: url)
            return
        }
        self.init(identifier: description)
    }

    // MARK: Methods
    /// Returns array from JSON file.
    ///
    /// - note:
    ///   The file has to have a `json` extension.
    ///
    /// - Parameter name: JSON file name without extenstion.
    /// - Returns: Array of objects, or `nil` if an error occurs.
    public func jsonArray<T>(with name: String) -> [T]? {

        guard let url = url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonArray = json as? [T] else {
                return nil
        }

        return jsonArray
    }

    /// Returns data from file.
    ///
    /// - Parameter name: File name, with extension.
    /// - Returns: File contents as `Data` or `nil` if file doesn't exists.
    public func data(with name: String) -> Data? {
        guard let url = url(forResource: name, withExtension: nil),
            let data = try? Data(contentsOf: url) else {
                return nil
        }
        return data
    }

    // MARK: Static methods
    /// Initialize `Bundle` with a bundle name or a bundle identifier.
    /// If `nil` is passed, then `Bundle.main` is returned.
    ///
    /// - Parameter description: Bundle name, a bundle identifier or `nil`.
    /// - Returns: `nil` if cannot find a bundle with given name or identifier.
    ///   `Bundle.main` is `nil` is used as parameter.
    public static func with(stringDescription description: String?) -> Bundle? {
        guard let aDescription = description else { return Bundle.main }
        return Bundle(stringDescription: aDescription)
    }
}
