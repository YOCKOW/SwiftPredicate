import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(ConsolidatablePredicateTests.allTests),
    testCase(EquatablePredicateTests.allTests),
    testCase(NSPredicateTests.allTests),
    testCase(ProtocolExtensionTests.allTests),
    testCase(SimplePredicateTests.allTests),
    testCase(TotallyOrderedSetTests.allTests),
  ]
}
#endif

