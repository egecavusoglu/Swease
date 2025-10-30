//
//  Range.swift
//  Swease
//
//  Created by Ege Çavuşoğlu on 10/29/25.
//

import Foundation

/// Used for namespacing
enum Swease {}

/// Sweasable refers to any type that is compatible with Swease operations.
public typealias Sweaseable = Comparable & BinaryFloatingPoint

extension Swease {
  struct Range<T: Sweaseable> {

    private(set) var inputRange: ClosedRange<T>
    private(set) var outputRange: ClosedRange<T>
    private(set) var rubberbandingCoefficient: T
    private(set) var easing: Easing = .linear

    // MARK: - Init

    public init(range: ClosedRange<T>) {
      self.init(inputRange: range, outputRange: range, rubberbandingCoefficient: 0, easing: .linear)
    }

    private init(inputRange: ClosedRange<T>, outputRange: ClosedRange<T>, rubberbandingCoefficient: T, easing: Easing) {
      self.inputRange = inputRange
      self.outputRange = outputRange
      self.rubberbandingCoefficient = rubberbandingCoefficient
      self.easing = easing
    }

    public func clamped(to outputRange: ClosedRange<T>) -> Range {
      Range(inputRange: inputRange, outputRange: outputRange, rubberbandingCoefficient: rubberbandingCoefficient, easing: easing)
    }

    public func rubberbands(using coefficient: T) -> Range {
      Range(inputRange: inputRange, outputRange: outputRange, rubberbandingCoefficient: coefficient, easing: easing)
    }

    public func easing(_ easing: Easing) -> Range {
      Range(inputRange: inputRange, outputRange: outputRange, rubberbandingCoefficient: rubberbandingCoefficient, easing: easing)
    }

    // MARK: - Public

    public func interpolate(_ value: T) -> T {
      let clampedValue: T
      if value < inputRange.lowerBound {
        if rubberbandingCoefficient == 0 {
          clampedValue = inputRange.lowerBound
        } else {
          let delta = Double(inputRange.lowerBound - value)
          let rubber = Double(inputRange.lowerBound) - Double(rubberbandingCoefficient) * log(1 + delta / Double(rubberbandingCoefficient))
          clampedValue = T(rubber)
        }
      } else if value > inputRange.upperBound {
        if rubberbandingCoefficient == 0 {
          clampedValue = inputRange.upperBound
        } else {
          let delta = Double(value - inputRange.upperBound)
          let rubber = Double(inputRange.upperBound) + Double(rubberbandingCoefficient) * log(1 + delta / Double(rubberbandingCoefficient))
          clampedValue = T(rubber)
        }
      } else {
        clampedValue = value
      }

      switch easing {
      case .linear:
        return linearMap(value: clampedValue)
      case .easeIn:
        return easeInMap(value: clampedValue)
      case .easeOut:
        return easeOutMap(value: clampedValue)
      case .easeInOut:
        return easeInOutMap(value: clampedValue)
      }
    }

    // MARK: - Interpolation Helpers

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

    private func delta() -> (T, T) {
      let inputDelta = inputRange.upperBound - inputRange.lowerBound
      let outputDelta = outputRange.upperBound - outputRange.lowerBound
      return (inputDelta, outputDelta)
    }
  }

}
