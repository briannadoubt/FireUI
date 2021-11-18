//
//  ConfirmationButton.swift
//  FireUI
//
//  Created by Brianna Lee on 10/9/20.
//

@_exported import SwiftUI

#if os(macOS)
struct ConfirmationButton: View {
    var label: String
    var action: () -> ()
    var body: some View {
        if #available(macOS 12.0, *) {
            Button(action: action) {
                HStack {
                    Text(label)
                        .bold()
                        .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 212, height: 44, alignment: .center)
            .buttonStyle(BorderedProminentButtonStyle())
            .cornerRadius(8)
        } else {
            // Fallback on earlier versions
        }
    }
}
#else
struct ConfirmationButton: View {
    var label: String
    var action: () -> ()
    var body: some View {
        Button(action: action) {
            ZStack {
                Color.accentColor
                HStack {
                    Text(label)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 10, height: 10)

                }
            }
        }
        .foregroundColor(.white)
        .frame(width: 212, height: 44, alignment: .center)
        .cornerRadius(8)
        .accessibility(identifier: "confirmationButton")
    }
}
#endif

struct ConfirmationButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            ConfirmationButton(label: "Confirm", action: { print("Confirmed") })
                .previewLayout(.sizeThatFits)
                .colorScheme(colorScheme)
        }
    }
}
