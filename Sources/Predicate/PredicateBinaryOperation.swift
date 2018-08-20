/***************************************************************************************************
 PredicateBinaryOperation.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

///
/// # PredicateBinaryOperation
///
/// Represents binary operation of predicates.
///
public enum PredicateBinaryOperation<P, Q>: PredicateProtocol
  where P:PredicateProtocol, Q:PredicateProtocol, P.Variable == Q.Variable
{
  /// Evaluated as `true` when the results of both `P` and `Q` are `true`.
  ///
  /// i.e. *AND*
  case conjunction(P, Q)
  
  /// Evaluated as `true` when at least one of the results of `P` and `Q` is `true`.
  ///
  /// i.e. *OR*
  case disjunction(P, Q)
  
  /// Evaluated as `true` when the results of `P` and `Q` differ.
  ///
  /// i.e. *XOR*
  case exclusiveDisjunction(P, Q)

  /// Evaluated as `true` only if the result of `P` is equal to the result of `Q`.
  ///
  /// i.e. *XNOR*
  case equivalence(P, Q)
  
  ///  Evaluated as `false` only if the result of `P` is `true` and the result of `Q` is `false`.
  ///
  /// i.e. `P`⇒`Q`
  case materialImplication(P, Q)
  
  // --- Let me conform to `PredicateProtocol`  --- //
  
  public typealias Variable = P.Variable
  public func evaluate(with argument:Variable) -> Bool {
    switch self {
    case .conjunction(let pp, let qq):
      return pp.evaluate(with:argument) && qq.evaluate(with:argument)
    case .disjunction(let pp, let qq):
      return pp.evaluate(with:argument) || qq.evaluate(with:argument)
    case .exclusiveDisjunction(let pp, let qq):
      return pp.evaluate(with:argument) != qq.evaluate(with:argument)
    case .equivalence(let pp, let qq):
      return pp.evaluate(with:argument) == qq.evaluate(with:argument)
    case .materialImplication(let pp, let qq):
      return !pp.evaluate(with:argument) || qq.evaluate(with:argument)
    }
  }
}

extension PredicateProtocol {
  /// Creates an instance of `PredicteOperation` that is
  /// `.conjunction(self, other)`
  public func and<P>(_ other:P) -> PredicateBinaryOperation<Self, P> where P:PredicateProtocol {
    return .conjunction(self, other)
  }
  
  /// Creates an instance of `PredicteOperation` that is
  /// `.disjunction(self, other)`
  public func or<P>(_ other:P) -> PredicateBinaryOperation<Self, P> where P:PredicateProtocol {
    return .disjunction(self, other)
  }
  
  /// Creates an instance of `PredicteOperation` that is
  /// `.exclusiveDisjunction(self, other)`
  public func xor<P>(_ other:P) -> PredicateBinaryOperation<Self, P> where P:PredicateProtocol {
    return .exclusiveDisjunction(self, other)
  }
  
  /// Creates an instance of `PredicteOperation` that is
  /// `.equivalence(self, other)`
  public func xnor<P>(_ other:P) -> PredicateBinaryOperation<Self, P> where P:PredicateProtocol {
    return .equivalence(self, other)
  }
  
  /// Creates an instance of `PredicteOperation` that is
  /// `.materialImplication(self, other)`
  public func then<P>(_ other:P) -> PredicateBinaryOperation<Self, P> where P:PredicateProtocol {
    return .materialImplication(self, other)
  }
}
