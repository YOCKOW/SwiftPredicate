/***************************************************************************************************
 NSPredicate+PredicateProtocol.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import Foundation
 
extension NSPredicate: PredicateProtocol {
  public typealias Variable = Any?
}

extension ConsolidatablePredicate where Self: NSCompoundPredicate {
  #if os(Linux)
  // I know this is a kind of bad workaround.
  fileprivate func _convert(_ predicate:NSCompoundPredicate) -> Self {
    guard case let obj as Self = predicate else {
      fatalError("Not supported for subclasses of `NSCompoundPredicate`.")
    }
    return obj
  }
  #endif
  
  /// Negates the receiver.
  public mutating func negate() {
    let copied = self.copy() as! Self
    #if os(Linux)
    self = self._convert(NSCompoundPredicate(notPredicateWithSubpredicate:copied))
    #else
    self = type(of:self).init(notPredicateWithSubpredicate:copied)
    #endif
  }
}

extension NSCompoundPredicate: ConsolidatablePredicate {
  public func isEqual<P>(to other:P) -> Bool where P: EquatablePredicate {
    #if os(Linux)
    return self.isEqual(other as Any?)
    #else
    return self.isEqual(to:other as Any?)
    #endif
  }
  
  public var negated: NSCompoundPredicate {
    let copied = self.copy() as! NSCompoundPredicate
    return NSCompoundPredicate(notPredicateWithSubpredicate:copied)
  }
}

#if os(Linux)
extension ConsolidatablePredicate where Self: NSCompoundPredicate {
  public func and(_ other:Self) -> Self {
    let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[self, other])
    return self._convert(compound)
  }
  
  public func or(_ other:Self) -> Self {
    let compound = NSCompoundPredicate(orPredicateWithSubpredicates:[self, other])
    return self._convert(compound)
  }
}
#else
extension NSCompoundPredicate: ConsolidatablePredicate {
  public func and(_ other:NSCompoundPredicate) -> Self {
    return type(of:self).init(andPredicateWithSubpredicates:[self, other])
  }
  
  public func or(_ other: NSCompoundPredicate) -> Self {
    return type(of:self).init(orPredicateWithSubpredicates:[self, other])
  }
}
#endif

extension NSCompoundPredicate {
  public convenience init(consolidating predicates:PredicateBinaryOperation<NSPredicate, NSPredicate>) {
    switch predicates {
    case .conjunction(let lp, let rp):
      self.init(andPredicateWithSubpredicates:[lp, rp])
    case .disjunction(let lp, let rp):
      self.init(orPredicateWithSubpredicates:[lp, rp])
    case .exclusiveDisjunction(let lp, let rp):
      let or = NSCompoundPredicate(orPredicateWithSubpredicates:[lp, rp])
      let notAnd = NSCompoundPredicate(andPredicateWithSubpredicates:[lp, rp]).negated
      self.init(andPredicateWithSubpredicates:[or, notAnd])
    case .materialImplication(let lp, let rp):
      let notL = NSCompoundPredicate(notPredicateWithSubpredicate:lp)
      self.init(orPredicateWithSubpredicates:[notL, rp])
    case .equivalence(let lp, let rp):
      let bothTrue = NSCompoundPredicate(andPredicateWithSubpredicates:[lp, rp])
      let notL = NSCompoundPredicate(notPredicateWithSubpredicate:lp)
      let notR = NSCompoundPredicate(notPredicateWithSubpredicate:rp)
      let bothFalse = NSCompoundPredicate(andPredicateWithSubpredicates:[notL, notR])
      self.init(orPredicateWithSubpredicates:[bothTrue, bothFalse])
    }
  }
}

