//
//  GraphBehavior.swift
//  STUCoreTests
//
//  Created by John McAvey on 5/10/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import STUCore

class AGraph<GraphKind: Graph>: Behavior<GraphKind> where GraphKind.EdgeType: Hashable, GraphKind.VertexKind: Hashable, GraphKind.Element == String {
    override class func spec(_ aContext: @escaping () -> GraphKind) {
        var graph: GraphKind!
        beforeEach { graph = aContext() }
        
        describe("Vertexs") {
            it("adds a single vertex") {
                expect(graph.new(vertex: "Hello").value).to(equal("Hello"))
                expect(graph.verticies.count).to(equal(1))
            }
            it("adds new vertexs to the data model") {
                let vertex = graph.new(vertex: "first")
                let dataObjects = graph.verticies
                expect(dataObjects.count).to(equal(1))
                expect(dataObjects.first).to(equal(vertex))
                expect(dataObjects.first).to(equal(vertex))
            }
            it("imposes uniqueness constaints") {
                _ = graph.new(vertex: "first")
                _ = graph.new(vertex: "first")
                expect(graph.verticies.count).to(equal(1))
            }
        }
        describe("Edges") {
            var v1: GraphKind.VertexKind!
            var v2: GraphKind.VertexKind!
            beforeEach {
                v1 = graph.new(vertex: "first")
                v2 = graph.new(vertex: "second")
            }
            it("constructs an edge") {
                let edge = graph.add(from: v1, to: v2)
                expect(graph.edges.count).to(equal(1))
                expect(graph.edges.first).to(equal(edge))
                expect(edge.source).to(equal(v1))
                expect(edge.destination).to(equal(v2))
            }
            it("Looks up single edges") {
                let edge = graph.add(from: v1, to: v2)
                let foundEdges = graph.edges(from: v1)
                expect(foundEdges).to(contain(edge))
            }
            it("Looks up multiple edges") {
                let v3 = graph.new(vertex: "Third")
                let edge = graph.add(from: v1!, to: v2!)
                let edge2 = graph.add(from: v1!, to: v3)
                let foundEdges = graph.edges(from: v1!)
                expect(foundEdges.set).to(equal([edge, edge2]))
            }
            it("Adds when vertecies exist in the graph") {
                let v1 = graph.new(vertex: "fst")
                let v2 = graph.new(vertex: "snd")
                let edge = graph.add(from: v1, to: v2)
                expect(graph.verticies).to(contain([v1, v2]))
                expect(graph.edges(from: v1)).to(equal([edge]))
                expect(edge.source).to(equal(v1))
                expect(edge.destination).to(equal(v2))
            }
            it("Only adds unique edges") {
                let v1 = graph.new(vertex: "fst")
                let v2 = graph.new(vertex: "snd")
                let edge = graph.add(from: v1, to: v2)
                let edge2 = graph.add(from: v1, to: v2)
                expect(edge).to(equal(edge2))
                expect(edge.source).to(equal(v1))
                expect(edge.destination).to(equal(v2))
                expect(graph.edges(from: v1)).to(equal([edge]))
            }
            it("Adds non-overlapping edges") {
                let verticies = ["fst", "snd", "thd", "fth"].map() { value in graph.new(vertex: value) }
                _ = [
                    graph.add(from: verticies[0], to: verticies[2]),
                    graph.add(from: verticies[2], to: verticies[3]),
                    graph.add(from: verticies[0], to: verticies[3])
                ]
                expect(graph.edges(from: verticies[0]).count).to(equal(2))
                expect(graph.edges(from: verticies[1])).to(equal([]))
                let edges = graph.edges(from: verticies[2]).set
                expect(edges.count).to(equal(2))
                expect([verticies[0], verticies[2]]).to(contain(edges.first?.source))
                expect(edges.flatMap { [$0.destination, $0.source] }.set).to(contain([verticies[0], verticies[3]]))
            }
        }
    }
}
