//
//  MemoryGraph.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public struct Nothing: Unit, Hashable {
    public static func empty() -> Nothing { return Nothing() }
}

public struct MemoryVertex<T: Hashable>: Vertex, Valued, Hashable, Equatable {
    public var value: T
    
    public init(value: T) {
        self.value = value
    }
}

public struct MemoryEdge<T: Hashable, Label>: Edge, Valued {
    public typealias VertexKind = MemoryVertex<T>
    public var source: MemoryVertex<T>
    public var destination: MemoryVertex<T>
    public var label: Label
    public var value: Label {
        get { self.label }
        set { self.label = newValue }
    }
    
    public init(source: MemoryVertex<T>, destination: MemoryVertex<T>, label: Label) {
        self.source = source
        self.destination = destination
        self.label = label
    }
}

extension MemoryEdge: Equatable where Label: Hashable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination && lhs.label == rhs.label
    }
}

extension MemoryEdge: Hashable where Label: Hashable {
    public func hash(into: inout Hasher) {
        into.combine(self.source)
        into.combine(self.destination)
        into.combine(self.value)
    }
}

public struct MemoryGraph<Element: Hashable, EdgeLabel: Hashable & Unit>: Graph {
    public typealias VertexKind = MemoryVertex<Element>
    public typealias EdgeType = MemoryEdge<Element, EdgeLabel>
    
    private var edgeSet: Set<MemoryEdge<Element, EdgeLabel>>
    private var vertexSet: Set<MemoryVertex<Element>>
    
    public var verticies: [MemoryVertex<Element>] {
        return Array(self.vertexSet)
    }
    
    public init() {
        self.edgeSet = []
        self.vertexSet = []
    }
    
    public mutating func new(vertex value: Element) -> MemoryVertex<Element> {
        let vertex = MemoryVertex(value: value)
        self.vertexSet.update(with: vertex)
        return vertex
    }
    
    public mutating func add(from source: MemoryVertex<Element>, to destination: MemoryVertex<Element>) -> MemoryEdge<Element, EdgeLabel> {
        let edge = MemoryEdge(source: source, destination: destination, label: EdgeLabel.empty())
        self.vertexSet.insert(source)
        self.vertexSet.insert(destination)
        self.edgeSet.update(with: edge)
        return edge
    }
    
    public mutating func add(from source: MemoryVertex<Element>, to destination: MemoryVertex<Element>, label: EdgeLabel) -> MemoryEdge<Element, EdgeLabel> {
        var edge = self.add(from: source, to: destination)
        self.edgeSet.remove(edge)
        edge.label = label
        self.edgeSet.update(with: edge)
        return edge
    }
    
    public func edges(from vertex: MemoryVertex<Element>) -> [MemoryEdge<Element, EdgeLabel>] {
        return self.edgeSet.filter { edge in
            edge.source == vertex || edge.destination == vertex
        }
    }
}
