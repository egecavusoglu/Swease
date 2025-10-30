# Swease

Swease provides powerful, flexible value mapping and easing functions for Swift, commonly used for animations, UI interactions, and data transformation.

---

## Using `Swease.Range`

`Swease.Range` is a flexible struct for transforming values from an input range to an output range. It supports:

- **Clamping**: Restricting mapped values to the output range
- **Rubberbanding**: Allowing values beyond the input range with soft, non-linear boundaries
- **Easing**: Smoothing transitions with customizable curves

### 1. Creating a Swease Range

```swift
import Swease

let range = Swease.Range<Double>(range: 0.0...1.0)

