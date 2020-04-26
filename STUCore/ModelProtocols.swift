//
//  Entity.swift
//  STUCore
//
//  Created by John McAvey on 4/25/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation

public protocol Schema {
    var definition: URL { get }
    var keyMap: [String: String] { get }
}

public protocol Metadata {
    var schema: Schema { get }
    var values: [String:String] { get }
}

public protocol LookupTable {
    func value<T>(for key: String) -> T
}

public protocol Entity {
    var id: String { get }
    var elements: LookupTable { get }
}

public protocol Relationship {
    var source: Entity { get }
    var destination: Entity { get }
    var metadata: [String:String] { get }
}

public protocol KnowledgeGraph {
    func entities(matching: NSPredicate, sorted: [NSSortDescriptor]) -> [Entity]
    func relationships(on: Entity) -> [Relationship]
}
