//
//  KeyPathEqualitySpec.swift
//  STUCoreTests
//
//  Created by John McAvey on 4/26/20.
//  Copyright © 2020 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
import STUCore

public struct KeyPathSampleObject {
    public let valueOne: Int
    public let valueTwo: String
}

public class KeyPathEqualitySpec: QuickSpec {
    public override func spec() {
        describe("ors") {
            let fn: (KeyPathSampleObject) -> Bool = \.valueOne.description ||| \.valueTwo == "1"
            it("satisfies when the first value matches") {
                expect(fn(KeyPathSampleObject(valueOne: 1, valueTwo: "2"))).to(beTrue())
            }
            it("satisfies when the second value matches") {
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "1"))).to(beTrue())
            }
            it("satisfies when both values match") {
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "2"))).to(beFalse())
            }
        }
        describe("ands") {
            let fn: (KeyPathSampleObject) -> Bool = \.valueOne.description &&& \.valueTwo == "1"
            it("fails when the second value fails") {
                expect(fn(KeyPathSampleObject(valueOne: 1, valueTwo: "2"))).to(beFalse())
            }
            it("fails when the first value fails") {
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "1"))).to(beFalse())
            }
            it("fails when both values fail") {
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "2"))).to(beFalse())
            }
            it("passes when both values pass") {
                expect(fn(KeyPathSampleObject(valueOne: 1, valueTwo: "1"))).to(beTrue())
            }
        }
    }
}
