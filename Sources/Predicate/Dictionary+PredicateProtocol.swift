/***************************************************************************************************
 Dictionary+PredicateProtocol.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension Dictionary {
  /// Returns a subsequence by skipping elements while predicate returns true
  /// and returning the remaining elements.
  public func drop<Predicate>(while predicate:Predicate) -> Slice<[Key:Value]>
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.drop(while:{ predicate.evaluate(with:$0) })
  }
  
  /// Returns a new dictionary containing the key-value pairs of the dictionary that
  /// satisfy the given predicate.
  public func filter<Predicate>(_ predicate:Predicate) -> [Key:Value]
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.filter({ predicate.evaluate(with:$0) })
  }
}
