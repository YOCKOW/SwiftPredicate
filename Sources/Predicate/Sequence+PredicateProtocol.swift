/***************************************************************************************************
 Sequence+PredicateProtocol.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension Sequence {
  /// Returns a Boolean value indicating whether the sequence contains an element
  /// that satisfies the given predicate.
  public func contains<Predicate>(where predicate:Predicate) -> Bool
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.contains(where:{ predicate.evaluate(with:$0) })
  }
  
  /// Returns the first element of the sequence that satisfies the given predicate.
  public func first<Predicate>(where predicate:Predicate) -> Element?
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.first(where:{ predicate.evaluate(with:$0) })
  }
  
  #if swift(>=4.1.50)
  #else
  public func allSatisfy(_ predicate:(Element) throws -> Bool) rethrows -> Bool {
    for element in self {
      if try !predicate(element) { return false }
    }
    return true
  }
  #endif
  
  /// Returns a Boolean value indicating whether every element of
  /// a sequence satisfies a given predicate.
  public func allSatisfy<Predicate>(_ predicate:Predicate) -> Bool
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.allSatisfy({ predicate.evaluate(with:$0) })
  }
  
  /// Returns a subsequence by skipping elements while predicate returns true
  /// and returning the remaining elements.
  public func drop<Predicate>(while predicate:Predicate) -> DropWhileSequence<Self>
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.drop(while:{ predicate.evaluate(with:$0) })
  }
  
  /// Returns an array containing, in order, the elements of the sequence that
  /// satisfy the given predicate.
  public func filter<Predicate>(_ predicate:Predicate) -> [Element]
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.filter({ predicate.evaluate(with:$0) })
  }
  
  /// Returns a subsequence containing the initial, consecutive elements that
  /// satisfy the given predicate.
  public func prefix<Predicate>(while predicate:Predicate) -> [Element]
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.prefix(while:{ predicate.evaluate(with:$0) })
  }
}
