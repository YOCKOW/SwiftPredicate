/***************************************************************************************************
 Collection+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension Collection {
  #if swift(>=4.2)
  #else
  public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Index? {
    var ii = self.startIndex
    while true {
      if ii == self.endIndex { break }
      if try predicate(self[ii]) { return ii }
      ii = self.index(after:ii)
    }
    return nil
  }
  #endif
  
  /// Returns the first index in which an element of the collection satisfies the given predicate.
  public func firstIndex<Predicate>(where predicate:Predicate) -> Index?
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.firstIndex(where:{ predicate.evaluate(with:$0) })
  }
}

