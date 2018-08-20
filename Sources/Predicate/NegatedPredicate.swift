/***************************************************************************************************
 NegatedPredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

///
/// Negated predicate.
/// You can create an instance by calling `var negated` of the object
/// that conforms to `PredicateProtocol`.
///
/// Of course, `somePredicate.negated.negated.evaluate(with:a) == somePredicate.evaluate(with:a)` is
/// always `true`.
public struct NegatedPredicate<Predicate>: PredicateProtocol where Predicate:PredicateProtocol {
  internal var _predicateToBeNegated:Predicate
  
  /// Creates an instance with `predicate`.
  /// The result of `evaluate(with:)` will be inverted from  original `predicate`.
  public init(negating predicate:Predicate) {
    self._predicateToBeNegated = predicate
  }
  
  public typealias Variable = Predicate.Variable
  public func evaluate(with argument:Variable) -> Bool {
    return !(self._predicateToBeNegated.evaluate(with:argument))
  }
}

extension PredicateProtocol {
  /// Creates an instance of `NegatedPredicate<Self>` that inverts the result.
  public var negated: NegatedPredicate<Self> {
    return NegatedPredicate<Self>(negating:self)
  }
}

extension NegatedPredicate {
  public var negated: Predicate {
    return self._predicateToBeNegated
  }
}

extension NegatedPredicate {
  /// Creates an instance with double-negated predicate.
  /// (To prevent a deep negated predicate.)
  public init(negating doubleNegation:NegatedPredicate<NegatedPredicate<Predicate>>) {
    self._predicateToBeNegated = doubleNegation._predicateToBeNegated._predicateToBeNegated
  }
}


