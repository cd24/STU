//
//  MemoryUndirectedGraph.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public struct Nothing: Unit, Hashable {
    public static func empty() -> Nothing { return Nothing() }
}

public struct MemoryUndirectedVertex<T: Hashable>: Vertex, Valued, Hashable, Equatable {
    public var value: T
    
    public init(value: T) {
        self.value = value
    }
}

public struct MemoryUndirectedEdge<T: Hashable, Label>: Edge, Valued {
    public typealias VertexKind = MemoryUndirectedVertex<T>
    public var source: MemoryUndirectedVertex<T>
    public var destination: MemoryUndirectedVertex<T>
    public var label: Label
    public var value: Label {
        get { self.label }
        set { self.label = newValue }
    }
    
    public init(source: MemoryUndirectedVertex<T>, destination: MemoryUndirectedVertex<T>, label: Label) {
        self.source = source
        self.destination = destination
        self.label = label
    }
}

extension MemoryUndirectedEdge: Equatable where Label: Hashable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination && lhs.label == rhs.label
    }
}

extension MemoryUndirectedEdge: Hashable where Label: Hashable {
    public func hash(into: inout Hasher) {
        into.combine(self.source)
        into.combine(self.destination)
        into.combine(self.value)
    }
}

public struct MemoryUndirectedGraph<Element: Hashable, EdgeLabel: Hashable & Unit>: Graph {
    public typealias VertexKind = MemoryUndirectedVertex<Element>
    public typealias EdgeType = MemoryUndirectedEdge<Element, EdgeLabel>
    
    private var edgeSet: Set<MemoryUndirectedEdge<Element, EdgeLabel>>
    private var vertexSet: Set<MemoryUndirectedVertex<Element>>
    
    public var verticies: [MemoryUndirectedVertex<Element>] {
        return Array(self.vertexSet)
    }
    
    public init() {
        self.edgeSet = []
        self.vertexSet = []
    }
    
    public mutating func new(vertex value: Element) -> MemoryUndirectedVertex<Element> {
        let vertex = MemoryUndirectedVertex(value: value)
        self.vertexSet.update(with: vertex)
        return vertex
    }
    
    public mutating func add(from source: MemoryUndirectedVertex<Element>, to destination: MemoryUndirectedVertex<Element>) -> MemoryUndirectedEdge<Element, EdgeLabel> {
        let edge = MemoryUndirectedEdge(source: source, destination: destination, label: EdgeLabel.empty())
        self.vertexSet.insert(source)
        self.vertexSet.insert(destination)
        self.edgeSet.update(with: edge)
        return edge
    }
    
    public mutating func add(from source: MemoryUndirectedVertex<Element>, to destination: MemoryUndirectedVertex<Element>, label: EdgeLabel) -> MemoryUndirectedEdge<Element, EdgeLabel> {
        var edge = self.add(from: source, to: destination)
        self.edgeSet.remove(edge)
        edge.label = label
        self.edgeSet.update(with: edge)
        return edge
    }
    
    public func edges(from vertex: MemoryUndirectedVertex<Element>) -> [MemoryUndirectedEdge<Element, EdgeLabel>] {
        edgeSet.filter(\.source ||| \.destination == vertex)
    }
}
