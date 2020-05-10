//
//  DatabaseVertex.swift
//  STUCore
//
//  Created by John McAvey on 5/4/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public let databaseEncoder = JSONEncoder()
public let databaseDecoder = JSONDecoder()

public class StoredVertex<Value: Codable & Equatable>: Vertex, Hashable {
    var data: DatabaseValue
    
    public init(data: DatabaseValue) {
        self.data = data
    }
    
    public var value: Value {
        get {
            try! databaseDecoder.decode(Value.self, from: data.data)
        }
        set {
            data.data = try! databaseEncoder.encode(newValue)
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        self.data.hash(into: &hasher)
    }
}

public class StoredEdge<Label: Codable & Equatable, Element: Codable & Equatable, EdgeKind: DatabaseEdge>: Edge, Equatable {
    public static func == (lhs: StoredEdge<Label, Element, EdgeKind>, rhs: StoredEdge<Label, Element, EdgeKind>) -> Bool {
        return lhs.data == rhs.data
    }
    
    public typealias VertexKind = StoredVertex<Element>
    
    var data: EdgeKind
    
    public init(data: EdgeKind) {
        self.data = data
    }
    
    public lazy var source: StoredVertex<Element> = {
        StoredVertex(data: data.source)
    }()
    
    public lazy var destination: StoredVertex<Element> = {
        StoredVertex(data: data.destination)
    }()
    
    public var label: Label? {
        get {
            data.label.map { label in
                try! databaseDecoder.decode(Label.self, from: label.data)
            }
        }
        set {
            data.label?.data = try! databaseEncoder.encode(newValue)
        }
    }
}

extension StoredEdge: Hashable where EdgeKind: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.data)
    }
}

public class StoredGraph<Label: Codable & Equatable, Element: Codable & Equatable, Database: GraphDatabase>: Graph {
    public typealias Element = Element
    public typealias VertexKind = StoredVertex<Element>
    public typealias EdgeType = StoredEdge<Label, Element, Database.EdgeKind>
    
    public let database: Database
    
    public init(database: Database) {
        self.database = database
    }
    
    public var verticies: [StoredVertex<Element>] {
        self.database.values.map(StoredVertex.init)
    }
    
    public func new(vertex: Element) -> StoredVertex<Element> {
        if let vertex = self.existingVertex(value: vertex) {
            return vertex
        }
        var entry = database.newVertex()
        entry.identifier = UUID().uuidString
        entry.data = try! databaseEncoder.encode(vertex)
        try! self.database.commit()
        return StoredVertex(data: entry)
    }
    
    public func add(from source: StoredVertex<Element>, to destination: StoredVertex<Element>) -> StoredEdge<Label, Element, Database.EdgeKind> {
        if let edge = self.existingEdge(from: source, to: destination) {
            return edge
        }
        var edge = database.newEdge()
        edge.identifier = UUID().uuidString
        edge.source = source.data as! Database.ValueKind
        edge.destination = destination.data as! Database.ValueKind
        edge.label = nil
        try! self.database.commit()
        return StoredEdge(data: edge)
    }
    
    public func edges(from vertex: StoredVertex<Element>) -> [StoredEdge<Label, Element, Database.EdgeKind>] {
        self.database.edges(from: vertex.data as! Database.ValueKind).map(StoredEdge.init)
    }
    
    private func existingEdge(from source: StoredVertex<Element>, to destination: StoredVertex<Element>) -> StoredEdge<Label, Element, Database.EdgeKind>? {
        return self.edges(from: source).filter { [$0.source, $0.destination].set == [source, destination].set }.first
    }
    
    private func existingVertex(value: Element) -> StoredVertex<Element>? {
        return self.verticies.filter { $0.value == value }.first
    }
}
