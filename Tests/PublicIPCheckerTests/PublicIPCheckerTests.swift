import XCTest
@testable import PublicIPChecker

final class PublicIPCheckerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PublicIPChecker().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
