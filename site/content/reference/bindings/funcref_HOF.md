---
weight: 25968606
title: CqlVector
---
## CqlVector

Create a new CqlVector from a composed function, where the inner function is a list generation function that must take a long (cycle) input.

- `long -> CqlVector(Object: func) -> com.datastax.oss.driver.api.core.data.CqlVector`
  - *example:* `CqlVector(ListSized(2,HashedRange(0.2f, 5.0f)`
  - *Create a 2-component vector with the given range of values.*

