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

    // MARK: Methods
    public func jsonArray(with name: String) -> [Any]? {

        guard let url = url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonArray = json as? [Any] else {
                return nil
        }

        return jsonArray
    }

    public func data(with name: String) -> Data? {
        guard let url = url(forResource: name, withExtension: nil),
            let data = try? Data(contentsOf: url) else {
                return nil
        }
        return data
    }
}
