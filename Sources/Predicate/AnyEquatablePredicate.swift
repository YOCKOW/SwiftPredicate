/***************************************************************************************************
 AnyEquatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

///
/// A type-erasure for `EquatablePredicate`.
public struct AnyEquatablePredicate<Variable>: EquatablePredicate {
  private let _box: _AnyEquatablePredicateBox<Variable>
  internal var box: _AnyEquatablePredicateBox<Variable> { return self._box } // testable
  
  private init(_ box:_AnyEquatablePredicateBox<Variable>) { self._box = box }
  
  private init(_anyEquatablePredicate predicate:AnyEquatablePredicate<Variable>) {
    // prevent to make a deep box.
    self.init(predicate._box.copy())
  }
  
  /// Creates an instance erasing the type of `negatedPredicate`.
  public init<P>(_ negatedPredicate:NegatedPredicate<P>)
    where P:EquatablePredicate, P.Variable == Variable
  {
    self.init(_AnyEquatablePredicateBox._EqBox<P>(negatedPredicate.negated, isNegated:true))
  }
  
  /// Creates an instance erasing the type of `negatedPredicate`.
  public init<P>(_ negatedPredicate:NegatedPredicate<P>)
    where P:ConsolidatablePredicate, P.Variable == Variable
  {
    self.init(_AnyEquatablePredicateBox._ConsolBox<P>(negatedPredicate.negated.negated, isNegated:false))
  }
  
  /// Creates an instance erasing the type of `predicate`.
  /// - parameter predicate: A predicate to be packaged.
  public init<P>(_ predicate:P) where P:EquatablePredicate, P.Variable == Variable {
    if case let anyEqP as AnyEquatablePredicate<Variable> = predicate  {
      self.init(_anyEquatablePredicate:anyEqP)
    } else {
      self.init(_AnyEquatablePredicateBox._EqBox<P>(predicate))
    }
  }
  
  /// Creates an instance erasing the type of `predicate`.
  /// - parameter predicate: A predicate to be packaged.
  public init<P>(_ predicate:P) where P:ConsolidatablePredicate, P.Variable == Variable {
    if case let anyEqP as AnyEquatablePredicate<Variable> = predicate  {
      self.init(_anyEquatablePredicate:anyEqP)
    } else {
      self.init(_AnyEquatablePredicateBox._ConsolBox<P>(predicate))
    }
  }
  
  public func evaluate(with argument: Variable) -> Bool {
    return self._box.evaluate(with:argument)
  }
  
  public static func ==(lhs:AnyEquatablePredicate<Variable>,
                        rhs:AnyEquatablePredicate<Variable>) -> Bool
  {
    return lhs._box == rhs._box // not `isEqual(to:)`
  }
}

extension AnyEquatablePredicate {
  /// Returns a Boolean value indicating
  /// whether the receiver can be considered the same as `other`.
  public func isEqual<P>(to other:P) -> Bool where P:EquatablePredicate, P.Variable == Variable {
    return self._box.isEqual(to:other)
  }
}

extension AnyEquatablePredicate: NegatablePredicate {
  public mutating func negate() {
    self._box.negate()
  }
  
  public var negated: AnyEquatablePredicate<Variable> {
    return AnyEquatablePredicate<Variable>(self._box.negated)
  }
}

// Letting `AnyEquatablePredicate` conform to `ConsolidatablePredicate` may induce bugs...
extension AnyEquatablePredicate /* : ConsolidatablePredicate */ {
  public func and(_ other: AnyEquatablePredicate<Variable>) -> AnyEquatablePredicate<Variable> {
    return AnyEquatablePredicate<Variable>(self._box.and(other._box))
  }
  public func or(_ other: AnyEquatablePredicate<Variable>) -> AnyEquatablePredicate<Variable> {
    return AnyEquatablePredicate<Variable>(self._box.or(other._box))
  }
  public func xor(_ other: AnyEquatablePredicate<Variable>) -> AnyEquatablePredicate<Variable> {
    return AnyEquatablePredicate<Variable>(self._box.xor(other._box))
  }
  public func xnor(_ other: AnyEquatablePredicate<Variable>) -> AnyEquatablePredicate<Variable> {
    return AnyEquatablePredicate<Variable>(self._box.xnor(other._box))
  }
  public func then(_ other: AnyEquatablePredicate<Variable>) -> AnyEquatablePredicate<Variable> {
    return AnyEquatablePredicate<Variable>(self._box.then(other._box))
  }
}

