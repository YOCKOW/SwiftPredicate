/***************************************************************************************************
 NSPredicateTests.swift
   © 2018,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import XCTest
@testable import Predicate

import Foundation

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct NSPredicateTests {
  @Test func consolidation() {
    #if !canImport(Darwin)
    // NSPredicate on Linux is useless.
    #else

    let firstNameKey = "FirstName"
    let familyNameKey = "FamilyName"

    let taro = "TARO"
    let jiro = "JIRO"
    let saburo = "SABURO"
    let shiro = "SHIRO"
    let goro = "GORO"

    let tanaka = "TANAKA"
    let sato = "SATO"
    let suzuki = "SUZUKI"

    let sampleData = NSArray(array:[
      [firstNameKey:taro, familyNameKey:tanaka],
      [firstNameKey:jiro, familyNameKey:tanaka],
      [firstNameKey:saburo, familyNameKey:tanaka],
      [firstNameKey:shiro, familyNameKey:tanaka],
      [firstNameKey:goro, familyNameKey:tanaka],

      [firstNameKey:taro, familyNameKey:sato],
      [firstNameKey:jiro, familyNameKey:sato],
      [firstNameKey:saburo, familyNameKey:sato],
      [firstNameKey:shiro, familyNameKey:sato],
      [firstNameKey:goro, familyNameKey:sato],

      [firstNameKey:taro, familyNameKey:suzuki],
      [firstNameKey:jiro, familyNameKey:suzuki],
      [firstNameKey:saburo, familyNameKey:suzuki],
      [firstNameKey:shiro, familyNameKey:suzuki],
      [firstNameKey:goro, familyNameKey:suzuki],
    ])

    let taroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, taro])
    let jiroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, jiro])
    let saburoPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, saburo])
    let shiroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, shiro])
    let goroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, goro])

    let tanakaPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[familyNameKey, tanaka])
    let satoPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[familyNameKey, sato])
    let suzukiPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[familyNameKey, suzuki])


    let countResults = { (list:[[String:String]], key:String, value:String) -> Int in
      return list.reduce(0) { $0 + ($1[key]! == value ? 1 : 0) }
    }

    let extractedTaro = sampleData.filtered(using:taroPredicate) as! [[String:String]]
    #expect(extractedTaro.count == 3)
    let familyNamesOfTaro = Set<String>(extractedTaro.map { $0[familyNameKey]! })
    XCTAssertEqual(familyNamesOfTaro, Set<String>([tanaka, sato, suzuki]))

    let jiroTanakaPredicate = NSCompoundPredicate(consolidating:jiroPredicate.and(tanakaPredicate))
    let extractedJiroTanaka = sampleData.filtered(using:jiroTanakaPredicate) as! [[String:String]]
    #expect(extractedJiroTanaka.count == 1)
    #expect(extractedJiroTanaka[0][firstNameKey] == jiro)
    #expect(extractedJiroTanaka[0][familyNameKey] == tanaka)

    let saburoOrSatoPredicate = NSCompoundPredicate(consolidating:saburoPredicate.or(satoPredicate))
    let extractedSaburoOrSato = sampleData.filtered(using:saburoOrSatoPredicate) as! [[String:String]]
    #expect(extractedSaburoOrSato.count == 7)
    #expect(countResults(extractedSaburoOrSato, firstNameKey, saburo) == 3)
    #expect(countResults(extractedSaburoOrSato, familyNameKey, sato) == 5)

    let shiroThenSuzukiPredicate = NSCompoundPredicate(consolidating:shiroPredicate.then(suzukiPredicate))
    let extractedShiroThenSuzuki = sampleData.filtered(using:shiroThenSuzukiPredicate) as! [[String:String]]
    #expect(extractedShiroThenSuzuki.count == 13)
    #expect(countResults(extractedShiroThenSuzuki, firstNameKey, taro) == 3)
    #expect(countResults(extractedShiroThenSuzuki, firstNameKey, jiro) == 3)
    #expect(countResults(extractedShiroThenSuzuki, firstNameKey, saburo) == 3)
    #expect(countResults(extractedShiroThenSuzuki, firstNameKey, shiro) == 1)
    #expect(countResults(extractedShiroThenSuzuki, firstNameKey, goro) == 3)

    let goroXnorTanakaPredicate = NSCompoundPredicate(consolidating:goroPredicate.xnor(tanakaPredicate))
    let extractedGoroXnorTanaka = sampleData.filtered(using:goroXnorTanakaPredicate) as! [[String:String]]
    #expect(extractedGoroXnorTanaka.count == 9)
    #expect(countResults(extractedGoroXnorTanaka, firstNameKey, taro) == 2)
    #expect(countResults(extractedGoroXnorTanaka, firstNameKey, jiro) == 2)
    #expect(countResults(extractedGoroXnorTanaka, firstNameKey, saburo) == 2)
    #expect(countResults(extractedGoroXnorTanaka, firstNameKey, shiro) == 2)
    #expect(countResults(extractedGoroXnorTanaka, firstNameKey, goro) == 1)

    #endif
  }
}
#else
final class NSPredicateTests: XCTestCase {
  func testConsolidation() {
    #if os(Linux)
    
    // NSPredicate on Linux is useless.
    
    #else
    
    let firstNameKey = "FirstName"
    let familyNameKey = "FamilyName"
    
    let taro = "TARO"
    let jiro = "JIRO"
    let saburo = "SABURO"
    let shiro = "SHIRO"
    let goro = "GORO"
    
    let tanaka = "TANAKA"
    let sato = "SATO"
    let suzuki = "SUZUKI"
    
    let sampleData = NSArray(array:[
      [firstNameKey:taro, familyNameKey:tanaka],
      [firstNameKey:jiro, familyNameKey:tanaka],
      [firstNameKey:saburo, familyNameKey:tanaka],
      [firstNameKey:shiro, familyNameKey:tanaka],
      [firstNameKey:goro, familyNameKey:tanaka],
      
      [firstNameKey:taro, familyNameKey:sato],
      [firstNameKey:jiro, familyNameKey:sato],
      [firstNameKey:saburo, familyNameKey:sato],
      [firstNameKey:shiro, familyNameKey:sato],
      [firstNameKey:goro, familyNameKey:sato],
      
      [firstNameKey:taro, familyNameKey:suzuki],
      [firstNameKey:jiro, familyNameKey:suzuki],
      [firstNameKey:saburo, familyNameKey:suzuki],
      [firstNameKey:shiro, familyNameKey:suzuki],
      [firstNameKey:goro, familyNameKey:suzuki],
    ])
    
    let taroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, taro])
    let jiroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, jiro])
    let saburoPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, saburo])
    let shiroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, shiro])
    let goroPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[firstNameKey, goro])
    
    let tanakaPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[familyNameKey, tanaka])
    let satoPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[familyNameKey, sato])
    let suzukiPredicate = NSPredicate(format:"%K LIKE %@", argumentArray:[familyNameKey, suzuki])
    
    
    let countResults = { (list:[[String:String]], key:String, value:String) -> Int in
      return list.reduce(0) { $0 + ($1[key]! == value ? 1 : 0) }
    }
    
    let extractedTaro = sampleData.filtered(using:taroPredicate) as! [[String:String]]
    XCTAssertEqual(extractedTaro.count, 3)
    let familyNamesOfTaro = Set<String>(extractedTaro.map { $0[familyNameKey]! })
    XCTAssertEqual(familyNamesOfTaro, Set<String>([tanaka, sato, suzuki]))
    
    let jiroTanakaPredicate = NSCompoundPredicate(consolidating:jiroPredicate.and(tanakaPredicate))
    let extractedJiroTanaka = sampleData.filtered(using:jiroTanakaPredicate) as! [[String:String]]
    XCTAssertEqual(extractedJiroTanaka.count, 1)
    XCTAssertEqual(extractedJiroTanaka[0][firstNameKey], jiro)
    XCTAssertEqual(extractedJiroTanaka[0][familyNameKey], tanaka)
    
    let saburoOrSatoPredicate = NSCompoundPredicate(consolidating:saburoPredicate.or(satoPredicate))
    let extractedSaburoOrSato = sampleData.filtered(using:saburoOrSatoPredicate) as! [[String:String]]
    XCTAssertEqual(extractedSaburoOrSato.count, 7)
    XCTAssertEqual(countResults(extractedSaburoOrSato, firstNameKey, saburo), 3)
    XCTAssertEqual(countResults(extractedSaburoOrSato, familyNameKey, sato), 5)
    
    let shiroThenSuzukiPredicate = NSCompoundPredicate(consolidating:shiroPredicate.then(suzukiPredicate))
    let extractedShiroThenSuzuki = sampleData.filtered(using:shiroThenSuzukiPredicate) as! [[String:String]]
    XCTAssertEqual(extractedShiroThenSuzuki.count, 13)
    XCTAssertEqual(countResults(extractedShiroThenSuzuki, firstNameKey, taro), 3)
    XCTAssertEqual(countResults(extractedShiroThenSuzuki, firstNameKey, jiro), 3)
    XCTAssertEqual(countResults(extractedShiroThenSuzuki, firstNameKey, saburo), 3)
    XCTAssertEqual(countResults(extractedShiroThenSuzuki, firstNameKey, shiro), 1)
    XCTAssertEqual(countResults(extractedShiroThenSuzuki, firstNameKey, goro), 3)
    
    let goroXnorTanakaPredicate = NSCompoundPredicate(consolidating:goroPredicate.xnor(tanakaPredicate))
    let extractedGoroXnorTanaka = sampleData.filtered(using:goroXnorTanakaPredicate) as! [[String:String]]
    XCTAssertEqual(extractedGoroXnorTanaka.count, 9)
    XCTAssertEqual(countResults(extractedGoroXnorTanaka, firstNameKey, taro), 2)
    XCTAssertEqual(countResults(extractedGoroXnorTanaka, firstNameKey, jiro), 2)
    XCTAssertEqual(countResults(extractedGoroXnorTanaka, firstNameKey, saburo), 2)
    XCTAssertEqual(countResults(extractedGoroXnorTanaka, firstNameKey, shiro), 2)
    XCTAssertEqual(countResults(extractedGoroXnorTanaka, firstNameKey, goro), 1)
    
    #endif
  }
}
#endif
