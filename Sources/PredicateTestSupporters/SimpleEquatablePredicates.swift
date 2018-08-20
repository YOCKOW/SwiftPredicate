/***************************************************************************************************
 SimpleEquatablePredicates.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Predicate


public struct SimpleEquatablePredicateA: EquatablePredicate {
  public let integer: Int
  public init(_ integer:Int) { self.integer = integer }
  
  public typealias Variable = Int
  public func evaluate(with argument: Int) -> Bool {
    return self.integer == argument
  }
  
  public static func ==(lhs:SimpleEquatablePredicateA, rhs:SimpleEquatablePredicateA) -> Bool {
    return lhs.integer == rhs.integer
  }
}

public struct SimpleEquatablePredicateB: EquatablePredicate {
  public let integer: Int
  public init(_ integer:Int) { self.integer = integer }
  
  public typealias Variable = Int
  public func evaluate(with argument: Int) -> Bool {
    return self.integer == argument
  }
  
  public static func ==(lhs:SimpleEquatablePredicateB, rhs:SimpleEquatablePredicateB) -> Bool {
    return lhs.integer == rhs.integer
  }
}
