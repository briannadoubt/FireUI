//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Bri on 10/23/21.
//

import XCTest
@testable import FireUI_Demo
import Firebase
import FireUI

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    var app: XCUIApplication!
    
    func test_authFlow_success() throws {
        try signUp()
        // TODO: Test for user document in Firestore.
        try signOut()
        // TODO: Test that requests do not have permission when not signed in.
        try signIn()
        // TODO: Test that data can be created, read, updated, and deleted.
        try deleteUser()
    }
    
    func checkFor(_ error: FireUIError) throws {
        let authView = app.scrollViews["authenticationScrollView"].otherElements
        let error = authView.staticTexts[error.description]
        XCTAssert(error.exists)
    }
    
    func closeError() throws {
        let authView = app.scrollViews["authenticationScrollView"].otherElements
        let closeErrorButton = authView.buttons["Close, Circle"]
        closeErrorButton.tap()
    }
    
    func test_authFlow_inputErrors() throws {
        let authView = app.scrollViews["authenticationScrollView"].otherElements
        let signUpButton = authView.buttons["Sign Up"]
        
        // Nickname error
        signUpButton.tap()
        try checkFor(.missingNickname)
        try closeError()
        let nicknameInput = authView.textFields["Nickname"]
        nicknameInput.tap()
        try typeNickname()
        
        // Email error
        signUpButton.tap()
        try checkFor(.missingEmailAddress)
        try closeError()
        let emailInput = authView.textFields["Email"]
        emailInput.tap()
        try typeEmail()
        
        // Password Error
        signUpButton.tap()
        try checkFor(.missingPassword)
        try closeError()
        let newPasswordInput = authView.secureTextFields["New Password"]
        newPasswordInput.tap()
        try typePassword()

        // Verify password
        signUpButton.tap()
        try checkFor(.missingPasswordVerification)
        try closeError()
        let verifyPasswordInput = authView.secureTextFields["Verify Password"]
        verifyPasswordInput.tap()
        try typePassword()

        // Sign up
        signUpButton.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func signUp() throws {
        // Auth Screen
        let authView = app.scrollViews["authenticationScrollView"].otherElements
        let returnKey = app.buttons["Return"]
        
        // Nickname
        let nicknameInput = authView.textFields["Nickname"]
        nicknameInput.tap()
        try typeNickname()
        
        // Email
        let emailInput = authView.textFields["Email"]
        emailInput.tap()
        
        try typeEmail()
        
        // Password
        let newPasswordInput = authView.secureTextFields["New Password"]
        newPasswordInput.tap()
        
        try typePassword()

        // Verify password
        let verifyPasswordInput = authView.secureTextFields["Verify Password"]
        verifyPasswordInput.tap()
        
        try typePassword()

        // Sign up
        returnKey.tap()
        
        print("Successfully signed up")
    }
    
    /// This expects to have already successfully run `signIn()`
    func signOut() throws {
        print("Navigate to settings page, click sign out button")
        
        let tabBar = app.tabBars.firstMatch
        let settingsTabBarItem = tabBar.buttons["Settings"]
        
        // Switch to settings tab
        settingsTabBarItem.tap()
        
        // Settings screen
        let settingsList = app.tables
        let signOutButton = settingsList.buttons["signOutButton"]
        
        // Sign out
        signOutButton.tap()
        
        print("Successfully signed out")
    }
    
    /// This expects to have already successfully run `signIn()` and then `signOut()`, in order.
    func signIn() throws {
        // Auth Screen
        let authView = app.scrollViews["authenticationScrollView"].otherElements
        let signInHereButton = authView.buttons["Sign In here"]
        
        // Switch to sign in view
        signInHereButton.tap()
        
        // Focus on password
        let passwordInput = authView.secureTextFields["Password"]
        passwordInput.tap()

        // Sign In
        let returnKey = app.buttons["Return"]
        returnKey.tap()
        
        print("Successfully signed in")
    }
    
    /// This expects to have already successfully run `signIn()`, `signOut()`, and `signIn()`, in order.
    func deleteUser() throws {
        print("Navigate to settings page, click delete user button")
        
        let tabBar = app.tabBars["Tab Bar"]
        let settingsTabBarItem = tabBar.buttons["Settings"]
        
        // Switch to settings tab
        settingsTabBarItem.tap()
        
        // Settings screen
        let settingsList = app.tables
        let deleteUserButton = settingsList.buttons["Delete Account"]
        
        // Delete user
        deleteUserButton.tap()
        
        // Verify we are on sign up page of auth screen
        let authView = app.scrollViews["authenticationScrollView"].otherElements
        let nicknameInput = authView.textFields["Nickname"]
        
        // Focus on nickname
        nicknameInput.tap()
        
        print("Successfully deleted user")
    }
}

extension Tests_iOS {
    
    func typeNickname() throws {
        let fKey = app.keys["f"]
        let aKey = app.keys["a"]
        let kKey = app.keys["k"]
        let eKey = app.keys["e"]
        fKey.tap()
        aKey.tap()
        kKey.tap()
        eKey.tap()
    }
    
    func typeEmail() throws {
        let fKey = app.keys["f"]
        let aKey = app.keys["a"]
        let kKey = app.keys["k"]
        let eKey = app.keys["e"]
        let tKey = app.keys["t"]
        let sKey = app.keys["s"]
        let cKey = app.keys["c"]
        let oKey = app.keys["o"]
        let mKey = app.keys["m"]
        let atKey = app.keys["@"]
        let dotKey = app.keys["."]
        tKey.tap()
        eKey.tap()
        sKey.tap()
        tKey.tap()
        atKey.tap()
        fKey.tap()
        aKey.tap()
        kKey.tap()
        eKey.tap()
        dotKey.tap()
        cKey.tap()
        oKey.tap()
        mKey.tap()
    }
    
    func typePassword() throws {
        let moreKey = app.keys["more"]
        let oneKey = app.keys["1"]
        let twoKey = app.keys["2"]
        let threeKey = app.keys["3"]
        let fourKey = app.keys["4"]
        let fiveKey = app.keys["5"]
        let sixKey = app.keys["6"]
        moreKey.tap()
        oneKey.tap()
        twoKey.tap()
        threeKey.tap()
        fourKey.tap()
        fiveKey.tap()
        sixKey.tap()
    }
}
