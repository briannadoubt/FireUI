//
//  ConfirmationButton.swift
//  meditationlife
//
//  Created by Brianna Lee on 10/9/20.
//

import SwiftUI

#if os(macOS)
struct ConfirmationButton: View {
    var label: String
    var action: () -> ()
    var body: some View {
        Button(action: action) {
            ZStack {
                Color("AccentColor")
                HStack {
                    Text(label)
                        .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: 212, height: 44, alignment: .center)
        .cornerRadius(8)
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
