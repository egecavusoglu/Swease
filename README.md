# Swease

This project aims to provide easing functions in swift in the simplest way possible.

Easing functions provide us to map an input range to an output range in various ways to create mathematical relations to use in our app. They are commonly used in visual animations and transitions.

> Easing functions specify the rate of change of a parameter over time. - easings.net

See [easings.net](https://easings.net/) for a more detailed look into specifics each easing function.

### How to use

1. Define an input and an output range.

```swift
let inputRange: ClosedRange<Double> = 0.0...1.0
let outputRange: ClosedRange<Double> = 0.0...10.0
``` 

2. Initialize Swease

```swift
let swease = Swease(inputRange: inputRange, outputRange: outputRange) 
```

3. Map values

```swift
swease.map(value: 0.5, easing: .ease_in) // = 1.25
```
