//
//  Edge.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public struct ValueEdge<E: Edge, V>: Edge {
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
    public var value: V
    
    public init(wrapping: E, value: V) {
        self.wrapped = wrapping
        self.value = value
    }
}

extension ValueEdge: Equatable where E: Hashable & Equatable, V: Hashable & Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.wrapped == rhs.wrapped && lhs.value == rhs.value
    }
}

extension ValueEdge: Hashable where E: Hashable & Equatable, V: Hashable & Equatable {
    public func hash(into: inout Hasher) {
        self.wrapped.hash(into: &into)
        into.combine(self.value)
    }
}

extension ValueEdge: Weighted where V: BinaryFloatingPoint {
    public var weight: Double {
        get { Double(self.value) }
        set { self.value = V(newValue) }
    }
}
