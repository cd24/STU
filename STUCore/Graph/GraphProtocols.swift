//
//  Protocols.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public protocol Edge {
    associatedtype VertexKind: Vertex
    var source: VertexKind { get set }
    var destination: VertexKind { get set }
}

public protocol Weighted {
    var weight: Double { get set }
}

public protocol Vertex {
    associatedtype Value
    var value: Value { get set }
}

public enum EdgeKind: Hashable {
    case directed
    case undirected
}

public protocol Graph {
    associatedtype Element
    
    associatedtype VertexKind where VertexKind.Value == Element
    associatedtype EdgeKind: Edge where EdgeKind.VertexKind == VertexKind
    
    func new(vertex: Element) -> VertexKind
    func add(edge kind: EdgeKind, from source: VertexKind, to destination: VertexKind) -> EdgeKind
    func edges(from vertex: VertexKind) -> [EdgeKind]
}


// MARK: - Default Implementations

extension Vertex where Value: Hashable {
    public func hash(into: inout Hasher) {
        into.combine(self.value)
    }
}

extension Vertex where Value: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}
