//
//  CacheGraph.swift
//  STUCore
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public class CacheGraph<Wrapped: Graph>: Graph where Wrapped.VertexKind: Hashable {
    public typealias Element = Wrapped.Element
    public typealias VertexKind = Wrapped.VertexKind
    public typealias EdgeType = Wrapped.EdgeType
    
    public private(set) var wrapped: Wrapped
    public var verticies: [Wrapped.VertexKind] { self.wrapped.verticies }
    private var fetchCache: [Wrapped.VertexKind: [Wrapped.EdgeType]]
    
    public init(wrapping: Wrapped) {
        self.wrapped = wrapping
        self.fetchCache = [:]
    }
    
    public func new(vertex: Wrapped.Element) -> Wrapped.VertexKind {
        return wrapped.new(vertex: vertex)
    }
    
    public func add(from source: Wrapped.VertexKind, to destination: Wrapped.VertexKind) -> Wrapped.EdgeType {
        self.invalidateCache(for: [source, destination])
        return wrapped.add(from: source, to: destination)
    }
    
    public func edges(from vertex: Wrapped.VertexKind) -> [Wrapped.EdgeType] {
        if let cachedValue = self.fetchCache[vertex] {
            return cachedValue
        }
        let edges = self.wrapped.edges(from: vertex)
        self.fetchCache[vertex] = edges
        return edges
    }
    
    func invalidateCache(for verticies: Set<VertexKind>) {
        fetchCache.remove(where: verticies.contains • Dictionary.key)
    }
}
