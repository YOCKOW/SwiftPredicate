/***************************************************************************************************
 NegatedPredicate+EquatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension NegatedPredicate: Equatable, EquatablePredicate where Predicate: EquatablePredicate {
  public func isEqual<P>(to other:P) -> Bool where P:EquatablePredicate, P.Variable == Variable {
    guard case let otherNegP as NegatedPredicate<Predicate> = other else { return false }
    return self._predicateToBeNegated == otherNegP._predicateToBeNegated
  }
  
  public static func ==(lhs:NegatedPredicate<Predicate>, rhs:NegatedPredicate<Predicate>) -> Bool {
    return lhs.isEqual(to:rhs)
  }
}
