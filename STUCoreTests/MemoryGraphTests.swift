//
//  MemoryGraphTests.swift
//  STUCoreTests
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import STUCore

public class MemoryGraphSpec: QuickSpec {
    var graph: MemoryGraph<Int, String> = MemoryGraph()
    
    public override func spec() {
        beforeEach {
            self.graph = MemoryGraph<Int, String>()
        }
        describe("Adding verticies") {
            it("adds a single vertex") {
                expect(self.graph.new(vertex: 2)).to(equal(MemoryVertex(value: 2)))
                expect(self.graph.verticies).to(equal([MemoryVertex(value: 2)]))
            }
            it("adds multiple verticies") {
                let values = [1, 2, 3, 4, 5]
                var expected = Set<MemoryVertex<Int>>()
                values.forEach { value in
                    let answer = MemoryVertex(value: value)
                    expected.insert(answer)
                    expect(self.graph.new(vertex: value)).to(equal(answer))
                    expect(self.graph.verticies.set).to(equal(expected))
                }
            }
        }
        describe("Adding edges") {
            it("Adds when vertecies exist in the graph") {
                let v1 = self.graph.new(vertex: 1)
                let v2 = self.graph.new(vertex: 2)
                let edge = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(MemoryEdge(source: v1, destination: v2, label: String.empty())))
                expect(self.graph.edges(from: v1)).to(equal([edge]))
            }
            it("Adds the edge and missing vertex") {
                let v1 = MemoryVertex(value: 1)
                let v2 = self.graph.new(vertex: 2)
                let edge = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(MemoryEdge(source: v1, destination: v2, label: String.empty())))
                expect(self.graph.edges(from: v1)).to(equal([edge]))
                expect(self.graph.verticies.set).to(equal([v1, v2]))
            }
            it("Adds all missing verticies") {
                let v1 = MemoryVertex(value: 1)
                let v2 = MemoryVertex(value: 2)
                let edge = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(MemoryEdge(source: v1, destination: v2, label: String.empty())))
                expect(self.graph.edges(from: v1)).to(equal([edge]))
                expect(self.graph.verticies.set).to(equal([v1, v2]))
            }
            it("Only adds unique edges") {
                let v1 = MemoryVertex(value: 1)
                let v2 = MemoryVertex(value: 2)
                let edge = self.graph.add(from: v1, to: v2)
                let edge2 = self.graph.add(from: v1, to: v2)
                expect(edge).to(equal(edge2))
                expect(edge).to(equal(MemoryEdge(source: v1, destination: v2, label: String.empty())))
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
                    MemoryEdge(source: verticies[0], destination: verticies[2], label: String.empty()),
                    MemoryEdge(source: verticies[0], destination: verticies[3], label: String.empty()),
                ]))
                expect(self.graph.edges(from: verticies[1])).to(equal([]))
                expect(self.graph.edges(from: verticies[2]).set).to(equal([
                    MemoryEdge(source: verticies[2], destination: verticies[3], label: String.empty()),
                    MemoryEdge(source: verticies[0], destination: verticies[2], label: String.empty())
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