//
//  Timestamped.swift
//  Twerking Girl
//
//  Created by Brianna Zamora on 10/10/21.
//

import Foundation

public protocol Timestamped {
    var created: Date { get }
    var updated: Date { get set }
}
