/***************************************************************************************************
 ConsolidatablePredicateTests.swift
   © 2018,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import XCTest
@testable import Predicate
@testable import PredicateTestSupporters

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct ConsolidatablePredicateTests {
  let lessThanFour = DicePredicate([.one, .two, .three])
  let oddNumbers   = DicePredicate([.one, .three, .five])

  let expected_and    = DicePredicate([.one, .three])
  let expected_or     = DicePredicate([.one, .two, .three, .five])
  let expected_xor    = DicePredicate([.two, .five])
  let expected_xnor   = DicePredicate([.one, .three, .four, .six])
  let expected_then_1 = DicePredicate([.one, .three, .four, .five, .six])
  let expected_then_2 = DicePredicate([.one, .two, .three, .four, .six])

  @Test func consolidation() {
    #expect(DicePredicate(consolidating:lessThanFour.and(oddNumbers)) == expected_and)
    #expect(DicePredicate(consolidating:lessThanFour.or(oddNumbers)) == expected_or)
    #expect(DicePredicate(consolidating:lessThanFour.xor(oddNumbers)) == expected_xor)
    #expect(DicePredicate(consolidating:lessThanFour.xnor(oddNumbers)) == expected_xnor)
    #expect(DicePredicate(consolidating:lessThanFour.then(oddNumbers)) == expected_then_1)
    #expect(DicePredicate(consolidating:oddNumbers.then(lessThanFour)) == expected_then_2)
  }

  @Test func negativeConsolidation() {
    let greaterThanThree = NegatedPredicate(negating:lessThanFour)
    let evenNumbers = NegatedPredicate(negating:oddNumbers)

    #expect(greaterThanThree.evaluate(with:.four))
    #expect(evenNumbers.evaluate(with:.six))
    #expect(!greaterThanThree.evaluate(with:.one))
    #expect(!evenNumbers.evaluate(with:.one))

    let greaterThanThree_and_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.and(evenNumbers))
    let greaterThanThree_or_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.or(evenNumbers))
    let greaterThanThree_xor_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.xor(evenNumbers))
    let greaterThanThree_xnor_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.xnor(evenNumbers))
    let greaterThanThree_then_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.then(evenNumbers))

    #expect(greaterThanThree_and_evenNumbers.evaluate(with:.six))
    #expect(!greaterThanThree_and_evenNumbers.evaluate(with:.one))
    #expect(!greaterThanThree_and_evenNumbers.evaluate(with:.two))
    #expect(!greaterThanThree_and_evenNumbers.evaluate(with:.five))

    #expect(greaterThanThree_or_evenNumbers.evaluate(with:.six))
    #expect(!greaterThanThree_or_evenNumbers.evaluate(with:.one))
    #expect(greaterThanThree_or_evenNumbers.evaluate(with:.two))
    #expect(greaterThanThree_or_evenNumbers.evaluate(with:.five))

    #expect(!greaterThanThree_xor_evenNumbers.evaluate(with:.six))
    #expect(!greaterThanThree_xor_evenNumbers.evaluate(with:.one))
    #expect(greaterThanThree_xor_evenNumbers.evaluate(with:.two))
    #expect(greaterThanThree_xor_evenNumbers.evaluate(with:.five))

    #expect(greaterThanThree_xnor_evenNumbers.evaluate(with:.six))
    #expect(greaterThanThree_xnor_evenNumbers.evaluate(with:.one))
    #expect(!greaterThanThree_xnor_evenNumbers.evaluate(with:.two))
    #expect(!greaterThanThree_xnor_evenNumbers.evaluate(with:.five))

    #expect(greaterThanThree_then_evenNumbers.evaluate(with:.six))
    #expect(greaterThanThree_then_evenNumbers.evaluate(with:.one))
    #expect(greaterThanThree_then_evenNumbers.evaluate(with:.two))
    #expect(!greaterThanThree_then_evenNumbers.evaluate(with:.five))
  }

  @Test func anyEquatablePredicate() {
    let any_lessThanFour = AnyEquatablePredicate(lessThanFour)
    let any_oddNumbers   = AnyEquatablePredicate(oddNumbers)

    #expect(any_lessThanFour.evaluate(with:.two))
    #expect(any_oddNumbers.evaluate(with:.five))

    #expect(any_lessThanFour.negated.evaluate(with:.four))
    #expect(any_oddNumbers.negated.evaluate(with:.four))

    #expect(any_lessThanFour.and(any_oddNumbers) == AnyEquatablePredicate(expected_and))
    #expect(any_lessThanFour.or(any_oddNumbers) == AnyEquatablePredicate(expected_or))
    #expect(any_lessThanFour.xor(any_oddNumbers) == AnyEquatablePredicate(expected_xor))
    #expect(any_lessThanFour.xnor(any_oddNumbers) == AnyEquatablePredicate(expected_xnor))
    #expect(any_lessThanFour.then(any_oddNumbers) == AnyEquatablePredicate(expected_then_1))
    #expect(any_oddNumbers.then(any_lessThanFour) == AnyEquatablePredicate(expected_then_2))


    let any_greaterThanThree = any_lessThanFour.negated
    let any_evenNumbers      = any_oddNumbers.negated

    #expect(any_greaterThanThree.and(any_evenNumbers) == AnyEquatablePredicate(expected_or).negated)
    #expect(any_greaterThanThree.or(any_evenNumbers) == AnyEquatablePredicate(expected_and).negated)
    #expect(any_greaterThanThree.xor(any_evenNumbers) == AnyEquatablePredicate(expected_xor))
    #expect(any_greaterThanThree.xnor(any_evenNumbers) == AnyEquatablePredicate(expected_xnor))
    #expect(any_greaterThanThree.then(any_evenNumbers) == AnyEquatablePredicate(any_lessThanFour).or(any_oddNumbers.negated))
    #expect(any_evenNumbers.then(any_greaterThanThree) == AnyEquatablePredicate(any_oddNumbers).or(any_lessThanFour.negated))
  }
}
#else
final class ConsolidatablePredicateTests: XCTestCase {
  let lessThanFour = DicePredicate([.one, .two, .three])
  let oddNumbers   = DicePredicate([.one, .three, .five])
  
  let expected_and    = DicePredicate([.one, .three])
  let expected_or     = DicePredicate([.one, .two, .three, .five])
  let expected_xor    = DicePredicate([.two, .five])
  let expected_xnor   = DicePredicate([.one, .three, .four, .six])
  let expected_then_1 = DicePredicate([.one, .three, .four, .five, .six])
  let expected_then_2 = DicePredicate([.one, .two, .three, .four, .six])
  
  func testConsolidation() {
    XCTAssertEqual(DicePredicate(consolidating:lessThanFour.and(oddNumbers)),
                   expected_and)
    XCTAssertEqual(DicePredicate(consolidating:lessThanFour.or(oddNumbers)),
                   expected_or)
    XCTAssertEqual(DicePredicate(consolidating:lessThanFour.xor(oddNumbers)),
                   expected_xor)
    XCTAssertEqual(DicePredicate(consolidating:lessThanFour.xnor(oddNumbers)),
                   expected_xnor)
    XCTAssertEqual(DicePredicate(consolidating:lessThanFour.then(oddNumbers)),
                   expected_then_1)
    XCTAssertEqual(DicePredicate(consolidating:oddNumbers.then(lessThanFour)),
                   expected_then_2)
  }
  
  func testNegativeConsolidation() {
    let greaterThanThree = NegatedPredicate(negating:lessThanFour)
    let evenNumbers = NegatedPredicate(negating:oddNumbers)
    
    XCTAssertTrue(greaterThanThree.evaluate(with:.four))
    XCTAssertTrue(evenNumbers.evaluate(with:.six))
    XCTAssertFalse(greaterThanThree.evaluate(with:.one))
    XCTAssertFalse(evenNumbers.evaluate(with:.one))
    
    let greaterThanThree_and_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.and(evenNumbers))
    let greaterThanThree_or_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.or(evenNumbers))
    let greaterThanThree_xor_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.xor(evenNumbers))
    let greaterThanThree_xnor_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.xnor(evenNumbers))
    let greaterThanThree_then_evenNumbers = NegatedPredicate(consolidating:greaterThanThree.then(evenNumbers))
    
    XCTAssertTrue(greaterThanThree_and_evenNumbers.evaluate(with:.six))
    XCTAssertFalse(greaterThanThree_and_evenNumbers.evaluate(with:.one))
    XCTAssertFalse(greaterThanThree_and_evenNumbers.evaluate(with:.two))
    XCTAssertFalse(greaterThanThree_and_evenNumbers.evaluate(with:.five))
    
    XCTAssertTrue(greaterThanThree_or_evenNumbers.evaluate(with:.six))
    XCTAssertFalse(greaterThanThree_or_evenNumbers.evaluate(with:.one))
    XCTAssertTrue(greaterThanThree_or_evenNumbers.evaluate(with:.two))
    XCTAssertTrue(greaterThanThree_or_evenNumbers.evaluate(with:.five))
    
    XCTAssertFalse(greaterThanThree_xor_evenNumbers.evaluate(with:.six))
    XCTAssertFalse(greaterThanThree_xor_evenNumbers.evaluate(with:.one))
    XCTAssertTrue(greaterThanThree_xor_evenNumbers.evaluate(with:.two))
    XCTAssertTrue(greaterThanThree_xor_evenNumbers.evaluate(with:.five))
    
    XCTAssertTrue(greaterThanThree_xnor_evenNumbers.evaluate(with:.six))
    XCTAssertTrue(greaterThanThree_xnor_evenNumbers.evaluate(with:.one))
    XCTAssertFalse(greaterThanThree_xnor_evenNumbers.evaluate(with:.two))
    XCTAssertFalse(greaterThanThree_xnor_evenNumbers.evaluate(with:.five))
    
    XCTAssertTrue(greaterThanThree_then_evenNumbers.evaluate(with:.six))
    XCTAssertTrue(greaterThanThree_then_evenNumbers.evaluate(with:.one))
    XCTAssertTrue(greaterThanThree_then_evenNumbers.evaluate(with:.two))
    XCTAssertFalse(greaterThanThree_then_evenNumbers.evaluate(with:.five))
  }
  
  func testAnyEquatablePredicate() {
    let any_lessThanFour = AnyEquatablePredicate(lessThanFour)
    let any_oddNumbers   = AnyEquatablePredicate(oddNumbers)
    
    XCTAssertTrue(any_lessThanFour.evaluate(with:.two))
    XCTAssertTrue(any_oddNumbers.evaluate(with:.five))
    
    XCTAssertTrue(any_lessThanFour.negated.evaluate(with:.four))
    XCTAssertTrue(any_oddNumbers.negated.evaluate(with:.four))
    
    XCTAssertEqual(any_lessThanFour.and(any_oddNumbers),
                   AnyEquatablePredicate(expected_and))
    XCTAssertEqual(any_lessThanFour.or(any_oddNumbers),
                   AnyEquatablePredicate(expected_or))
    XCTAssertEqual(any_lessThanFour.xor(any_oddNumbers),
                   AnyEquatablePredicate(expected_xor))
    XCTAssertEqual(any_lessThanFour.xnor(any_oddNumbers),
                   AnyEquatablePredicate(expected_xnor))
    XCTAssertEqual(any_lessThanFour.then(any_oddNumbers),
                   AnyEquatablePredicate(expected_then_1))
    XCTAssertEqual(any_oddNumbers.then(any_lessThanFour),
                   AnyEquatablePredicate(expected_then_2))
    
    
    let any_greaterThanThree = any_lessThanFour.negated
    let any_evenNumbers      = any_oddNumbers.negated
    
    XCTAssertEqual(any_greaterThanThree.and(any_evenNumbers),
                   AnyEquatablePredicate(expected_or).negated)
    XCTAssertEqual(any_greaterThanThree.or(any_evenNumbers),
                   AnyEquatablePredicate(expected_and).negated)
    XCTAssertEqual(any_greaterThanThree.xor(any_evenNumbers),
                   AnyEquatablePredicate(expected_xor))
    XCTAssertEqual(any_greaterThanThree.xnor(any_evenNumbers),
                   AnyEquatablePredicate(expected_xnor))
    XCTAssertEqual(any_greaterThanThree.then(any_evenNumbers),
                   AnyEquatablePredicate(any_lessThanFour).or(any_oddNumbers.negated))
    XCTAssertEqual(any_evenNumbers.then(any_greaterThanThree),
                   AnyEquatablePredicate(any_oddNumbers).or(any_lessThanFour.negated))
  }
}
#endif
