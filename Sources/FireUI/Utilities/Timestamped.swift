//
//  Timestamped.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/10/21.
//

@_exported import Foundation

public protocol Timestamped {
    var created: Date { get }
    var updated: Date { get set }
}
