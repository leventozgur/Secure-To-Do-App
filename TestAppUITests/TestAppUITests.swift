//
//  TestAppUITests.swift
//  TestAppUITests
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import XCTest
import TestApp

class TestAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func test01_SuccessLogin() throws {
        try successLogin()
    }

    func test02_FailLogin() throws {
        let app = XCUIApplication()
        app.launch()

        let textField = app.secureTextFields["Password enter here..."]
        textField.tap()
        textField.typeText("adsasd")
        app.buttons["Login"].tap()
        app.alerts["Alert"].scrollViews.otherElements.buttons["Ok"].tap()
    }

    func test03_ShowAddAlertView() throws {
        try successLogin()

        let app = XCUIApplication()
        
        let addBtn = app.buttons["AddBtn"]
        XCTAssert(addBtn.exists)
        addBtn.tap()
    }

    func test04_ShowAddAlertView_closeWihtOutside() throws {
        try successLogin()

        let app = XCUIApplication()
        
        let addBtn = app.buttons["AddBtn"]
        XCTAssert(addBtn.exists)
        addBtn.tap()
        
        let cancelBtn = app.buttons["cancelBtn"]
        XCTAssert(cancelBtn.exists)
        cancelBtn.tap()
    }

    func test05_ShowAddAlertView_closeWihtCrossButton() throws {
        try successLogin()

        let app = XCUIApplication()
        
        let addBtn = app.buttons["AddBtn"]
        XCTAssert(addBtn.exists)
        addBtn.tap()
        
        let closeBtn = app.buttons["closeBtn"]
        XCTAssert(closeBtn.exists)
        closeBtn.tap()
    }

    func test06_SuccessFlow() throws {
        try successLogin()

        let app = XCUIApplication()
        
        let addBtn = app.buttons["AddBtn"]
        XCTAssert(addBtn.exists)
        addBtn.tap()

        let titleTextField = app.textFields["Title"]
        XCTAssert(titleTextField.exists)
        titleTextField.tap()
        titleTextField.typeText("Test Title")

        let textView = app.textViews.element(boundBy: 0)
        XCTAssert(textView.exists)
        textView.tap()
        textView.typeText("Test Detail")

        let sendButton = app.buttons["sendButton"]
        XCTAssert(sendButton.exists)
        sendButton.tap()
        
        let firstCell = app.tables.element(boundBy: 0).cells.element(boundBy: 0)
        XCTAssert(firstCell.exists)
        firstCell.tap()
        
        let backBtn = app.navigationBars["TestApp.DetailView"].buttons["Back"]
        XCTAssert(backBtn.exists)
        backBtn.tap()
        
        firstCell.swipeLeft()
        
        let fistCellDelete = firstCell.buttons["Delete"]
        XCTAssert(fistCellDelete.exists)
        fistCellDelete.tap()
    }
}

extension TestAppUITests {
    func successLogin() throws {
        let app = XCUIApplication()
        app.launch()

        let textField = app.secureTextFields["Password enter here..."]
        XCTAssert(textField.exists)
        textField.tap()
        textField.typeText("leventozgur123")
        
        let loginBtn = app.buttons["Login"]
        XCTAssert(loginBtn.exists)
        loginBtn.tap()
    }
}
