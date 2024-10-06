/***************************************************************************************************
 ProtocolExtensionTests.swift
   © 2018,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import XCTest
@testable import Predicate
@testable import PredicateTestSupporters

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct ProtocolExtensionTests {
  @Test func sequence() {
    let dictionary: [String:Int] = [
      "0":0,
      "1":1,
      "2":2,
      "3":3,
      "4":4,
      "5":5,
      "6":6,
      "7":7,
      "8":8,
      "9":9,
    ]

    let somePair = { (key:String,value:Int) -> Bool in key == "5" && value == 5 }
    let somePairPredicate = SimplePredicateA<(key:String,value:Int)>(somePair)

    let invalidPair = { (key:String,value:Int) -> Bool in key == "0" && value == 9 }
    let invalidPairPredicate = SimplePredicateB<(key:String,value:Int)>(invalidPair)

    let allSatisfy = { (key:String,value:Int) -> Bool in return value >= 0 && value < 10 }
    let allSatisfyPredicate = SimplePredicateA<(key:String,value:Int)>(allSatisfy)

    let firstFive = {(key:String, value:Int) -> Bool in
      return dictionary.index(forKey:key)! < dictionary.index(dictionary.startIndex, offsetBy:5)
    }
    let firstFivePredicate = SimplePredicateB<(key:String,value:Int)>(firstFive)

    let filter = {(key:String, value:Int) -> Bool in return value < 5 }
    let filterPredicate = SimplePredicateA<(key:String,value:Int)>(filter)

    #expect(dictionary.contains(where:somePair))
    #expect(dictionary.contains(where:somePairPredicate))
    #expect(!dictionary.contains(where:invalidPair))
    #expect(!dictionary.contains(where:invalidPairPredicate))

    #expect(dictionary.first(where:somePair)! == dictionary.first(where:somePairPredicate)!)

    #expect(dictionary.allSatisfy(allSatisfy))
    #expect(dictionary.allSatisfy(allSatisfyPredicate))

    let dropped1 = dictionary.drop(while:firstFive)
    let dropped2 = dictionary.drop(while:firstFivePredicate)
    #expect(dropped1.count == 5)
    #expect(dropped1.count == dropped2.count)

    #expect(dictionary.filter(filter) == dictionary.filter(filterPredicate))

    let prefix1 = dictionary.prefix(while:firstFive)
    let prefix2 = dictionary.prefix(while:firstFivePredicate)
    #expect(prefix1.count == 5)
    #expect(prefix1.count == prefix2.count)
  }

  @Test func collection() {
    let array = [9,8,7,6,5,4,3,2,1,0]

    let lessThanFive = { (ii:Int) -> Bool in ii < 5 }
    let lessThanFivePredicate = SimplePredicateA<Int>(lessThanFive)

    #expect(array.firstIndex(where:lessThanFive) == 5)
    #expect(array.firstIndex(where:lessThanFive) == array.firstIndex(where:lessThanFivePredicate))
    #expect(array.lastIndex(where:lessThanFive) == 9)
    #expect(array.lastIndex(where:lessThanFive) == array.lastIndex(where:lessThanFivePredicate))
  }

  @Test func rangeReplaceableCollection() {
    var array = [10,90,70,20,60,30,80,50,40, 0]
    let predicate = AnyPredicate<Int>({ $0 < 50 })
    array.removeAll(where:predicate)
    #expect(array == [90,70,60,80,50])
  }
}
#else
final class ProtocolExtensionTests: XCTestCase {
  func testSequence() {
    let dictionary: [String:Int] = [
      "0":0,
      "1":1,
      "2":2,
      "3":3,
      "4":4,
      "5":5,
      "6":6,
      "7":7,
      "8":8,
      "9":9,
    ]
    
    let somePair = { (key:String,value:Int) -> Bool in key == "5" && value == 5 }
    let somePairPredicate = SimplePredicateA<(key:String,value:Int)>(somePair)
    
    let invalidPair = { (key:String,value:Int) -> Bool in key == "0" && value == 9 }
    let invalidPairPredicate = SimplePredicateB<(key:String,value:Int)>(invalidPair)
    
    let allSatisfy = { (key:String,value:Int) -> Bool in return value >= 0 && value < 10 }
    let allSatisfyPredicate = SimplePredicateA<(key:String,value:Int)>(allSatisfy)
    
    let firstFive = {(key:String, value:Int) -> Bool in
      return dictionary.index(forKey:key)! < dictionary.index(dictionary.startIndex, offsetBy:5)
    }
    let firstFivePredicate = SimplePredicateB<(key:String,value:Int)>(firstFive)
    
    let filter = {(key:String, value:Int) -> Bool in return value < 5 }
    let filterPredicate = SimplePredicateA<(key:String,value:Int)>(filter)
    
    XCTAssertTrue(dictionary.contains(where:somePair))
    XCTAssertTrue(dictionary.contains(where:somePairPredicate))
    XCTAssertFalse(dictionary.contains(where:invalidPair))
    XCTAssertFalse(dictionary.contains(where:invalidPairPredicate))
    
    XCTAssertTrue(dictionary.first(where:somePair)! == dictionary.first(where:somePairPredicate)!)
    
    XCTAssertTrue(dictionary.allSatisfy(allSatisfy))
    XCTAssertTrue(dictionary.allSatisfy(allSatisfyPredicate))
    
    let dropped1 = dictionary.drop(while:firstFive)
    let dropped2 = dictionary.drop(while:firstFivePredicate)
    XCTAssertEqual(dropped1.count, 5)
    XCTAssertEqual(dropped1.count, dropped2.count)
    
    XCTAssertEqual(dictionary.filter(filter), dictionary.filter(filterPredicate))
    
    let prefix1 = dictionary.prefix(while:firstFive)
    let prefix2 = dictionary.prefix(while:firstFivePredicate)
    XCTAssertEqual(prefix1.count, 5)
    XCTAssertEqual(prefix1.count, prefix2.count)
  }
  
  func testCollection() {
    let array = [9,8,7,6,5,4,3,2,1,0]
    
    let lessThanFive = { (ii:Int) -> Bool in ii < 5 }
    let lessThanFivePredicate = SimplePredicateA<Int>(lessThanFive)
    
    XCTAssertEqual(array.firstIndex(where:lessThanFive), 5)
    XCTAssertEqual(array.firstIndex(where:lessThanFive), array.firstIndex(where:lessThanFivePredicate))
    XCTAssertEqual(array.lastIndex(where:lessThanFive), 9)
    XCTAssertEqual(array.lastIndex(where:lessThanFive), array.lastIndex(where:lessThanFivePredicate))
  }
  
  func testRangeReplaceableCollection() {
    var array = [10,90,70,20,60,30,80,50,40, 0]
    let predicate = AnyPredicate<Int>({ $0 < 50 })
    array.removeAll(where:predicate)
    XCTAssertEqual(array, [90,70,60,80,50])
  }
}
#endif
