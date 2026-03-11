// LoginViewModelTests.swift
// WorkPalTests

import XCTest
@testable import WorkPal

@MainActor
final class LoginViewModelTests: XCTestCase {

    private var sut: LoginViewModel!

    override func setUp() async throws {
        try await super.setUp()
        sut = LoginViewModel(validUsername: "user", validPassword: "pass.123")
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    // MARK: - isLoginButtonEnabled

    func test_isLoginButtonEnabled_bothEmpty_shouldBeFalse() {
        XCTAssertFalse(sut.isLoginButtonEnabled)
    }

    func test_isLoginButtonEnabled_onlyUsername_shouldBeFalse() {
        sut.username = "user"
        XCTAssertFalse(sut.isLoginButtonEnabled)
    }

    func test_isLoginButtonEnabled_bothFilled_shouldBeTrue() {
        sut.username = "user"
        sut.password = "pass"
        XCTAssertTrue(sut.isLoginButtonEnabled)
    }

    // MARK: - login

    func test_login_validCredentials_shouldSetIsLoggedIn() {
        sut.username = "user"
        sut.password = "pass.123"
        sut.login()
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertFalse(sut.showLoginError)
    }

    func test_login_invalidCredentials_shouldShowError() {
        sut.username = "wrong"
        sut.password = "wrong"
        sut.login()
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertTrue(sut.showLoginError)
    }

    // MARK: - logout

    func test_logout_shouldResetState() {
        sut.username = "user"
        sut.password = "pass.123"
        sut.login()
        XCTAssertTrue(sut.isLoggedIn)

        sut.logout()
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.username, "")
        XCTAssertEqual(sut.password, "")
    }
}
