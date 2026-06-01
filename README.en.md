[한국어](README.ko.md) | **English** | [日本語](README.md)

# TSMP Codec Color256

Color256 records payload using a constrained color set as TSMP symbols. It provides higher density than Luma4 while keeping symbol decisions more explicit than high-density RGB codecs.

## Characteristics

- 256-color TSMP symbols
- Higher payload density than Luma4
- Standard, robust, and refine decode shaders
- Best for stream paths without heavy color compression or post-processing
- Automatically discovered in the `TSMPSetup` Codec tab

## Requirements

- TSMP Core: https://github.com/kibalab/TSMP-Core
- `com.kibalab.tsmp.core` 0.0.1 or newer
- VRChat Worlds SDK 3.9.0 or newer

## Installation

Add the VPM repository in VRChat Creator Companion.

```text
https://vpm.kiba.red/
```

Then install `TSMP Core` and `TSMP Codec Color256`.

## Usage

1. Add `Packages/com.kibalab.tsmp.core/Samples/TSMPController.prefab` from the Core package to your scene.
2. Open the Codec tab in `TSMPSetup` and click `Refresh Codecs`.
3. Select `Color256`.
4. Click `Apply Setup`.

## Release Status

This package is currently beta and uses `v0.0.x-beta.x` tags.

## License

MIT License. Copyright (c) 2026 KIBA_Labs.
