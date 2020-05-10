//
//  MemoryUndirectedGraphTests.swift
//  STUCoreTests
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import STUCore

public class MemoryUndirectedGraphSpec: QuickSpec {
    var graph: MemoryUndirectedGraph<Int, String> = MemoryUndirectedGraph()
    
    public override func spec() {
        beforeEach {
            self.graph = MemoryUndirectedGraph<Int, String>()
        }
        
        itBehavesLike(AGraph.self) { MemoryUndirectedGraph<String, String>() }
        describe("Adding verticies") {
            it("adds a single vertex") {
                expect(self.graph.new(vertex: 2)).to(equal(MemoryUndirectedVertex(value: 2)))
                expect(self.graph.verticies).to(equal([MemoryUndirectedVertex(value: 2)]))
            }
            it("adds multiple verticies") {
                let values = [1, 2, 3, 4, 5]
                values.forEach { value in
                    _ = self.graph.new(vertex: value)
                }
                expect(self.graph.verticies.map { $0.value }.set).to(equal(values.set))
            }
        }
        describe("Adding edges") {
            it("Adds when vertecies exist in the graph") {
                let v1 = self.graph.new(vertex: 1)
                let v2 = self.graph.new(vertex: 2)
                let edge = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(MemoryUndirectedEdge(source: v1, destination: v2, label: String.empty())))
                expect(self.graph.edges(from: v1)).to(equal([edge]))
            }
            it("Adds the edge and missing vertex") {
                let v1 = MemoryUndirectedVertex(value: 1)
                let v2 = self.graph.new(vertex: 2)
                let edge = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(MemoryUndirectedEdge(source: v1, destination: v2, label: String.empty())))
                expect(self.graph.edges(from: v1)).to(equal([edge]))
                expect(self.graph.verticies.set).to(equal([v1, v2]))
            }
            it("Adds all missing verticies") {
                let v1 = MemoryUndirectedVertex(value: 1)
                let v2 = MemoryUndirectedVertex(value: 2)
                let edge = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(MemoryUndirectedEdge(source: v1, destination: v2, label: String.empty())))
                expect(self.graph.edges(from: v1)).to(equal([edge]))
                expect(self.graph.verticies.set).to(equal([v1, v2]))
            }
            it("Only adds unique edges") {
                let v1 = MemoryUndirectedVertex(value: 1)
                let v2 = MemoryUndirectedVertex(value: 2)
                let edge = self.graph.add(from: v1, to: v2)
                let edge2 = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(edge2))
                expect(edge).to(equal(MemoryUndirectedEdge(source: v1, destination: v2, label: String.empty())))
                expect(self.graph.edges(from: v1)).to(equal([edge]))
            }
            it("Adds non-overlapping edges") {
                let verticies = [1, 2, 3, 4].map() { value in self.graph.new(vertex: value) }
                _ = [
                    self.graph.add(from: verticies[0], to: verticies[2]),
                    self.graph.add(from: verticies[2], to: verticies[3]),
                    self.graph.add(from: verticies[0], to: verticies[3])
                ]
                expect(self.graph.verticies.set).to(equal(verticies.set))
                expect(self.graph.edges(from: verticies[0]).set).to(equal([
                    MemoryUndirectedEdge(source: verticies[0], destination: verticies[2], label: String.empty()),
                    MemoryUndirectedEdge(source: verticies[0], destination: verticies[3], label: String.empty()),
                ]))
                expect(self.graph.edges(from: verticies[1])).to(equal([]))
                expect(self.graph.edges(from: verticies[2]).set).to(equal([
                    MemoryUndirectedEdge(source: verticies[2], destination: verticies[3], label: String.empty()),
                    MemoryUndirectedEdge(source: verticies[0], destination: verticies[2], label: String.empty())
                ]))
            }
            it("Preserves labels") {
                let (v1, v2) = (self.graph.new(vertex: 2), self.graph.new(vertex: 3))
                _ = self.graph.add(from: v1, to: v2, label: "Some Label")
                let edges = self.graph.edges(from: v1)
                expect(edges).toNot((beEmpty()))
                expect(edges.first?.label).to(equal("Some Label"))
            }
        }
    }
}
