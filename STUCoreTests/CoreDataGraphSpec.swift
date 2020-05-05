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
    
    var graph: StoredGraph<String, String, CoreDataUndirectedGraphDatabase> {
        StoredGraph(database: CoreDataUndirectedGraphDatabase(context: self.testContainer.viewContext))
    }
    
    public func all<T: NSManagedObject>(name: String) -> [T] {
        let fetch = NSFetchRequest<T>(entityName: name)
        return try! testContainer.viewContext.fetch(fetch)
    }
    
    public func values() -> [CoreDataValue] { self.all(name: "CoreDataValue") }
    public func edges() -> [CoreDataEdge] { self.all(name: "CoreDataEdge") }
    
    public override func spec() {
        beforeEach {
            for value in self.values() {
                self.testContainer.viewContext.delete(value)
            }
            for edge in self.edges() {
                self.testContainer.viewContext.delete(edge)
            }
        }
        describe("Vertexs") {
            it("adds new vertexs to the data model") {
                let vertex = self.graph.new(vertex: "first")
                let dataObjects = self.values()
                expect(dataObjects.count).to(equal(1))
                expect(dataObjects.first?.data).to(equal(vertex.data.data))
                expect(dataObjects.first?.identifier).to(equal(vertex.data.identifier))
            }
            it("doesn't impose uniqueness constaints") {
                _ = self.graph.new(vertex: "first")
                _ = self.graph.new(vertex: "first")
                expect(self.values().count).to(equal(2))
            }
        }
        describe("Edges") {
            var v1: StoredVertex<String>? = nil
            var v2: StoredVertex<String>? = nil
            beforeEach {
                v1 = self.graph.new(vertex: "first")
                v2 = self.graph.new(vertex: "second")
            }
            it("constructs an edge in the database") {
                let edge = self.graph.add(from: v1!, to: v2!)
                expect(self.edges().count).to(equal(1))
                expect(self.edges().first).to(equal(edge.data))
                expect(edge.source.data.identifier).to(equal(v1!.data.identifier))
                expect(edge.destination.data.identifier).to(equal(v2!.data.identifier))
            }
            it("Looks up edges") {
                let edge = self.graph.add(from: v1!, to: v2!)
                let foundEdges = self.graph.edges(from: v1!)
                expect(foundEdges.map { $0.data.identifier }).to(contain(edge.data.identifier))
            }
        }
    }
}
