//
//  CacheGraphSpec.swift
//  STUCoreTests
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import STUCore

public class CacheGraphSpec: QuickSpec {
    var graph: CacheGraph<MemoryUndirectedGraph<String, String>> = CacheGraph(wrapping: MemoryUndirectedGraph())
    public override func spec() {
        beforeEach {
            self.graph = CacheGraph(wrapping: MemoryUndirectedGraph())
        }
        itBehavesLike(AGraph.self) { self.graph }
    }
}
