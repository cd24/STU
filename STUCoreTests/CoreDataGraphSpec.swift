//
//  CoreDataGraphTests.swift
//  STUCoreTests
//
//  Created by John McAvey on 5/4/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData
@testable import STUCore

public class CoreDataGraphSpec: QuickSpec {
    lazy var testContainer: NSPersistentContainer = {
        let bundle = Bundle(for: CoreDataValue.self).url(forResource: "Graph", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: bundle)!
        let container = NSPersistentContainer(name: "Graph", managedObjectModel: model)
        let exp = XCTestExpectation()
        exp.expectedFulfillmentCount = 1
        container.loadPersistentStores { (description, error) in
            // Check if creating container wrong
            if let error = error {
                fatalError("\(error)")
            }
            exp.fulfill()
        }
        self.wait(for: [exp], timeout: 10)
        return container
    }()
    
    lazy var graph: StoredGraph<String, String, CoreDataUndirectedGraphDatabase> = {
        StoredGraph(database: CoreDataUndirectedGraphDatabase(context: self.testContainer.viewContext))
    }()
    
    public func all<T: NSManagedObject>(name: String) -> [T] {
        let fetch = NSFetchRequest<T>(entityName: name)
        return try! testContainer.viewContext.fetch(fetch)
    }
    
    public func values() -> [CoreDataValue] { self.all(name: "CoreDataValue") }
    public func edges() -> [CoreDataEdge] { self.all(name: "CoreDataEdge") }
    public func resetDatabase() {
        for value in self.values() {
            self.testContainer.viewContext.delete(value)
        }
        for edge in self.edges() {
            self.testContainer.viewContext.delete(edge)
        }
    }
    
    public override func spec() {
        beforeEach { self.resetDatabase() }
        itBehavesLike(AGraph.self) { self.graph }
    }
}
