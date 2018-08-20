/***************************************************************************************************
 EquatablePredicateTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Predicate
@testable import PredicateTestSupporters

final class EquatablePredicateTests: XCTestCase {
  func testEquation() {
    let a0 = SimpleEquatablePredicateA(0)
    let a0_1 = SimpleEquatablePredicateA(0)
    let a1 = SimpleEquatablePredicateA(1)
    
    let b0 = SimpleEquatablePredicateB(0)
    let b0_1 = SimpleEquatablePredicateB(0)
    let b1 = SimpleEquatablePredicateB(1)
    
    XCTAssertEqual(a0, a0_1)
    XCTAssertEqual(b0, b0_1)
    XCTAssertNotEqual(a0, a1)
    XCTAssertNotEqual(b0, b1)
    
    XCTAssertEqual(a0.and(a1), a1.and(a0))
    XCTAssertEqual(a0.or(a1), a1.or(a0))
    XCTAssertEqual(a0.xor(a1), a1.xor(a0))
    XCTAssertEqual(a0.then(a1), a0.then(a1)) // `then` is not commutative.
    XCTAssertNotEqual(a0.then(a1), a1.then(a0)) // `then` is not commutative.
    XCTAssertEqual(a0.xnor(a1), a1.xnor(a0))
    
    XCTAssertEqual(a0.and(b1), a0.and(b1))
    XCTAssertEqual(a0.or(b1), a0.or(b1))
    XCTAssertEqual(a0.xor(b1), a0.xor(b1))
    XCTAssertEqual(a0.then(b1), a0.then(b1))
    XCTAssertEqual(a0.xnor(b1), a0.xnor(b1))
    
    XCTAssertTrue(a0.and(b1) == b1.and(a0_1))
    XCTAssertTrue(a0.or(b1) == b1.or(a0_1))
    XCTAssertTrue(a0.xor(b1) == b1.xor(a0_1))
    XCTAssertFalse(a0.then(b1) == b1.then(a0_1)) // `then` is not commutative.
    XCTAssertTrue(a0.xnor(b1) == b1.xnor(a0_1))
  }
  
  func testAnyEquatablePredicate() {
    let a0 = SimpleEquatablePredicateA(0)
    let a0_1 = SimpleEquatablePredicateA(0)
    let b0 = SimpleEquatablePredicateB(0)
    
    let notA0: NegatedPredicate<SimpleEquatablePredicateA> = a0.negated
    
    let anyA0 = AnyEquatablePredicate<Int>(a0)
    let anyA0_1 = AnyEquatablePredicate<Int>(a0_1)
    let anyB0 = AnyEquatablePredicate<Int>(b0)
    
    let anyNotA0 = AnyEquatablePredicate<Int>(notA0)
    
    let anyAnyA0 = AnyEquatablePredicate<Int>(anyA0)
    let anyAnyAnyA0 = AnyEquatablePredicate<Int>(AnyEquatablePredicate<Int>(anyAnyA0))
    
    XCTAssertTrue(anyA0.evaluate(with:0))
    XCTAssertFalse(anyNotA0.evaluate(with:0))
    
    XCTAssertEqual(anyA0, anyA0_1)
    XCTAssertNotEqual(anyA0, anyB0)
    XCTAssertEqual(anyAnyA0, anyA0_1)
    XCTAssertEqual(anyAnyAnyA0, anyA0_1)
    
    XCTAssertTrue(anyA0.isEqual(to:a0_1))
    XCTAssertFalse(anyNotA0.isEqual(to:a0))
    
    XCTAssertEqual(anyA0.box.base(as:SimpleEquatablePredicateA.self), a0)
    XCTAssertEqual(anyAnyAnyA0.box.base(as:SimpleEquatablePredicateA.self), a0)
    XCTAssertEqual(anyNotA0.box.base(as:SimpleEquatablePredicateA.self), a0)
    XCTAssertEqual(anyA0.box.negated.base(as:SimpleEquatablePredicateA.self), a0)
    
    XCTAssertFalse(anyA0.box.isNegated)
    XCTAssertTrue(anyNotA0.box.isNegated)
    XCTAssertTrue(anyA0.box.negated.isNegated)
    
    
    XCTAssertTrue(anyA0.box.isEqual(to:anyA0_1.box))
    XCTAssertFalse(anyA0.box.negated.isEqual(to:anyA0_1.box))
    
    XCTAssertEqual(anyA0.box.negated, anyNotA0.box)
    XCTAssertEqual(anyA0.box, anyNotA0.box.negated)
    
    XCTAssertEqual(anyA0.negated, anyNotA0)
    XCTAssertEqual(anyA0, anyNotA0.negated)
    
    // commutative operations
    XCTAssertEqual(anyA0.and(anyA0_1), anyA0_1.and(anyA0))
    XCTAssertEqual(anyA0.and(anyB0), anyB0.and(anyA0_1))
    XCTAssertEqual(anyA0.or(anyA0_1), anyA0_1.or(anyA0))
    XCTAssertEqual(anyA0.or(anyB0), anyB0.or(anyA0_1))
    XCTAssertEqual(anyA0.xor(anyA0_1), anyA0_1.xor(anyA0))
    XCTAssertEqual(anyA0.xor(anyB0), anyB0.xor(anyA0_1))
    XCTAssertEqual(anyA0.xnor(anyA0_1), anyA0_1.xnor(anyA0))
    XCTAssertEqual(anyA0.xnor(anyB0), anyB0.xnor(anyA0_1))
    // non-commutative operations
    XCTAssertEqual(anyA0.then(anyA0_1), anyA0_1.then(anyA0))
    XCTAssertNotEqual(anyA0.then(anyB0), anyB0.then(anyA0_1))
  }
  
  static var allTests = [
    ("testEquation", testEquation),
    ("testAnyEquatablePredicate", testAnyEquatablePredicate),
  ]
}
