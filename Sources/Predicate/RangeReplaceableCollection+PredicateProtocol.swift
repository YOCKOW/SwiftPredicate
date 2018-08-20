/***************************************************************************************************
 RangeReplaceableCollection+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension RangeReplaceableCollection {
  public func filter<Predicate>(_ predicate: Predicate) -> Self
    where Predicate: PredicateProtocol, Predicate.Variable == Element
  {
    return self.filter({ predicate.evaluate(with:$0) })
  }
  
  #if swift(>=4.2)
  #else
  public mutating func removeAll(where predicate: (Element) throws -> Bool) rethrows {
    self = try self.filter({ try !predicate($0) })
  }
  #endif
  
  /// Removes from the collection all elements that satisfy the given `predicate`.
  public mutating func removeAll<Predicate>(where predicate:Predicate)
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    self.removeAll(where:{ predicate.evaluate(with:$0) })
  }
}
