/***************************************************************************************************
 NegatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

import Foundation

/// A protocol for predicates that can be negated and its type is also `Self`.
public protocol NegatablePredicate: PredicateProtocol {
  /// Negates the predicate represented by the receiver.
  mutating func negate()
}

extension NegatablePredicate {
  /// Returns the instance that is negation of the receiver.
  ///
  /// Warning: This computed property should be overridden by some classes, because
  ///          this property uses `mutating func negate()` internally.
  public var negated: Self {
    var instance = self
    instance.negate()
    return instance
  }
}

extension NegatablePredicate where Self: NSCopying {
  /// Returns the instance that is negation of the receiver.
  public var negated: Self {
    var instance = self.copy(with:nil) as! Self
    instance.negate()
    return instance
  }
}
