/* *************************************************************************************************
 TotallyOrderedSetTests.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import Predicate

import Ranges

final class TotallyOrderedSetTests: XCTestCase {
  func testUncountableSet() {
    let set1 = TotallyOrderedSet<Double>(elementsIn:[
      AnyRange<Double>(..<0.0),
      AnyRange<Double>(1.0...2.0),
      AnyRange<Double>(3.0<..)
    ])
    let set2 = TotallyOrderedSet<Double>(elementsIn:[
      AnyRange<Double>((-2.0)<..(-1.0)),
      AnyRange<Double>(0.5..<1.5),
      AnyRange<Double>(2.0<..<3.5)
    ])
    
    XCTAssertTrue(set1.contains(-Double.infinity))
    XCTAssertFalse(set1.contains(0.0))
    XCTAssertTrue(set1.contains(sqrt(2.0)))
    XCTAssertTrue(set1.contains(Double.infinity))
    
    XCTAssertEqual(set1.inverted,
                   TotallyOrderedSet<Double>(elementsIn:[
                     AnyRange<Double>(0.0..<1.0),
                     AnyRange<Double>(2.0<..3.0),
                   ]))
    
    XCTAssertEqual(set1.intersection(set2),
                   TotallyOrderedSet<Double>(elementsIn:[
                     AnyRange<Double>((-2.0)<..(-1.0)),
                     AnyRange<Double>(1.0..<1.5),
                     AnyRange<Double>(3.0<..<3.5),
                   ]))
    
    XCTAssertEqual(set1.union(set2),
                   TotallyOrderedSet<Double>(elementsIn:[
                    AnyRange<Double>(..<0.0),
                    AnyRange<Double>(0.5...),
                  ]))
    
    XCTAssertEqual(set1.symmetricDifference(set2),
                   TotallyOrderedSet<Double>(elementsIn:[
                    AnyRange<Double>(...(-2.0)),
                    AnyRange<Double>((-1.0)<..<0.0),
                    AnyRange<Double>(0.5..<1.0),
                    AnyRange<Double>(1.5...3.0),
                    AnyRange<Double>(3.5...),
                  ]))
  }
  
  func testCountableSet() {
    let set1 = TotallyOrderedSet<Int>(elementsIn:0..<10)
    let set2 = TotallyOrderedSet<Int>(elementsIn:9<..20)
    XCTAssertTrue(set1.isDisjoint(with:set2))
  }
  
  static var allTests = [
    ("testUncountableSet", testUncountableSet),
    ("testCountableSet", testCountableSet),
  ]
}
