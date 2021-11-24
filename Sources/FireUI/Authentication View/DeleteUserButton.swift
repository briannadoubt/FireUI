//
//  DeleteUserButton.swift
//  FireUI
//
//  Created by Bri on 11/19/21.
//

public struct DeleteUserButton<Human: Person>: View {
    
    @Binding public var error: Error?
    
    public init(error: Binding<Error?>) {
        self._error = error
    }
    
    @EnvironmentObject fileprivate var user: FirebaseUser
    @EnvironmentObject fileprivate var person: FirestoreDocument<Human>
    
    public var body: some View {
        Button {
            guard let personDocument = person.document else {
                let documentNotFound = FireUIError.documentNotFound
                self.error = documentNotFound
                handleError(documentNotFound, message: "Couldn't find person document")
                return
            }
            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                Task {
                    do {
                        try await user.delete(person: personDocument)
                    } catch let error as FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to delete user")
                    } catch {
                        self.error = error
                        handleError(error, message: "Failed to delete user")
                    }
                }
            } else {
                user.delete(person: personDocument) { error in
                    if let error = error as? FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to delete user")
                    } else if let error = error {
                        self.error = error
                        handleError(error, message: "Failed to delete user")
                    }
                }
            }
        } label: {
            Label("Delete Account", systemImage: "person.fill.xmark")
        }
    }
}

//struct DeleteUserButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteUserButton<>()
//    }
//}
