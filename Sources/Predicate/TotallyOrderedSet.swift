/***************************************************************************************************
 TotallyOrderedSet.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Ranges

/// # TotallyOrderedSet
///
/// Represents a [totally ordered set](https://en.wikipedia.org/wiki/Total_order)
/// defined by a predicate that takes an argument which conforms to `Comparable`.
///
/// Notes:
/// * This is a kind of reference implementation for `IntensionalSet`.
/// * Some methods may return a little inadequate results
///   if you take no account of elements' countability.
public struct TotallyOrderedSet<Element> where Element: Comparable {
  private var _ranges: MultipleRanges<Element>
  
  /// Creates an instance with `ranges` that will define totally ordered set.
  public init(elementsIn ranges:MultipleRanges<Element>) {
    self._ranges = ranges
  }
}

extension TotallyOrderedSet {
  /// Creates an instance with `range` that will define the set.
  public init<R>(elementsIn range:R) where R:GeneralizedRange, R.Bound == Element {
    self._ranges = [AnyRange<Element>(range)]
  }
  /// Creates an instance with *countable* `range` that will define the set.
  public init<R>(elementsIn range:R)
    where R:GeneralizedRange, R.Bound == Element, R.Bound:Strideable, R.Bound.Stride:SignedInteger
  {
    self._ranges = [AnyRange<Element>(range)]
  }
}

extension TotallyOrderedSet {
  /// Creates an empty set.
  public init() { self._ranges = [] }
  
  /// Creates a set that contains all elements.
  public init(elementsIn _:UnboundedRange) { self._ranges = [AnyRange<Element>(...)] }
}


extension TotallyOrderedSet {
  /// Inserts elements in the specified `ranges`.
  /// This method does not depend on ranges' countability.
  public mutating func insert(elementsIn ranges:MultipleRanges<Element>) {
    self._ranges.formUnion(ranges)
  }
}

extension TotallyOrderedSet {
  /// Inserts elements in the specified `range`.
  public mutating func insert<R>(elementsIn range:R) where R:GeneralizedRange, R.Bound == Element {
    self._ranges.insert(range)
  }
  /// Inserts elements in the specified *coutable* `range`.
  public mutating func insert<R>(elementsIn range:R)
    where R:GeneralizedRange, R.Bound == Element, R.Bound:Strideable, R.Bound.Stride:SignedInteger
  {
    self._ranges.insert(range)
  }
  
  /// Inserts all elements.
  public mutating func insert(elementsIn _:UnboundedRange) {
    self._ranges = [AnyRange<Element>(...)]
  }
}

extension TotallyOrderedSet {
  /// Remove elements in the specified `ranges`.
  public mutating func remove(elementsIn ranges:MultipleRanges<Element>) {
    self._ranges.subtract(ranges)
  }
  
  /// Remove elements in the specified `range`.
  public mutating func remove<R>(elementsIn range:R) where R:GeneralizedRange, R.Bound == Element {
    self._ranges.subtract(range)
  }
  
  /// Remove all elements.
  public mutating func remove(elementsIn _:UnboundedRange) {
    self._ranges = []
  }
}
extension TotallyOrderedSet where Element:Strideable, Element.Stride:SignedInteger {
  /// Remove elements in the specified *countable* `ranges`.
  public mutating func remove(elementsIn ranges:MultipleRanges<Element>) {
    self._ranges.subtract(ranges)
  }
  
  /// Remove elements in the specified *countable* `range`.
  public mutating func remove<R>(elementsIn range:R) where R:GeneralizedRange, R.Bound == Element {
    self._ranges.subtract(range)
  }
}

extension TotallyOrderedSet: PredicateProtocol {
  public typealias Variable = Element
  public func evaluate(with argument:Element) -> Bool {
    return self._ranges.contains(argument)
  }
}

extension TotallyOrderedSet: Equatable {
  public static func ==(lhs:TotallyOrderedSet<Element>, rhs:TotallyOrderedSet<Element>) -> Bool {
    return lhs._ranges == rhs._ranges
  }
}
extension TotallyOrderedSet: EquatablePredicate {}


extension TotallyOrderedSet: NegatablePredicate {
  /// Negates the receiver as a predicate.
  public mutating func negate() {
    let unbounded: MultipleRanges<Element> = [AnyRange<Element>(...)]
    self._ranges = unbounded.subtracting(self._ranges)
  }
  /// Returns the negation of the receiver.
  public var negated: TotallyOrderedSet<Element> {
    var set = self
    set.negate()
    return set
  }
  
  /// Invert the contents of the set.
  public mutating func invert() {
    self.negate()
  }
  /// Returns an inverted copy of the receiver.
  public var inverted: TotallyOrderedSet<Element> {
    return self.negated
  }
}
extension TotallyOrderedSet where Element:Strideable, Element.Stride:SignedInteger {
  /// Negates the receiver as a predicate.
  /// Elements are treated as countable.
  public mutating func negate() {
    let unbounded: MultipleRanges<Element> = [AnyRange<Element>(...)]
    self._ranges = unbounded.subtracting(self._ranges)
  }
  /// Returns the negation of the receiver.
  public var negated: TotallyOrderedSet<Element> {
    var set = self
    set.negate()
    return set
  }
  
  /// Invert the contents of the set.
  public mutating func invert() {
    self.negate()
  }
  /// Returns an inverted copy of the receiver.
  public var inverted: TotallyOrderedSet<Element> {
    return self.negated
  }
}

extension TotallyOrderedSet: ConsolidatablePredicate {
  public func and(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return TotallyOrderedSet<Element>(elementsIn:self._ranges.intersection(other._ranges))
  }
  public func or(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return TotallyOrderedSet<Element>(elementsIn:self._ranges.union(other._ranges))
  }
  public func xor(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return TotallyOrderedSet<Element>(elementsIn:self._ranges.symmetricDifference(other._ranges))
  }
  public func xnor(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.xor(other).negated
  }
  public func then(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.negated.or(other)
  }
}
extension TotallyOrderedSet where Element:Strideable, Element.Stride:SignedInteger {
  public func and(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return TotallyOrderedSet<Element>(elementsIn:self._ranges.intersection(other._ranges))
  }
  // `or` does not depend on countability.
  public func xor(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return TotallyOrderedSet<Element>(elementsIn:self._ranges.symmetricDifference(other._ranges))
  }
  public func xnor(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.xor(other).negated
  }
  public func then(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.negated.or(other)
  }
}

extension TotallyOrderedSet: IntensionalSet {
  /// A Boolean value that indicates whether the set has no elements.
  public var isEmpty: Bool { return self._ranges.isEmpty }
  
  /// Returns a Boolean value that indicates whether the given element exists in the set.
  public func contains(_ member: Element) -> Bool {
    return self.evaluate(with:member)
  }
  
  @discardableResult
  public mutating func insert(_ newMember:Element) -> (inserted:Bool, memberAfterInsert:Element) {
    if self.contains(newMember) { return (false, newMember) }
    self.insert(elementsIn:newMember...newMember)
    return (true, newMember)
  }
  
  @discardableResult
  public mutating func update(with newMember:Element) -> Element? {
    let result = self.insert(newMember)
    return result.inserted ? nil : result.memberAfterInsert
  }
  
  @discardableResult
  public mutating func remove(_ member:Element) -> Element? {
    let contained = self.contains(member)
    self.remove(elementsIn:member...member)
    return contained ? member : nil
  }
}
extension TotallyOrderedSet where Element:Strideable, Element.Stride:SignedInteger {
  /// Inserts the given *countable* element in the set
  @discardableResult
  public mutating func insert(_ newMember:Element) -> (inserted:Bool, memberAfterInsert:Element) {
    if self.contains(newMember) { return (false, newMember) }
    self.insert(elementsIn:newMember...newMember)
    return (true, newMember)
  }
  
  /// Inserts the given *countable* element into the set unconditionally.
  @discardableResult
  public mutating func update(with newMember:Element) -> Element? {
    let result = self.insert(newMember)
    return result.inserted ? nil : result.memberAfterInsert
  }
  
  /// Removes the given element and any elements subsumed by the given *countable* element.
  @discardableResult
  public mutating func remove(_ member:Element) -> Element? {
    let contained = self.contains(member)
    self.remove(elementsIn:member...member)
    return contained ? member : nil
  }
  
  /// Returns a new set with the *countable* elements
  /// that are common to both this set and the given set.
  public func intersection(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.and(other)
  }
  
  /// Removes the *countable* elements of this set that aren’t also in the given set.
  public mutating func formIntersection(_ other:TotallyOrderedSet) {
    self._ranges.formIntersection(other._ranges)
  }
  
  /// Returns a new set with the *countable* elements of both this and the given set.
  public func union(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.or(other)
  }
  
  /// Adds the *countable* elements of the given set to the set.
  public mutating func formUnion(_ other:TotallyOrderedSet) {
    self._ranges.formUnion(other._ranges)
  }
  
  /// Returns a new set with the *countable* elements
  /// that are either in this set or in the given set, but not in both.
  public func symmetricDifference(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.xor(other)
  }
  
  /// Removes the *countable* elements of the set that are also in the given set
  /// and adds the *countable* members of the given set that are not already in the set.
  public mutating func formSymmetricDifference(_ other:TotallyOrderedSet) {
    self._ranges.formSymmetricDifference(other._ranges)
  }
  
  /// Returns a new set containing the *countable* elements of this set
  /// that do not occur in the given set.
  public func subtracting(_ other:TotallyOrderedSet) -> TotallyOrderedSet {
    return self.and(other.negated)
  }
  
  /// Removes the *countable* elements of the given set from this set.
  public mutating func subtract(_ other:TotallyOrderedSet) {
    self._ranges.subtract(other._ranges)
  }
  
  /// Returns a Boolean value that indicates whether the set has no members in common
  /// with the given set.
  public func isDisjoint(with other:TotallyOrderedSet) -> Bool {
    return self.intersection(other).isEmpty
  }
  
  /// Returns a Boolean value that indicates whether the set is a subset of another set.
  public func isSubset(of other: TotallyOrderedSet) -> Bool {
    return self.intersection(other) == self
  }
  
  /// Returns a Boolean value that indicates whether the set is a superset of the given set.
  public func isSuperset(of other: TotallyOrderedSet) -> Bool {
    return other.intersection(self) == other
  }
  
  /// Returns a Boolean value that indicates whether this set is a strict subset of the given set.
  public func isStrictSubset(of other:TotallyOrderedSet) -> Bool {
    return self != other && self.intersection(other) == self
  }
  
  /// Returns a Boolean value that indicates whether this set is a strict superset of the given set.
  public func isStrictSuperset(of other:TotallyOrderedSet) -> Bool {
    return self != other && other.intersection(self) == other
  }
}
