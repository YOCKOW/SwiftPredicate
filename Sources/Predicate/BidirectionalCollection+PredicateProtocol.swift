/***************************************************************************************************
 BidirectionalCollection+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension BidirectionalCollection {
  #if swift(>=4.2)
  #else
  public func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Index? {
    var ii = self.endIndex
    while true {
      ii = self.index(before:ii)
      if try predicate(self[ii]) { return ii }
      if ii == self.startIndex { break }
    }
    return nil
  }
  #endif
  
  /// Returns the index of the last element in the collection that matches the given predicate.
  public func lastIndex<Predicate>(where predicate:Predicate) -> Index?
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.lastIndex(where:{ predicate.evaluate(with:$0) })
  }
}
