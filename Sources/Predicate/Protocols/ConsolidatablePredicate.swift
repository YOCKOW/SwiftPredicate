/***************************************************************************************************
 ConsolidatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

///
/// A protocol for a predicate that can be consolidated with another predicate.
public protocol ConsolidatablePredicate: EquatablePredicate, NegatablePredicate {
  /// Creates a new instance that returns `true` under the condition only in which
  /// both `self` and `other` return `true`.
  func and(_ other:Self) -> Self
  
  /// Creates a new instance that returns `true` under the condition in which
  /// either `self` or `other` returns `true`, or in which both `self` and `other` return `true`.
  ///
  /// Default implementation provided.
  func or(_ other:Self) -> Self
  
  /// Creates a new instance that returns `true` under the condition only in which
  /// the result of `self` and the result of `other` differ.
  ///
  /// Default implementation provided.
  func xor(_ other:Self) -> Self
  
  /// Creates a new instance that retuns `true` under the condition only in which
  /// the results of `self` and `other` are the same.
  ///
  /// Default implementation provided.
  func xnor(_ other:Self) -> Self
  
  /// Creates a new instance that returns `false` under the condition only in which
  /// `self` returns `true` and `other`returns `false`.
  ///
  /// Default implementation provided.
  func then(_ other:Self) -> Self
}

// default implementation
extension ConsolidatablePredicate {
  public func or(_ other:Self) -> Self {
    return self.negated.and(other.negated).negated
  }
  
  public func xor(_ other:Self) -> Self {
    return self.or(other).and(self.and(other).negated)
  }
  
  public func xnor(_ other:Self) -> Self {
    return self.xor(other).negated
  }
  
  public func then(_ other:Self) -> Self {
    return self.negated.or(other)
  }
  
}

extension ConsolidatablePredicate {
  /// Consolidates two predicates into one.
  /// - parameter predicates: An instance of `PredicateBinaryOperation` that has two instances of `Self`
  ///                        to be consolidated.
  public init(consolidating predicates:PredicateBinaryOperation<Self, Self>) {
    switch predicates {
    case .conjunction(let lp, let rp):
      self = lp.and(rp)
    case .disjunction(let lp, let rp):
      self = lp.or(rp)
    case .exclusiveDisjunction(let lp, let rp):
      self = lp.xor(rp)
    case .equivalence(let lp, let rp):
      self = lp.xnor(rp)
    case .materialImplication(let lp, let rp):
      self = lp.then(rp)
    }
  }
}

