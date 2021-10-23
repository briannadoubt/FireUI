//
//  FeatureCell.swift
//  Taro
//
//  Created by Brianna Zamora on 9/21/21.
//

import SwiftUI

struct FeatureCell: View {
    
    var image: String
    var title: String
    var subtitle: String
    var color: Color
    
    var body: some View {
        let image = Image(systemName: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .frame(width: 32, height: 32)
        
        let text = VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(subtitle)
                .layoutPriority(1)
                .foregroundColor(.secondary)
                .font(.subheadline)
                .lineLimit(nil)
        }
        
        #if os(watchOS)
        HStack(alignment: .firstTextBaseline) {
            image
            text
        }
        #else
        HStack(alignment: .center) {
            image
            text
        }
        #endif
    }
}

struct FeatureCell_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCell(image: "text.badge.checkmark", title: "Title", subtitle: "Subtitle", color: .blue)
    }
}
