/***************************************************************************************************
 AnyEquatablePredicateBox.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

///
/// for abstract class.
private func _mustBeOverriden(file:StaticString = #file, line:UInt = #line) -> Never {
  fatalError("Method must be overridden.", file:file, line:line)
}

internal class _AnyEquatablePredicateBox<Variable>: EquatablePredicate {
  internal func base<EqP>(as type:EqP.Type) -> EqP? where EqP: EquatablePredicate { _mustBeOverriden() }
  internal var isNegated: Bool { _mustBeOverriden() }
  
  internal func evaluate(with argument:Variable) -> Bool { _mustBeOverriden() }
  internal func negate() { _mustBeOverriden() }
  
  internal func copy() -> Self { _mustBeOverriden() }
  
  internal func _isEqual<EqP>(to other:EqP, isNegated:Bool) -> Bool where EqP:EquatablePredicate, EqP.Variable == Variable { _mustBeOverriden() }
  internal func isEqual(to other:_AnyEquatablePredicateBox<Variable>) -> Bool { _mustBeOverriden() }
  internal func isEqual<EqP>(to other:EqP) -> Bool where EqP:EquatablePredicate, EqP.Variable == Variable { _mustBeOverriden() }
  
  internal func and(_ other:_AnyEquatablePredicateBox<Variable>) -> _AnyEquatablePredicateBox<Variable> { _mustBeOverriden() }
  internal func or(_ other:_AnyEquatablePredicateBox<Variable>) -> _AnyEquatablePredicateBox<Variable> { _mustBeOverriden() }
  internal func xor(_ other:_AnyEquatablePredicateBox<Variable>) -> _AnyEquatablePredicateBox<Variable> { _mustBeOverriden() }
  internal func xnor(_ other:_AnyEquatablePredicateBox<Variable>) -> _AnyEquatablePredicateBox<Variable> { _mustBeOverriden() }
  internal func then(_ other:_AnyEquatablePredicateBox<Variable>) -> _AnyEquatablePredicateBox<Variable> { _mustBeOverriden() }
  
  internal var negated: _AnyEquatablePredicateBox {
    let copied = self.copy()
    copied.negate()
    return copied
  }
  
  internal static func ==(lhs: _AnyEquatablePredicateBox<Variable>,
                          rhs: _AnyEquatablePredicateBox<Variable>) -> Bool
  {
    return lhs.isEqual(to:rhs) || rhs.isEqual(to:lhs)
    // not `&&` but `||`
    // because there may be some cases that `rhs` is `_ConsolBox` and `lhs` is `_EqBox`
  }
}

extension _AnyEquatablePredicateBox {
  internal class _EqBox<P>: _AnyEquatablePredicateBox where P:EquatablePredicate, P.Variable == Variable {
    fileprivate var _base: P
    fileprivate var _isNegated: Bool
    internal required init(_ base:P, isNegated:Bool = false) {
      self._base = base
      self._isNegated = isNegated
    }
    
    override internal func base<EqP>(as type:EqP.Type) -> EqP? where EqP: EquatablePredicate {
      guard case let base as EqP = self._base else { return nil }
      return base
    }
    override internal var isNegated: Bool {
      return self._isNegated
    }
    
    override internal func evaluate(with argument:Variable) -> Bool {
      let result = self._base.evaluate(with:argument)
      return self.isNegated ? !result : result
    }
    override internal func negate() {
      self._isNegated = !self._isNegated
    }
    
    override internal func copy() -> Self {
      return type(of:self).init(self._base, isNegated:self.isNegated)
    }
    
    override internal func _isEqual<EqP>(to other:EqP, isNegated:Bool) -> Bool
      where EqP: EquatablePredicate, EqP.Variable == Variable
    {
      guard self.isNegated == isNegated else { return false }
      return self._base.isEqual(to:other)
    }
    override internal func isEqual(to other: _AnyEquatablePredicateBox<Variable>) -> Bool {
      return other._isEqual(to:self._base, isNegated:self.isNegated)
    }
    override internal func isEqual<EqP>(to other:EqP) -> Bool
      where EqP: EquatablePredicate, EqP.Variable == Variable
    {
      if case let anyEqP as _AnyEquatablePredicateBox<Variable> = other {
        return self == anyEqP
      }
      return self._isEqual(to:other, isNegated:false)
    }
    
    
    private typealias _SomeBox = _AnyEquatablePredicateBox<Variable>
    private typealias _Op = PredicateBinaryOperation<_SomeBox, _SomeBox>
    
    override internal func and(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      return _EqBox<_Op>((self as _SomeBox).and(other))
    }
    override internal func or(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      return _EqBox<_Op>((self as _SomeBox).or(other))
    }
    override internal func xor(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      return _EqBox<_Op>((self as _SomeBox).xor(other))
    }
    override internal func xnor(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      return _EqBox<_Op>((self as _SomeBox).xnor(other))
    }
    override internal func then(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      return _EqBox<_Op>((self as _SomeBox).then(other))
    }
  }
}

extension _AnyEquatablePredicateBox {
  internal class _ConsolBox<P>: _EqBox<P> where P:ConsolidatablePredicate, P.Variable ==Variable {
    internal required init(_ base:P, isNegated:Bool = false) {
      if isNegated { super.init(base.negated as P, isNegated:false) }
      else { super.init(base, isNegated:false) }
    }
    
    override internal func negate() {
      self._base.negate()
    }
    
    override internal func _isEqual<EqP>(to other:EqP, isNegated:Bool) -> Bool
      where EqP: EquatablePredicate, EqP.Variable == Variable
    {
      return (isNegated ? self._base.negated : self._base).isEqual(to:other)
    }
    
    override internal func and(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      guard let otherP = other.base(as:P.self) else { return super.and(other) }
      return _ConsolBox<P>(self._base.and(otherP))
    }
    override internal func or(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      guard let otherP = other.base(as:P.self) else { return super.or(other) }
      return _ConsolBox<P>(self._base.or(otherP))
    }
    override internal func xor(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      guard let otherP = other.base(as:P.self) else { return super.xor(other) }
      return _ConsolBox<P>(self._base.xor(otherP))
    }
    override internal func xnor(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      guard let otherP = other.base(as:P.self) else { return super.xnor(other) }
      return _ConsolBox<P>(self._base.xnor(otherP))
    }
    override internal func then(_ other:_AnyEquatablePredicateBox<Variable>)
      -> _AnyEquatablePredicateBox<Variable>
    {
      guard let otherP = other.base(as:P.self) else { return super.then(other) }
      return _ConsolBox<P>(self._base.then(otherP))
    }
  }
}
