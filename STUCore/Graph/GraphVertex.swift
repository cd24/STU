//
//  Vertex.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public struct GraphVertex<T: Hashable>: Vertex, Hashable, Equatable {
    public var value: T
    
    public init(value: T) {
        self.value = value
    }
}

public struct WeightedVertex<V: Vertex>: Vertex, Weighted {
    public typealias Value = V.Value
    private var wrapped: V
    public var value: Value {
        get { wrapped.value }
        set { wrapped.value = newValue }
    }
    public var weight: Double
    
    public init(wrapping: V, weight: Double) {
        self.wrapped = wrapping
        self.weight = weight
    }
}

extension WeightedVertex: Equatable where V: Hashable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.wrapped == rhs.wrapped && lhs.weight == rhs.weight
    }
}

extension WeightedVertex: Hashable where V: Hashable {
    public func hash(into: inout Hasher) {
        self.wrapped.hash(into: &into)
        into.combine(self.weight)
    }
}
