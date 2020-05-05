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
            it("can or two keypaths") {
                let fn: (KeyPathSampleObject) -> Bool = \.valueOne.description ||| \.valueTwo == "1"
                expect(fn(KeyPathSampleObject(valueOne: 1, valueTwo: "2"))).to(beTrue())
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "1"))).to(beTrue())
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "2"))).to(beFalse())
            }
        }
        describe("ands") {
            it("can and two keypaths") {
                let fn: (KeyPathSampleObject) -> Bool = \.valueOne.description &&& \.valueTwo == "1"
                expect(fn(KeyPathSampleObject(valueOne: 1, valueTwo: "2"))).to(beFalse())
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "1"))).to(beFalse())
                expect(fn(KeyPathSampleObject(valueOne: 2, valueTwo: "2"))).to(beFalse())
                expect(fn(KeyPathSampleObject(valueOne: 1, valueTwo: "1"))).to(beTrue())
            }
        }
    }
}
