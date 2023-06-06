import XCTest
@testable import Swease

final class SweaseTests: XCTestCase {
    var swease: Swease<Double>!
    let testValues: [Double] = [0, 0.25, 0.5, 0.75, 1]
    let accuracy = 0.05

    public override func setUp(){
        super.setUp()
        let inputRange: ClosedRange<Double> = 0.0...1.0
        let outputRange: ClosedRange<Double> = 0.0...10.0
        let easer = Swease(inputRange: inputRange, outputRange: outputRange)
        self.swease = easer
    }

    func testLinearSimple(){
        let outputs: [Double] = [0, 2.5, 5.0, 7.5, 10]
        for i in 0...testValues.count - 1 {
            let computed = swease.map(value: testValues[i], easing: .linear)
            XCTAssertEqual(computed, outputs[i], accuracy: accuracy)
        }
    }

    func testEaseInSimple(){
        let outputs: [Double] = [0, 0.156, 1.25, 4.219, 10]
        for i in 0...testValues.count - 1 {
            let computed = swease.map(value: testValues[i], easing: .easeIn)
            XCTAssertEqual(computed, outputs[i], accuracy: accuracy)
        }
    }

    func testEaseOut(){
        let outputs: [Double] = [0, 5.78, 8.75, 9.84, 10]
        for i in 0...testValues.count - 1 {
            let computed = swease.map(value: testValues[i], easing: .easeOut)
            XCTAssertEqual(computed, outputs[i], accuracy: accuracy)
        }
    }

    func testEaseInOut(){
        let outputs: [Double] = [0, 0.625, 5, 9.375, 10]
        for i in 0...testValues.count - 1 {
            let computed = swease.map(value: testValues[i], easing: .easeInOut)
            XCTAssertEqual(computed, outputs[i], accuracy: accuracy)
        }
    }

    func testOutOfBounds_lower() {
        let value = swease.map(value: -1, easing: .easeIn)
        XCTAssertEqual(value, swease.inputRange.lowerBound)
    }

    func testOutOfBounds_upper() {
        let value = swease.map(value: 2, easing: .easeIn)
        XCTAssertEqual(value, swease.inputRange.upperBound)
    }
}
