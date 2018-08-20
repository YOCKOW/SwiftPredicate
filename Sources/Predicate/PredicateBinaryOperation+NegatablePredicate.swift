/***************************************************************************************************
 PredicateBinaryOperation+NegatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension PredicateBinaryOperation:NegatablePredicate where P:NegatablePredicate, Q:NegatablePredicate {
  public mutating func negate() {
    switch self {
    case .conjunction(let pp, let qq):
      self = .disjunction(pp.negated, qq.negated)
    case .disjunction(let pp, let qq):
      self = .conjunction(pp.negated, qq.negated)
    case .exclusiveDisjunction(let pp, let qq):
      self = .equivalence(pp, qq)
    case .equivalence(let pp, let qq):
      self = .exclusiveDisjunction(pp, qq)
    case .materialImplication(let pp, let qq):
      self = .conjunction(pp, qq.negated)
    }
  }
}
