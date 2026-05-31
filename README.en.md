[한국어](README.md) | **English** | [日本語](README.ja.md)

# TSMP Codec Color256

Color256 codec package for TSMP.

This package is used with TSMP Core and provides the Color256 codec handler, decode shaders, materials, prefab, and codec catalog asset discovered by the Codec tab in `TSMPSetup`.

## Installation

Add the VPM repository in VRChat Creator Companion.

```text
https://vpm.kiba.red/
```

Then install `TSMP Codec Color256`.

## Requirements

- `com.kibalab.tsmp.core` 0.0.1 or newer
- VRChat Worlds SDK 3.9.0 or newer

## Usage

1. Add the TSMP Core `TSMPController.prefab` or an equivalent TSMP setup to the scene.
2. Open the Codec tab on `TSMPSetup`.
3. Press `Refresh Codecs`.
4. Confirm that `Color256` appears and select it.
5. Run `Apply Setup`.

Color256 provides higher color capacity than Luma4 at a higher visual and decode cost.

## Release

This repository is configured so pushing a version tag creates release artifacts and registers the package with the VPM backend.

The tag must match the `version` in `package.json`.

Example:

```bash
git tag v1.0.0
git push origin v1.0.0
```
