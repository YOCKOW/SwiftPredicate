/***************************************************************************************************
 SimplePredicates.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

// These structures are just for the purpose of tests.

import Predicate

public struct SimplePredicateA<Variable>: PredicateProtocol {
  private var _predicate: (Variable) -> Bool
  
  public init(_ predicate:@escaping (Variable) -> Bool) {
    self._predicate = predicate
  }
  
  public func evaluate(with argument: Variable) -> Bool {
    return self._predicate(argument)
  }
}

public struct SimplePredicateB<Variable>: PredicateProtocol {
  private var _predicate: (Variable) -> Bool
  
  public init(_ predicate:@escaping (Variable) -> Bool) {
    self._predicate = predicate
  }
  
  public func evaluate(with argument: Variable) -> Bool {
    return self._predicate(argument)
  }
}


