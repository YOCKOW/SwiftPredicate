/***************************************************************************************************
 String+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
extension String {
  /// Returns a new string of the characters that satisfy the given predicate.
  public func filter<Predicate>(_ predicate:Predicate) -> String
    where Predicate:PredicateProtocol, Predicate.Variable == Character
  {
    return self.filter({ predicate.evaluate(with:$0) })
  }
}
