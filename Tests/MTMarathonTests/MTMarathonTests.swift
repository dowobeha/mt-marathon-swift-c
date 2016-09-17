import XCTest
@testable import MTMarathon

class MTMarathonTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(MTMarathon().text, "Hello, World!")
    }


    static var allTests : [(String, (MTMarathonTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
