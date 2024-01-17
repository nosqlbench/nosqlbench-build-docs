---
title: Sin
weight: 10014
---
## Sin


- `double -> Sin() -> double`

## TriangleWave

Computes the distance between the current input value and the beginning of the phase, according to a phase length. This means that for a phase length of 100, the values will range from 0 (for cycle values 0 and 100 or any multiple thereof) and 50, when the cycle value falls immediately at the middle of the phase.

- `long -> TriangleWave(long: phaseLength, Object: scaleFunc) -> long`

- `long -> TriangleWave(long: phaseLength) -> long`

- `double -> TriangleWave(double: phaseLength, Object: scaler) -> double`

- `double -> TriangleWave(double: phaseLength) -> double`

