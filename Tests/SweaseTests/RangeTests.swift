//
//  RangeTests.swift
//  Swease
//
//  Created by Ege Çavuşoğlu on 10/29/25.
//

import XCTest
@testable import Swease


final class RangeTests: XCTestCase {

  let testValues: [Double] = [0, 0.25, 0.5, 0.75, 1]
  let accuracy = 0.01

  //MARK: - Easing tests

  func testLinearEasing() {
    let range = Swease.Range<Double>(range: 0...1).clamped(to: 0...10).easing(.linear)
    let outputs: [Double] = [0, 2.5, 5.0, 7.5, 10]
    for (index, value) in testValues.enumerated() {
      XCTAssertEqual(range.interpolate(value), outputs[index], accuracy: accuracy)
    }
  }

  func testEaseInEasing() {
    let range = Swease.Range<Double>(range: 0...1).clamped(to: 0...10).easing(.easeIn)
    let outputs = [0, 0.156, 1.25, 4.219, 10]
    for (index, value) in testValues.enumerated() {
      XCTAssertEqual(range.interpolate(value), outputs[index], accuracy: accuracy)
    }
  }

  func testEaseOutEasing() {
    let range = Swease.Range<Double>(range: 0...1).clamped(to: 0...10).easing(.easeOut)
    let outputs: [Double] = [0, 5.78, 8.75, 9.84, 10]
    for (index, value) in testValues.enumerated() {
      XCTAssertEqual(range.interpolate(value), outputs[index], accuracy: accuracy)
    }
  }

  func testEaseInOutEasing() {
    let range = Swease.Range<Double>(range: 0...1).clamped(to: 0...10).easing(.easeInOut)
    let outputs: [Double] = [0, 0.625, 5, 9.375, 10]
    for (index, value) in testValues.enumerated() {
      XCTAssertEqual(range.interpolate(value), outputs[index], accuracy: accuracy)
    }
  }

  func testClampingBehavior() {
    let range = Swease.Range<Double>(range: 0...1).clamped(to: 0...10).rubberbands(using: 0.0)
    XCTAssertEqual(range.interpolate(-1.0), 0.0, accuracy: 1e-9)
    XCTAssertEqual(range.interpolate(2.0), 10.0, accuracy: 1e-9)
  }

  func testRubberbandingBehavior() {
    let range = Swease.Range<Double>(range: 0...1).clamped(to: 0...10).rubberbands(using: 0.4)
    let below = range.interpolate(-1.0)
    let above = range.interpolate(2.0)
    XCTAssert(below < 0.0) // Should rubberband below
    XCTAssert(above > 10.0) // Should rubberband above
  }

  func testCustomOutputRange() {
    let range = Swease.Range<Double>(range: 0...1).clamped(to: 5...15)
    XCTAssertEqual(range.interpolate(0.0), 5.0, accuracy: 1e-9)
    XCTAssertEqual(range.interpolate(1.0), 15.0, accuracy: 1e-9)
  }
}
