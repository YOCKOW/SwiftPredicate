/***************************************************************************************************
 EquatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

///
/// A protocol for predicates that conform to `Equatable`.
public protocol EquatablePredicate: Equatable, PredicateProtocol {
  /// Returns a Boolean value indicating whether the given predicate can be regarded the same
  /// as the receiver or not.
  ///
  /// Note: In some cases, the results of `p.isEqual(to:q)` and `q.isEqual(to:p)` may differ
  ///       when the type of `p` is not equal to the type of `q`.
  ///
  /// Default implementation provided.
  func isEqual<P>(to other:P) -> Bool where P:EquatablePredicate, P.Variable == Variable
}

// default implementation
extension EquatablePredicate {
  public func isEqual<P>(to other:P) -> Bool where P:EquatablePredicate, P.Variable == Variable {
    guard case let otherPredicate as Self = other else { return false }
    return self == otherPredicate
  }
}
