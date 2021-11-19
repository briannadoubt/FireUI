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
                self.error = error
                return
            }
            user.delete(person: personDocument) { error in
                if let error = error {
                    self.error = error
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
