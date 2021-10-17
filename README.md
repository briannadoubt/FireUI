# FireUI

A Firebase wrapper for SwiftUI

## Features

 * Model Schema structure
 * Generic observable object for setting Firestore document and collection listeners 
 * Authentication UI and state management
 * Custom color scheme (via xcassets catalog)
 
## Usage

### Step 1: Set up user model

When observing the auth state it is a common pattern to create a collection for the user's record, keyed by the the user id returned when Firebase successfully creates a new user. FireUI will handle creating, updating, and deleting a custom user model alongside the lifecycle of their associated Firebase User.

Create a `struct` that conforms to the `Person` protocol:


