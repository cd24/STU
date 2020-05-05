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

public class StoredVertex<Value: Codable & Equatable>: Vertex {
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
}

public class StoredEdge<Label: Codable & Equatable, Element: Codable & Equatable, EdgeKind: DatabaseEdge>: Edge {
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
        var entry = database.newVertex()
        entry.identifier = UUID().uuidString
        entry.data = try! databaseEncoder.encode(vertex)
        try! self.database.commit()
        return StoredVertex(data: entry)
    }
    
    public func add(from source: StoredVertex<Element>, to destination: StoredVertex<Element>) -> StoredEdge<Label, Element, Database.EdgeKind> {
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
}
