import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(send_key_to_appTests.allTests),
    ]
}
#endif
