// Easing functions and mathematical formulas adopted from https://easings.net/

import Foundation

/** Sweasable refers to any type that is compatible with Swease operations */
public typealias Sweaseable = Comparable & BinaryFloatingPoint

public class Swease<T: Sweaseable> {
    /** Input range refers is the range your input will be in. */
    var inputRange: ClosedRange<T>
    /** Output range refers is the range of the result. */
    var outputRange: ClosedRange<T>

    public init(inputRange: ClosedRange<T>, outputRange: ClosedRange<T>) {
        self.inputRange = inputRange
        self.outputRange = outputRange
    }

    /** Maps the @param value to an output based on the @param easing. */
    public func map(value: T, easing: Easing) -> T{
        if (value < inputRange.lowerBound){
            return outputRange.lowerBound
        }
        if (value > inputRange.upperBound){
            return outputRange.upperBound
        }
        // Performs the map based on the easing type.
        switch easing {
        case .linear:
            return linearMap(value: value)
        case .easeIn:
            return easeInMap(value: value)
        case .easeOut:
            return easeOutMap(value: value)
        case .easeInOut:
            return easeInOutMap(value: value)
        }
    }

    private func linearMap(value: T) -> T{
        let (inputDelta, outputDelta) = delta()
        return outputRange.lowerBound + value / inputDelta * outputDelta
    }

    private func easeInMap(value: T) -> T {
        let (inputDelta, outputDelta) = delta()
        let unitVector: Double = Double(value / inputDelta)
        let easeInUnitVector = pow(unitVector, 3)
        return outputRange.lowerBound + T(easeInUnitVector) * outputDelta
    }

    private func easeOutMap(value: T) -> T {
        let (inputDelta, outputDelta) = delta()
        let unitVector: Double = Double(value / inputDelta)
        let easeOutUnitVector = 1 - pow(1.0 - unitVector, 3)
        return outputRange.lowerBound + T(easeOutUnitVector) * outputDelta
    }

    private func easeInOutMap(value: T) -> T {
        let (inputDelta, outputDelta) = delta()
        let unitVector: Double = Double(value / inputDelta)
        let easeInOutUnitVector = unitVector < 0.5 ? 4 * pow(unitVector, 3): 1 - pow(-2.0 * unitVector + 2, 3) / 2
        return outputRange.lowerBound + T(easeInOutUnitVector) * outputDelta
    }

    /** Calculates the delta of the input and output ranges. */
    private func delta() -> (T, T) {
        let inputDelta = inputRange.upperBound - inputRange.lowerBound
        let outputDelta = outputRange.upperBound - outputRange.lowerBound
        return (inputDelta, outputDelta)
    }

}
