# What is `SwiftPredicate`?

You can abstractly treat [predicates](https://en.wikipedia.org/wiki/Predicate_(mathematical_logic))
with this library.

# Requirements

- Swift 4.1, 4.2
- macOS or Linux

## Dependency

- [SwiftRanges](https://github.com/YOCKOW/SwiftRanges)

# Usage

## Simple Predicate

```Swift
import Predicate

struct SimplePredicate<Variable>: PredicateProtocol {
  var _predicate: (Variable) -> Bool
  
  init(_ predicate:@escaping (Variable) -> Bool) {
    self._predicate = predicate
  }
  
  func evaluate(with argument: Variable) -> Bool {
    return self._predicate(argument)
  }
}

let predicate = SimplePredicate<Int>({ $0 == 0 })
print(predicate.evaluate(with:0)) // Prints "true"
print(predicate.evaluate(with:1)) // Prints "false"
```

## A set defined by a predicate

```Swift
import Predicate
import Ranges

let set1 = TotallyOrderedSet<Double>(elementsIn:[
  AnyRange<Double>(..<0.0),
  AnyRange<Double>(1.0...2.0),
  AnyRange<Double>(3.0<..)
])
let set2 = TotallyOrderedSet<Double>(elementsIn:[
  AnyRange<Double>((-2.0)<..(-1.0)),
  AnyRange<Double>(0.5..<1.5),
  AnyRange<Double>(2.0<.<3.5)
])

print(set1.inverted ==
      TotallyOrderedSet<Double>(elementsIn:[
        AnyRange<Double>(0.0..<1.0),
        AnyRange<Double>(2.0<..3.0),
      ])
     )
// Prints "true"

print(set1.intersection(set2) ==
      TotallyOrderedSet<Double>(elementsIn:[
        AnyRange<Double>((-2.0)<..(-1.0)),
        AnyRange<Double>(1.0..<1.5),
        AnyRange<Double>(3.0<.<3.5),
      ])
     )
// Prints "true"

print(set1.union(set2) ==
      TotallyOrderedSet<Double>(elementsIn:[
        AnyRange<Double>(..<0.0),
        AnyRange<Double>(0.5...),
      ])
     )
// Prints "true"
```


# License

MIT License.  
See "LICENSE.txt" for more information.
