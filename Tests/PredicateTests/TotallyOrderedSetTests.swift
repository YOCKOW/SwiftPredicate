/* *************************************************************************************************
 TotallyOrderedSetTests.swift
   © 2018-2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import Predicate

import Ranges

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct TotallyOrderedSetTests {
  @Test func uncountableSet() {
    let set1 = TotallyOrderedSet<Double>(elementsIn:[...<0.0, 1.0....2.0, 3.0<...])
    let set2 = TotallyOrderedSet<Double>(elementsIn:[(-2.0)<...(-1.0), 0.5...<1.5, 2.0<...<3.5])

    #expect(set1.contains(-Double.infinity))
    #expect(!set1.contains(0.0))
    #expect(set1.contains(sqrt(2.0)))
    #expect(set1.contains(Double.infinity))

    #expect(set1.inverted == TotallyOrderedSet<Double>(elementsIn:[0.0...<1.0, 2.0<...3.0]))

    #expect(
      set1.intersection(set2)
      == TotallyOrderedSet<Double>(elementsIn:[(-2.0)<...(-1.0), 1.0...<1.5, 3.0<...<3.5])
    )

    #expect(set1.union(set2) == TotallyOrderedSet<Double>(elementsIn:[...<0.0, 0.5....]))

    #expect(
      set1.symmetricDifference(set2)
      == TotallyOrderedSet<Double>(
        elementsIn: [
          ....(-2.0),
          (-1.0)<...<0.0,
          0.5...<1.0,
          1.5....3.0,
          3.5....,
        ]
      )
    )
  }

  @Test func countableSet() {
    let set1 = TotallyOrderedSet<Int>(elementsIn:0..<10)
    let set2 = TotallyOrderedSet<Int>(elementsIn:9<..20)
    #expect(set1.isDisjoint(with:set2))
  }
}
#else
final class TotallyOrderedSetTests: XCTestCase {
  func testUncountableSet() {
    let set1 = TotallyOrderedSet<Double>(elementsIn:[...<0.0, 1.0....2.0, 3.0<...])
    let set2 = TotallyOrderedSet<Double>(elementsIn:[(-2.0)<...(-1.0), 0.5...<1.5, 2.0<...<3.5])
    
    XCTAssertTrue(set1.contains(-Double.infinity))
    XCTAssertFalse(set1.contains(0.0))
    XCTAssertTrue(set1.contains(sqrt(2.0)))
    XCTAssertTrue(set1.contains(Double.infinity))
    
    XCTAssertEqual(set1.inverted,
                   TotallyOrderedSet<Double>(elementsIn:[0.0...<1.0, 2.0<...3.0]))
    
    XCTAssertEqual(set1.intersection(set2),
                   TotallyOrderedSet<Double>(elementsIn:[(-2.0)<...(-1.0), 1.0...<1.5, 3.0<...<3.5]))
    
    XCTAssertEqual(set1.union(set2),
                   TotallyOrderedSet<Double>(elementsIn:[...<0.0, 0.5....]))
    
    XCTAssertEqual(set1.symmetricDifference(set2),
                   TotallyOrderedSet<Double>(elementsIn:[
                    ....(-2.0),
                    (-1.0)<...<0.0,
                    0.5...<1.0,
                    1.5....3.0,
                    3.5....,
                  ]))
  }
  
  func testCountableSet() {
    let set1 = TotallyOrderedSet<Int>(elementsIn:0..<10)
    let set2 = TotallyOrderedSet<Int>(elementsIn:9<..20)
    XCTAssertTrue(set1.isDisjoint(with:set2))
  }
}
#endif
