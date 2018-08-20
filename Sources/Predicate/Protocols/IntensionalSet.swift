/***************************************************************************************************
 IntensionalSet.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Foundation

/// A type that provides set operations.
/// "IntensionalSet" means that the set is defined by predicate.
/// (It is not "Inten**t**ionalSet" because "intension" is a technical term in logic.)
///
/// There is default implementation of some methods required by `SetAlgebra`, however,
/// almost all of them depend on the methods of `ConsolidatablePredicate`.
/// It means that you had better implement the methods required by `ConsolidatablePredicate`
/// without using the methods of `SetAlgebra`.
public protocol IntensionalSet: SetAlgebra, ConsolidatablePredicate where Element == Variable {}

// default implementation
extension IntensionalSet {
  public func contains(_ member:Element) -> Bool {
    return !self.isEmpty && self.evaluate(with:member)
  }
  
  public func intersection(_ other:Self) -> Self {
    return self.and(other)
  }
  
  public mutating func formIntersection(_ other:Self) {
    self = self.and(other)
  }
  
  public func union(_ other:Self) -> Self {
    return self.or(other)
  }
  
  public mutating func formUnion(_ other:Self) {
    self = self.or(other)
  }
  
  public func symmetricDifference(_ other:Self) -> Self {
    return self.xor(other)
  }
  
  public mutating func formSymmetricDifference(_ other:Self) {
    self = self.xor(other)
  }
  
  public func subtracting(_ other:Self) -> Self {
    return self.and(other.negated)
  }
  
  public mutating func subtract(_ other:Self) {
    self = self.and(other.negated)
  }
  
  public func isDisjoint(with other:Self) -> Bool {
    return self.intersection(other).isEmpty
  }

  public func isSubset(of other: Self) -> Bool {
    return self.intersection(other) == self
  }

  public func isSuperset(of other: Self) -> Bool {
    return other.intersection(self) == other
  }

  public func isStrictSubset(of other:Self) -> Bool {
    return self != other && self.intersection(other) == self
  }

  public func isStrictSuperset(of other:Self) -> Bool {
    return self != other && other.intersection(self) == other
  }
}

extension IntensionalSet {
  /// Invert the contents of the set.
  public mutating func invert() {
    self.negate()
  }
  
  /// Returns an inverted copy of the receiver.
  ///
  /// Warning: This computed property should be overridden by some classes, because
  ///          this property uses `mutating func negate()` internally.
  public var invereted: Self {
    return self.negated
  }
}

extension IntensionalSet where Self: NSCopying {
  /// Returns an inverted copy of the receiver.
  public var invereted: Self {
    return self.negated
  }
}
