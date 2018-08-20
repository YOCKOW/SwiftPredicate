/***************************************************************************************************
 AnyPredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

///
/// A type-erasure for `PredicateProtocol`.
public struct AnyPredicate<Variable>: PredicateProtocol {
  
  private var _predicate: (Variable) -> Bool
  
  public init(_ predicate:@escaping (Variable) -> Bool) {
    self._predicate = predicate
  }
  
  /// Creates an instance that equals `predicate`.
  public init<Predicate>(_ predicate:Predicate)
    where Predicate:PredicateProtocol, Predicate.Variable == Variable
  {
    self.init({ predicate.evaluate(with:$0) })
  }
  
  public func evaluate(with argument: Variable) -> Bool {
    return self._predicate(argument)
  }
}
