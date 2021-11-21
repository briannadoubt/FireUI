# FireUI

[![iOS / iPadOS](https://github.com/briannadoubt/FireUI/actions/workflows/iOS.yml/badge.svg)](https://github.com/briannadoubt/FireUI/actions/workflows/iOS.yml)

A Firebase wrapper for SwiftUI

## Features

 * Model Schema structure
 * Generic observable object for setting Firestore document and collection listeners 
 * Authentication UI and state management
 * Custom color scheme (via xcassets catalog)
 
## Usage

### Step 1: Set up user model

When observing the auth state it is a common pattern to create a collection for the user's record, keyed by the the user id returned when Firebase successfully creates a new user. FireUI will handle creating, updating, and deleting a custom user model alongside the lifecycle of their associated Firebase User.

There are two models that are necessary for you to create:
 1. A struct that conforms to `Person`
 ```swift
struct DemoPerson: Person {
    
    @DocumentID var id: PersonID?
    
    var nickname = "Test"
    var role: DemoRole?
    var email: String = "test@test.com"
    
    var created: Date = Date()
    var updated: Date = Date()
    
    func basePath() -> String {
        "users"
    }
    
    static func new(uid: PersonID, email: String, nickname: String) -> DemoPerson {
        DemoPerson(
            id: uid,
            nickname: nickname,
            email: email
        )
    }
}
```
 2. An enumeration that conforms to `PersonRole` 
```swift
enum DemoRole: String, PersonRole {
    case test
    var id: String { rawValue }
    var title: String { rawValue.localizedCapitalized }
}
```

### Step 2: Set up Firebase project

FireUI relies on Firebase for managing your app's data. In order to make this happen your app will need to be set up with a Firebase project, and a corresponding `GoogleService-Info.plist` file should be included in your app's target.

Official Firebase iOS SDK Documentation -> https://firebase.google.com/docs/ios/setup

### Step 3: Configure Firebase iOS SDK

FireUI will handle instantiating Firebase (by calling `FirebaseApp.configure()`) in your app _automagically_ via the `FirebaseUser` class.

The `FirebaseUser` instance is managed automatically when `.onFire(personType:)` is called:

```swift
ContentView()
    .onFire(DemoPerson.self)
```

or when the `Client` class is instantiated (it's the same thing, really):

```swift
Client<DemoPerson> {
    ContentView()
}
```

The `FirebaseUser` class also has an optional initializer parameter that allows for you to handle configuring Firebase manually. (Especially handy for Unit tests).

```swift
final class FireUITests: XCTestCase {
    
    var user: FirebaseUser!

    override func setUp() {
        let appOptions = FirebaseOptions(
            googleAppID: "1:501834001924:ios:dcad14e697355122cdcf51",
            gcmSenderID: "501834001924"
        )
        appOptions.apiKey = "AIzaSyAls2v2gRa-GIsrZfTJd0V0ORcjEeu8ArU"
        appOptions.projectID = "fireui-demo"
        FirebaseApp.configure(options: appOptions)
        
        user = FirebaseUser(basePath: "users", initialize: false)
    }

    func testSetUp() throws { }
}
```

### Step 4: Choose your authentication UI

If you do not specify the Authentication view when instantiating your `Client` class, then FireUI will use preconfigured UI with no image or footer.

If you would like to customize these components you can instantiate `Client` like the following:

```swift
Client(personBasePath: "users") {
    AuthenticationView(
        image: { Image(systemName: "sparkles") },
        newPerson: { uid, email, nickname in
            // Do any further initial user model state set up here 
            DemoPerson(
                id: uid,
                nickname: nickname,
                role: DemoRole.test,
                email: email,
                created: Date(),
                updated: Date()
            )
        },
        footer: { Text("🔥 FireUI Demo") })
} content: {
    ContentView()
}
```

`Client` automatically adds a `FirebaseUser` environment object that can be used for observing and interacting with the authentication state. This means that you can create custom Authentication UI by binding to `@EnvironmentObject var user: FirebaseUser`.


### Step 5: Design your Firestore data model

In order to read and write to Firestore you will need to create structs that reflect the data model. FireUI provides a `FirestoreCodable` protocol that, when conformed to, enables your `Codable` struct to be easily saved to Firestore.

```swift
#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif
import FireUI
import FirebaseFirestoreSwift

struct Object: FirestoreCodable {

    @ObjectID var id: PersonID?
    
    var text: String
    
    var created = Date()
    var updated = Date()
    
    func basePath() -> String {
        "objects"
    }
}
```

### Step 6: Read, listen, and save your data using `FirestoreObserver`

As you design your app, you will inevitably want to download data to display to the user. This can be done with with the `FirestoreDocument` class, or the `FirestoreCollection` class.

Listen for real time updates on a collection using `FirestoreCollection`:

```swift
struct ObjectsView: View {
    
//    @StateObject var objects: FirestoreCollection<Object>
    @ObservableObject var objects: FirestoreCollection<Object>
    
    var body: some View {
        List {
            ForEach(objects.collection) { object in
                NavigationLink(destination: ObjectView()
                Text(object.text)
            }
        }
        .observe(objects)
    }
}
```

Listen for real time updates on a document using `FirestoreDocument`:

```swift
struct ObjectView: View {
 
//    @StateObject var object: FirestoreDocument<Object>
    @ObservableObject var object: FirestoreDocument<Object>
    
    init(_ collection: String, _ id: String) {
//        object = StateObject(wrappedValue: FirestoreDocument(collection: collection, id: id))
        object = FirestoreDocument(collection: collection, id: id)
    }
    
    var body: some View {
        NavigationView {
            Text(object.document?.text ?? "")
                .observe(object)
        }
    }
}
```

### Step 7: Set up Firestore Secturity Rules

Firestore Security Rules are incredibly flexible, but they can also be combersome to manage. Here is a template set of functions and parameters that can be used:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function loggedIn() {
      return request.auth != null
    }
    function sameUser(userId) {
      return request.auth.uid == userId
    }
    function userExists() {
      return exists(/databases/$(database)/documents/users/$(request.auth.uid))
    }
    function admin() {
      return userExists() && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.admin == true
    }
    function getRoleFor(document) {
      return performer.data.roles[request.auth.uid]
    }
    function hasRole(roles, document) {
      return getRoleFor(document) in roles || admin()
    }
    function getObject(objectId) {
      return get(/databases/$(database)/documents/objects/$(objectId))
    }
    
    match /users/{userId} {
      allow read: if loggedIn()
      allow create: if loggedIn()
      allow delete: if loggedIn() && sameUser(userId)
      allow update: if loggedIn()
        && sameUser(userId)
        && request.resource.data.created == resource.data.created
    }
    
    match /object/{objectId} {
      allow read: if loggedIn() && userExists()
      allow list: if loggedIn() && admin()
      allow delete: if hasRole(['test'], resource)
      allow create: if loggedIn() && resource == null
      allow update: if hasRole(['test'], resource)
        && request.resource.data.created == resource.data.created
      
      function objectExists() {
        return exists(/databases/$(database)/documents/objects/$(objectId))
      }
      
      function canEdit() {
        return loggedIn()
          && userExists()
          && objectExists()
          && hasRole(['test'], getObject(objectId))
      }
      
      match /requests {
        allow create: if loggedIn()
          && userExists()
          && objectExists()
        allow read, list, update, delete: if canEdit()
      }
      
      match /earnings/{earningId} {
        allow read, list, delete, create: if canEdit()
        allow update: if canEdit()
      }
    }
  }
}
```
