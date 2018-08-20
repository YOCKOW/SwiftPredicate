/***************************************************************************************************
 Dictionary+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
 
extension Dictionary {
  /// Returns a new dictionary containing the key-value pairs of the dictionary that
  /// satisfy the given predicate.
  public func filter<Predicate>(_ predicate:Predicate) -> [Key:Value]
    where Predicate:PredicateProtocol, Predicate.Variable == Element
  {
    return self.filter({ predicate.evaluate(with:$0) })
  }
}
