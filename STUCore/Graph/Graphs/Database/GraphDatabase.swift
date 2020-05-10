//
//  GraphDatabase.swift
//  STUCore
//
//  Created by John McAvey on 5/4/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public protocol IdentifiedObject {
    var identifier: String { get set }
}

public protocol DatabaseValue: IdentifiedObject {
    var data: Data { get set }
}

public protocol DatabaseEdge: IdentifiedObject {
    associatedtype ValueKind: DatabaseValue
    var source: ValueKind { get set }
    var destination: ValueKind { get set }
    var label: ValueKind? { get set }
}

public protocol GraphDatabase {
    associatedtype ValueKind
    associatedtype EdgeKind: DatabaseEdge where EdgeKind.ValueKind == ValueKind
    
    var values: [ValueKind] { get }
    
    func newVertex() -> ValueKind
    func newEdge() -> EdgeKind
    
    func edges(from: ValueKind) -> [EdgeKind]
    
    func commit() throws
}

extension IdentifiedObject {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension IdentifiedObject {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
}

extension DatabaseValue {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
        hasher.combine(self.data)
    }
}

extension DatabaseEdge where ValueKind: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
        hasher.combine(self.source)
        hasher.combine(self.destination)
    }
}
