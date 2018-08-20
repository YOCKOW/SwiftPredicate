/***************************************************************************************************
 MutableCollection+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension MutableCollection {
  /// Reorders the elements of the collection such that all the elements that
  /// match the given `predicate` are after all the elements that don’t match.
  public mutating func partition<Predicate>(by predicate:Predicate) -> Index
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.partition(by:{ predicate.evaluate(with:$0) })
  }
}
