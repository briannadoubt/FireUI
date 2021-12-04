//
//  ErrorView.swift
//  FireUI
//
//  Created by Brianna Lee on 10/9/20.
//

@_exported import SwiftUI
@_exported import Firebase

enum ErrorType {
    case error
    case warning
}

public struct ErrorView: View {

    @Binding var error: Error?

    var floating: Bool
    var shadow: Bool

    var type: ErrorType
    
    init(
        error: Binding<Error?>,
        floating: Bool = false,
        shadow: Bool = false,
        type: ErrorType = .warning
    ) {
        self._error = error
        self.floating = floating
        self.shadow = shadow
        self.type = type
    }
    
    public var body: some View {
        if let error = error {
            ZStack {
                switch type {
                case .error:
                    Color.red
                case .warning:
                    Color("Warning")
                }
                HStack {
                    VStack {
                        Button(action: { withAnimation { self.error = nil } }) {
                            ZStack {
                                Image(systemName: "circle.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(Color("Close"))
                                Image(systemName: "xmark")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(Color.black)
                            }
                        }
                        .accessibility(identifier: "closeErrorDialogueButton")
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                    Group {
                        if let error = error as? FireUIError {
                            Text(error.description)
                        } else {
                            Text(self.error?.localizedDescription ?? "Unknown Error")
                        }
                    }
                    .foregroundColor(.black)
                    .padding([.top, .bottom])
                    .padding(.trailing, 8)
                    
                    Spacer()
                }
                .fixedSize(horizontal: false, vertical: true)
                .transition(AnyTransition.move(edge: .top))
            }
            .cornerRadius(floating ? 10 : 0)
            .shadow(radius: shadow ? 5 : 0, x: shadow ? -3 : 0, y: shadow ? 3 : 0)
            .listRowInsets(EdgeInsets())
            .accessibility(identifier: "error")
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack<ErrorView> {
                ErrorView(
                    error: .constant(FireUIError.userNotFound)
                )
            }
            List {
                ErrorView(
                    error: .constant(FireUIError.userNotFound),
                    floating: true
                )
            }
        }

        Group {
            VStack<ErrorView> {
                ErrorView(
                    error: .constant(FireUIError.userNotFound)
                )
            }
            List {
                ErrorView(
                    error: .constant(FireUIError.userNotFound),
                    floating: true
                )
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
