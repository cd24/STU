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
        describe("Adding edges") {
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
