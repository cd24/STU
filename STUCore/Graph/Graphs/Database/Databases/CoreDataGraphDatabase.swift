//
//  CoreDataGraphDatabase.swift
//  STUCore
//
//  Created by John McAvey on 5/4/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation
import os.log
import CoreData

extension CoreDataValue: DatabaseValue {
    public var data: Data {
        get { self.cdData! }
        set { self.cdData = newValue }
    }
    
    public var identifier: String {
        get { self.cdIdentifier! }
        set { self.cdIdentifier = newValue }
    }
}

extension CoreDataEdge: DatabaseEdge {
    public typealias ValueKind = CoreDataValue
    
    public var identifier: String {
        get { self.cdIdentifier! }
        set { self.cdIdentifier = newValue }
    }
    
    public var source: CoreDataValue {
        get { self.cdSource! }
        set { self.cdSource = newValue }
    }
    
    public var destination: CoreDataValue {
        get { self.cdDestination! }
        set { self.cdDestination = newValue }
    }
    
    public var label: CoreDataValue? {
        get { self.cdLabel }
        set { self.cdLabel = newValue }
    }
}

public struct CoreDataUndirectedGraphDatabase: GraphDatabase {
    public typealias ValueKind = CoreDataValue
    public typealias EdgeKind = CoreDataEdge
    
    public var context: NSManagedObjectContext
    
    public var values: [CoreDataValue] {
        do {
            return try self.context.fetch(CoreDataValue.fetchRequest())
        } catch {
            os_log(.error, log: coreDataGraphLog, "Unable to fetch, error: %@", error.localizedDescription)
            return []
        }
    }
    
    public func newVertex() -> CoreDataValue {
        return NSEntityDescription.insertNewObject(forEntityName: "CoreDataValue", into: self.context) as! CoreDataValue
    }
    
    public func newEdge() -> CoreDataEdge {
        return NSEntityDescription.insertNewObject(forEntityName: "CoreDataEdge", into: self.context) as! CoreDataEdge
    }
    
    public func edges(from: CoreDataValue) -> [CoreDataEdge] {
        let fr: NSFetchRequest<CoreDataEdge> = CoreDataEdge.fetchRequest()
        fr.predicate = NSPredicate(format: "cdSource == %@ OR cdDestination == %@", from, from)
        do {
            return try self.context.fetch(fr)
        } catch {
            os_log(.error, log: coreDataGraphLog, "Unable to fetch, error: %@", error.localizedDescription)
            return []
        }
    }
    
    public func commit() throws {
        try self.context.save()
    }
    
    public static var model: NSManagedObjectModel {
        let model = NSManagedObjectModel()
        let entities = [
            CoreDataIdentifiableObject.entity(),
            CoreDataEdge.entity(),
            CoreDataValue.entity(),
        ]
        model.entities = entities
        model.setEntities(entities, forConfigurationName: "GraphConfiguration")
        model.versionIdentifiers = ["1.0"]
        return model
    }
}
