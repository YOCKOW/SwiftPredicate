/***************************************************************************************************
 SimplePredicateTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import XCTest
@testable import Predicate
@testable import PredicateTestSupporters

final class SimplePredicateTests: XCTestCase {
  func testEvaluation() {
    // Note: These closures are just for the tests. They lack accuracy.
    let firstCharacterIsNumber: (String) -> Bool = {
      guard let first = $0.first else { return true }
      return first == "0" || first == "1" || first == "2" || first == "3" || first == "4" ||
             first == "5" || first == "6" || first == "7" || first == "8" || first == "9"
    }
    let firstCharacterIsUpper: (String) -> Bool = {
      return $0.uppercased().first == $0.first
    }
    let firstCharacerIsLower: (String) -> Bool = {
      return $0.lowercased().first == $0.first
    }
    
    // Note: The types of `predicateU` and `predicateL` are different.
    let predicateU = SimplePredicateA<String>({
      return firstCharacterIsNumber($0) || firstCharacterIsUpper($0)
    })
    let predicateL = SimplePredicateB<String>({
      return firstCharacterIsNumber($0) || firstCharacerIsLower($0)
    })
    
    let emptyString: String = ""
    let startsWithNumber = "0Aa"
    let startsWithUpper  = "Aa0"
    let startsWithLower  = "a0A"
    
    XCTAssertTrue(predicateU.evaluate(with:emptyString))
    XCTAssertTrue(predicateU.evaluate(with:startsWithNumber))
    XCTAssertTrue(predicateU.evaluate(with:startsWithUpper))
    XCTAssertFalse(predicateU.evaluate(with:startsWithLower))
    
    XCTAssertTrue(predicateL.evaluate(with:emptyString))
    XCTAssertTrue(predicateL.evaluate(with:startsWithNumber))
    XCTAssertFalse(predicateL.evaluate(with:startsWithUpper))
    XCTAssertTrue(predicateL.evaluate(with:startsWithLower))
    
    let predicateAND = predicateU.and(predicateL)
    XCTAssertTrue(predicateAND.evaluate(with:emptyString))
    XCTAssertTrue(predicateAND.evaluate(with:startsWithNumber))
    XCTAssertFalse(predicateAND.evaluate(with:startsWithUpper))
    XCTAssertFalse(predicateAND.evaluate(with:startsWithLower))
    
    let predicateOR = predicateU.or(predicateL)
    XCTAssertTrue(predicateOR.evaluate(with:emptyString))
    XCTAssertTrue(predicateOR.evaluate(with:startsWithNumber))
    XCTAssertTrue(predicateOR.evaluate(with:startsWithUpper))
    XCTAssertTrue(predicateOR.evaluate(with:startsWithLower))
    
    let predicateXOR = predicateU.xor(predicateL)
    XCTAssertFalse(predicateXOR.evaluate(with:emptyString))
    XCTAssertFalse(predicateXOR.evaluate(with:startsWithNumber))
    XCTAssertTrue(predicateXOR.evaluate(with:startsWithUpper))
    XCTAssertTrue(predicateXOR.evaluate(with:startsWithLower))
    
    let predicateU_THEN_L = predicateU.then(predicateL)
    XCTAssertTrue(predicateU_THEN_L.evaluate(with:emptyString))
    XCTAssertTrue(predicateU_THEN_L.evaluate(with:startsWithNumber))
    XCTAssertFalse(predicateU_THEN_L.evaluate(with:startsWithUpper))
    XCTAssertTrue(predicateU_THEN_L.evaluate(with:startsWithLower))
    
    let predicateL_THEN_U = predicateL.then(predicateU)
    XCTAssertTrue(predicateL_THEN_U.evaluate(with:emptyString))
    XCTAssertTrue(predicateL_THEN_U.evaluate(with:startsWithNumber))
    XCTAssertTrue(predicateL_THEN_U.evaluate(with:startsWithUpper))
    XCTAssertFalse(predicateL_THEN_U.evaluate(with:startsWithLower))
    
    let predicateXNOR = predicateU.xnor(predicateL)
    XCTAssertTrue(predicateXNOR.evaluate(with:emptyString))
    XCTAssertTrue(predicateXNOR.evaluate(with:startsWithNumber))
    XCTAssertFalse(predicateXNOR.evaluate(with:startsWithUpper))
    XCTAssertFalse(predicateXNOR.evaluate(with:startsWithLower))
  }
  
  
  
  
  static var allTests = [
    ("testEvaluation", testEvaluation),
  ]
}
