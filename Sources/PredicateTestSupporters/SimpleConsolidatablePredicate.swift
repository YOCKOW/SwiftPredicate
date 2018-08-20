/***************************************************************************************************
 SimpleConsolidatablePredicate.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Predicate

public struct DicePredicate: ConsolidatablePredicate {
  public enum Pips: Hashable { case one,two,three,four,five,six }
  
  internal var _pips: Set<Pips>
  public typealias Variable = Pips
  
  public init(_ pips:Set<Pips>) {
    self._pips = pips
  }
  
  public func evaluate(with argument:DicePredicate.Pips) -> Bool {
    return self._pips.contains(argument)
  }
  
  public static func ==(lhs:DicePredicate, rhs:DicePredicate) -> Bool {
    return lhs._pips == rhs._pips
  }
  
  public mutating func negate() {
    var newPips: Set<Pips> = []
    for pp in ([.one, .two, .three, .four, .five, .six] as [Pips]) {
      if !self._pips.contains(pp) { newPips.insert(pp) }
    }
    self._pips = newPips
  }
  
  public func and(_ other:DicePredicate) -> DicePredicate {
    var newDicePredicate = DicePredicate([])
    for op in other._pips {
      if self._pips.contains(op) { newDicePredicate._pips.insert(op) }
    }
    return newDicePredicate
  }
}
