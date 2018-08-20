/***************************************************************************************************
 NegatedPredicate+ConsolidatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension NegatedPredicate: ConsolidatablePredicate where Predicate: ConsolidatablePredicate {
  public func and(_ other: NegatedPredicate<Predicate>) -> NegatedPredicate<Predicate> {
    // ¬P ⋀ ¬Q = ¬(P ⋁ Q)
    return NegatedPredicate<Predicate>(
      negating:self._predicateToBeNegated.or(other._predicateToBeNegated)
    )
  }
  
  public func or(_ other: NegatedPredicate<Predicate>) -> NegatedPredicate<Predicate> {
    // ¬P ⋁ ¬Q = ¬(P ⋀ Q)
    return NegatedPredicate<Predicate>(
      negating:self._predicateToBeNegated.and(other._predicateToBeNegated)
    )
  }
  
  public func xor(_ other: NegatedPredicate<Predicate>) -> NegatedPredicate<Predicate> {
    // ¬P ⊕ ¬Q = ¬(¬(P ⊕ Q))
    return NegatedPredicate<Predicate>(
      negating:self._predicateToBeNegated.xor(other._predicateToBeNegated).negated
    )
  }
  
  public func xnor(_ other: NegatedPredicate<Predicate>) -> NegatedPredicate<Predicate> {
    // ¬P = ¬Q ⇔ ¬(¬(P = Q))
    return NegatedPredicate<Predicate>(
      negating:self._predicateToBeNegated.xnor(other._predicateToBeNegated).negated
    )
  }
  
  public func then(_ other: NegatedPredicate<Predicate>) -> NegatedPredicate<Predicate> {
    // ¬P ⇒ ¬Q ⇔ ¬(¬(Q ⇒ P))
    return NegatedPredicate<Predicate>(
      negating:other._predicateToBeNegated.then(self._predicateToBeNegated).negated
    )
  }
}
