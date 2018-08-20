/***************************************************************************************************
 NegatedPredicate+NegatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension NegatedPredicate: NegatablePredicate where Predicate: NegatablePredicate {
  public mutating func negate() {
    self._predicateToBeNegated = self._predicateToBeNegated.negated
  }
  
  public var negated: NegatedPredicate<Predicate> {
    return NegatedPredicate<Predicate>(negating:self._predicateToBeNegated.negated)
  }
}


