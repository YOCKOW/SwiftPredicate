/***************************************************************************************************
 PredicateBinaryOperation+EquatablePredicate.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

private func _simplyEqual<P,Q,R,S>(_ lhs:(P,Q), _ rhs:(R,S)) -> Bool
  where P:EquatablePredicate, Q:EquatablePredicate, R:EquatablePredicate, S:EquatablePredicate,
        P.Variable == Q.Variable, P.Variable == R.Variable, P.Variable == S.Variable
{
  return lhs.0.isEqual(to:rhs.0) && lhs.1.isEqual(to:rhs.1)
}

private func _commutativelyEqual<P,Q,R,S>(_ lhs:(P,Q), _ rhs:(R,S)) -> Bool
  where P:EquatablePredicate, Q:EquatablePredicate, R:EquatablePredicate, S:EquatablePredicate,
        P.Variable == Q.Variable, P.Variable == R.Variable, P.Variable == S.Variable
{
  if _simplyEqual(lhs, rhs) { return true }
  return lhs.0.isEqual(to:rhs.1) && lhs.1.isEqual(to:rhs.0)
}

private func _predicates_ifSameOperation<P,Q,R,S>(_ lhs:PredicateBinaryOperation<P,Q>,
                                                  _ rhs:PredicateBinaryOperation<R,S>) -> ((P,Q), (R,S))?
  where P:EquatablePredicate, Q:EquatablePredicate, R:EquatablePredicate, S:EquatablePredicate,
        P.Variable == Q.Variable, P.Variable == R.Variable
{
  switch (lhs, rhs) {
  case (.conjunction(let p, let q), .conjunction(let r, let s)),
       (.disjunction(let p, let q), .disjunction(let r, let s)),
       (.exclusiveDisjunction(let p, let q), .exclusiveDisjunction(let r, let s)),
       (.equivalence(let p, let q), .equivalence(let r, let s)),
       (.materialImplication(let p, let q), .materialImplication(let r, let s)):
    return ((p, q), (r, s))
  default:
    return nil
  }
}

private func _isEqual<P,Q,R,S>(_ lhs:PredicateBinaryOperation<P,Q>,
                               _ rhs:PredicateBinaryOperation<R,S>) -> Bool
  where P:EquatablePredicate, Q:EquatablePredicate, R:EquatablePredicate, S:EquatablePredicate,
        P.Variable == Q.Variable, P.Variable == R.Variable
{
  guard let predicates = _predicates_ifSameOperation(lhs, rhs) else { return false }
  if case .materialImplication = lhs {
    return _simplyEqual(predicates.0, predicates.1)
  } else {
    return _commutativelyEqual(predicates.0, predicates.1)
  }
}

extension PredicateBinaryOperation: Equatable, EquatablePredicate
  where P:EquatablePredicate, Q:EquatablePredicate
{
  public func isEqual<EqP>(to other:EqP) -> Bool
    where EqP: EquatablePredicate, EqP.Variable == Variable
  {
    if case let otherOp as PredicateBinaryOperation<P,Q> = other {
      return _isEqual(self, otherOp)
    } else if case let otherOp as PredicateBinaryOperation<Q,P> = other {
      return _isEqual(self, otherOp)
    }
    return false
  }
  
  public static func ==(lhs: PredicateBinaryOperation<P,Q>, rhs: PredicateBinaryOperation<P,Q>) -> Bool {
    return _isEqual(lhs, rhs)
  }
  
  /// Although this funciton is not required, it may be neccessary in some cases.
  public static func ==<R,S>(lhs:PredicateBinaryOperation<P,Q>, rhs:PredicateBinaryOperation<R,S>) -> Bool
    where R:EquatablePredicate, S:EquatablePredicate,
          P.Variable == R.Variable
  {
    return _isEqual(lhs, rhs)
  }
}
