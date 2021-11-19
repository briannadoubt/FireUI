//
//  FireUIProduct.swift
//  FireUI Demo
//
//  Created by Bri on 11/19/21.
//

import FireUI

enum FireUIProduct: String, ProductRepresentable {
    
    case noAds
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .noAds:
            return "circle.fill"
        }
    }
}
