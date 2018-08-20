/***************************************************************************************************
 LazyCollectionProtocol+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 

extension LazyCollectionProtocol {
  /// Returns a lazy collection that skips any initial elements that satisfy `predicate`.
  public func drop<Predicate>(while predicate:Predicate) -> LazyDropWhileCollection<Elements>
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.drop(while:{ predicate.evaluate(with:$0) })
  }
  
  /// Returns the elements of `self` that satisfy `predicate`.
  public func filter<Predicate>(_ predicate:Predicate) -> LazyFilterCollection<Elements>
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.filter({ predicate.evaluate(with:$0) })
  }
  
  /// Returns a lazy collection of the initial consecutive elements that satisfy `predicate`.
  public func prefix<Predicate>(_ predicate:Predicate) -> LazyPrefixWhileCollection<Elements>
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.prefix(while:{ predicate.evaluate(with:$0) })
  }
}
