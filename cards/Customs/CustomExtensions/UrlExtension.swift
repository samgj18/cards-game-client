//
//  UrlExtension.swift
//  cards
//
//  Created by Samuel Gómez Jiménez on 5/08/21.
//

import Foundation

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        
        self = url
    }
}
