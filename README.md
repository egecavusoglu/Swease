# Swease

**Swease** is a lightweight Swift package that provides flexible **range interpolation**, **rubberbanding**, and **easing** functionality for floating-point values.

It’s designed to make it easy to map values between ranges, optionally apply easing curves (linear, ease-in, ease-out, ease-in-out), and simulate **rubberbanding behavior** similar to what you see in iOS scrolling or spring-like UI interactions.

---

## 🌟 Features

- 🧭 **Range Mapping** — Easily map a value from one numeric range to another.  
- 🎚️ **Easing Functions** — Apply smooth, non-linear transitions with `.easeIn`, `.easeOut`, and `.easeInOut`.  
- 🪀 **Rubberbanding** — Extend range boundaries naturally for values that exceed the input range (with logarithmic elasticity).  
- 🧱 **Fluent API** — Chain configurations in a builder-style manner for clarity and immutability.  
- 🧩 **Type-Safe** — Works with any `Comparable & BinaryFloatingPoint` type (e.g. `Double`, `Float`, `CGFloat`).  

---

## 📦 Installation

Add the following to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/egecavusoglu/Swease.git", from: "1.0.0")
```

Then import Swease where you need it:

```swift
import Swease
```

---

## 🧠 Concept

At the core, `Swease.Range` lets you map an input value within one range to an output range:

```
input:   0 -------------------- 100
output:  0 -------------------- 1
value: 75  →  maps to  0.75
```

This can be extended with **rubberbanding** for values that exceed the input range and **easing** functions for smooth transitions.

---

## ⚙️ Basic Usage

### 1. Simple Linear Mapping

```swift
let range = Swease.Range(range: 0.0...100.0)
let output = range.interpolate(25.0) // 25.0 (same range)
```

### 2. Mapping Between Two Ranges

```swift
let range = Swease.Range<Double>(range: 0...100)
  .clamped(to: 0...1)

let output = range.interpolate(50) // 0.5
```

---

## 🧲 Rubberbanding Example

Rubberbanding allows values outside the range to be handled smoothly (instead of clamping hard).

```swift
let rubberRange = Swease.Range<Double>(range: 0...100)
  .clamped(to: 0...1)
  .rubberbands(using: 10)

rubberRange.interpolate(120) // > 1.0, softly stretched
rubberRange.interpolate(-20) // < 0.0, softly pulled
```

Rubberbanding is logarithmic: the further you go beyond the limits, the less movement you get.  
A smaller coefficient increases stiffness; a larger coefficient makes it more elastic.

| Coefficient | Effect |
|--------------|---------|
| `0` | No rubberbanding (hard clamp) |
| `10` | Moderate elasticity |
| `50` | Very soft, elastic feel |

---

## 🎢 Easing Functions

Swease supports four built-in easing curves for interpolation:

| Easing | Description |
|--------|--------------|
| `.linear` | Constant rate of change |
| `.easeIn` | Starts slow, accelerates |
| `.easeOut` | Starts fast, slows down |
| `.easeInOut` | Smooth acceleration and deceleration |

```swift
let easedRange = Swease.Range<Double>(range: 0...100)
  .clamped(to: 0...1)
  .easing(.easeInOut)

easedRange.interpolate(50) // 0.5 (center point)
easedRange.interpolate(25) // < 0.25 (slower start)
easedRange.interpolate(75) // > 0.75 (slower end)
```

---

## 🧩 Full Example

Here’s how you can combine all capabilities:

```swift
let scrollRange = Swease.Range<Double>(range: 0...300)
  .clamped(to: 0...1)
  .rubberbands(using: 20)
  .easing(.easeOut)

for position in stride(from: -50.0, through: 350.0, by: 50.0) {
  let mapped = scrollRange.interpolate(position)
  print(String(format: "Input: %.1f → Output: %.3f", position, mapped))
}
```

**Output (example):**
```
Input: -50.0 → Output: -0.066
Input: 0.0   → Output: 0.000
Input: 50.0  → Output: 0.166
Input: 100.0 → Output: 0.333
Input: 150.0 → Output: 0.500
Input: 200.0 → Output: 0.666
Input: 250.0 → Output: 0.833
Input: 300.0 → Output: 1.000
Input: 350.0 → Output: 1.066
```

---

## 🧮 How It Works

1. **Clamping:**  
   Ensures input values stay within the specified input range.  

2. **Rubberbanding (Optional):**  
   For out-of-range values, a logarithmic function models elastic resistance.  

3. **Easing (Optional):**  
   Once mapped to a normalized 0–1 space, an easing curve reshapes the interpolation progress.  

4. **Output Mapping:**  
   The eased or clamped result is scaled to the output range.

---
