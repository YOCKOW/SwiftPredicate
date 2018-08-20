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
  /// Negates the receiver.
  public mutating func negate() {
    let copied = self.copy() as! Self
    self = type(of:self).init(notPredicateWithSubpredicate:copied)
  }
}

extension NSCompoundPredicate: ConsolidatablePredicate {
  public func isEqual<P>(to other:P) -> Bool where P: EquatablePredicate {
    return self.isEqual(to:other as Any?)
  }
  
  public var negated: NSCompoundPredicate {
    let copied = self.copy() as! NSCompoundPredicate
    return NSCompoundPredicate(notPredicateWithSubpredicate:copied)
  }
  
  public func and(_ other:NSCompoundPredicate) -> Self {
    return type(of:self).init(andPredicateWithSubpredicates:[self, other])
  }
  
  public func or(_ other: NSCompoundPredicate) -> Self {
    return type(of:self).init(orPredicateWithSubpredicates:[self, other])
  }
}

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

