//
//  Edge.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public struct GraphEdge<T: Hashable>: Edge {
    public typealias VertexKind = GraphVertex<T>
    public var source: GraphVertex<T>
    public var destination: GraphVertex<T>
    
    public init(source: GraphVertex<T>, destination: GraphVertex<T>) {
        self.source = source
        self.destination = destination
    }
}

public struct WeightedEdge<E: Edge>: Edge, Weighted {
    public typealias VertexKind = E.VertexKind
    
    private var wrapped: E
    public var source: VertexKind {
        get { wrapped.source }
        set { wrapped.source = newValue }
    }
    public var destination: VertexKind {
        get { wrapped.destination }
        set { wrapped.destination = newValue }
    }
    public var weight: Double
    
    public init(wrapping: E, weight: Double) {
        self.wrapped = wrapping
        self.weight = weight
    }
}

extension GraphEdge: Hashable {
    public func hash(into: inout Hasher) {
        into.combine(self.source)
        into.combine(self.destination)
    }
}

extension WeightedEdge: Equatable where E: Hashable & Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.wrapped == rhs.wrapped && lhs.weight == rhs.weight
    }
}

extension WeightedEdge: Hashable where E: Hashable & Equatable {
    public func hash(into: inout Hasher) {
        self.wrapped.hash(into: &into)
        into.combine(self.weight)
    }
}
