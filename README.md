# MTMarathon Swift

Based on Lane's [mt-marathon-swift-c](https://github.com/dowobeha/mt-marathon-swift-c).

Depends on the [SwiftCUDA](https://github.com/rxwei/SwiftCUDA) package.

## Build

```
make
```

`make` calls `swift build` with header path `/usr/local/cuda/include` and
`/usr/local/cuda/lib`.

