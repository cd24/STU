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
