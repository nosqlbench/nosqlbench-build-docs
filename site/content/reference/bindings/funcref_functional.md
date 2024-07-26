---
title: flow functions
weight: 40
---

These functions help combine other functions into higher-order functions when needed.
## ConcatArray

This variant of Concat allows you to apply a string concatenation to a series of string produced by the provided functions. Each position of a delimiter will simply contain all generated values, although usually, you won't need more than one.

- `long -> ConcatArray(String: delimiter, int: size, String: template, Object[]...: functions) -> String`
  - *example:* `ConcatArray(',',5,'{{}}', NumberNameToString())`

## Expr

Allow for the use of arbitrary expressions according to the [MVEL](http://mvel.documentnode.com/) expression language. Variables that have been set by a Save function are available to be used in this function. The variable name `cycle` is reserved, and is always equal to the current input value. This is not the same in every case as the current cycle of an operation. It could be different if there are preceding functions which modify the input value.

- `long -> Expr(String: expr) -> int`

- `long -> Expr(String: expr) -> long`

- `long -> Expr(String: expr) -> String`

- `long -> Expr(String: expr) -> UUID`

- `int -> Expr(String: expr) -> int`

- `double -> Expr(String: expr) -> double`

- `long -> Expr(String: expr) -> Object`

## IntFlow

Combine multiple IntUnaryOperators into a single function.

- `int -> IntFlow(function.IntUnaryOperator[]...: ops) -> int`

## LongFlow

Combine multiple LongUnaryOperators into a single function.

- `long -> LongFlow(function.LongUnaryOperator[]...: ops) -> long`
  - *example:* `LongFlow(Add(3),Mul(6))`
  - *Create an integer operator which adds 3 and multiplies the result by 6*

## StringFlow

Combine multiple String functions together into one function.

- `String -> StringFlow(function.Function<String,String>[]...: funcs) -> String`

