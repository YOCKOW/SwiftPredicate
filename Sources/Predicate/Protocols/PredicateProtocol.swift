/***************************************************************************************************
 PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

///
/// A protocol for [predicates](https://en.wikipedia.org/wiki/Predicate_(mathematical_logic)).
public protocol PredicateProtocol {
  associatedtype Variable
  
  /// Evaluates the receiver as a predicate with `argument`.
  func evaluate(with argument:Variable) -> Bool
}

