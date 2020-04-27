//
//  Functional.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

extension Dictionary {
    public typealias TupleForm = (key: Key, value: Value)
    
    public static func key(_ pair: TupleForm) -> Key {
        return pair.key
    }
}

public func key<K, V>() -> (Dictionary<K, V>.TupleForm) -> K {
    return { tuple in
        tuple.key
    }
}

public func value<K, V>() -> (Dictionary<K, V>.TupleForm) -> V {
    return { tuple in
        tuple.value
    }
}

extension Hashable {
    func found(in set: Set<Self>) -> Bool {
        return set.contains(self)
    }
}

public func conatined<T>(in set: Set<T>) -> (T) -> Bool {
    return { value in
        set.contains(value)
    }
}

infix operator •: AdditionPrecedence
public func •<A, B, C>(_ fn1: @escaping (B) -> C, _ fn2: @escaping (A) -> B) -> (A) -> C {
    return compose(fn1, fn2)
}

public func compose<A, B, C>(_ fn1: @escaping (B) -> C, _ fn2: @escaping (A) -> B) -> (A) -> C {
    return { value in fn1(fn2(value)) }
}


extension Dictionary {
    public mutating func remove(where predicate: @escaping (TupleForm) -> Bool) {
        self.filter(predicate).forEach { pair in
            self.removeValue(forKey: pair.key)
        }
    }
}

// MARK: - Unit, empty values

public protocol Unit {
    static func empty() -> Self
}

extension String: Unit {
    public static func empty() -> String { return "" }
}

extension Double: Unit {
    public static func empty() -> Self { return 0 }
}

extension Int: Unit {
    public static func empty() -> Self { return 0 }
}

extension Float: Unit {
    public static func empty() -> Self { return 0 }
}

extension UInt: Unit {
    public static func empty() -> Self { return 0 }
}

extension Float80: Unit {
    public static func empty() -> Self { return 0 }
}

// MARK: - Type Conversions

extension Array where Element: Hashable {
    public var set: Set<Element> {
        return Set(self)
    }
}

// MARK: - KeyPaths

infix operator |||: MultiplicationPrecedence
infix operator &&&: MultiplicationPrecedence
extension KeyPath where Value: Equatable {
    public static func |||(lhs: KeyPath<Root, Value>, rhs: KeyPath<Root, Value>) -> (Root) -> (Value) -> Bool {
        { root in { value in root[keyPath: lhs] == value || root[keyPath: rhs] == value } }
    }
    
    public static func |||(lhs: @escaping (Root) -> (Value) -> Bool, rhs: KeyPath<Root, Value>) -> (Root) -> (Value) -> Bool {
        { root in { value in lhs(root)(value) || root[keyPath: rhs] == value } }
    }
    
    public static func &&&(lhs: KeyPath<Root, Value>, rhs: KeyPath<Root, Value>) -> (Root) -> (Value) -> Bool {
        { root in { value in root[keyPath: lhs] == value && root[keyPath: rhs] == value } }
    }
    
    public static func &&&(lhs: @escaping (Root) -> (Value) -> Bool, rhs: KeyPath<Root, Value>) -> (Root) -> (Value) -> Bool {
        { root in { value in lhs(root)(value) && root[keyPath: rhs] == value } }
    }
    
    public static func ==(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool {
        return { root in root[keyPath: lhs] == rhs }
    }

    public static func !=(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool  {
        return { root in root[keyPath: lhs] != rhs }
    }
}

public func ==<A, T>(lhs: @escaping (A) -> (T) -> Bool, rhs: T) -> (A) -> Bool {
    return { inp in lhs(inp)(rhs) }
}

public func !=<A, T>(lhs: @escaping (A) -> (T) -> Bool, rhs: T) -> (A) -> Bool {
    return { inp in !lhs(inp)(rhs) }
}
