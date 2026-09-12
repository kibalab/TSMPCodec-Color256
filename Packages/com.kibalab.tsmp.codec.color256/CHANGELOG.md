# Changelog

## 0.0.3-beta.2

- Support ordinary Unity without a VRChat SDK dependency through UPM; retain Worlds SDK requirements for VPM.
- Require Core 0.2.0 and use its shared automatic Controller workflow with an SDK-neutral codec prefab.
- Detect installed Worlds packages with an assembly version define so the Udon encoder path is available without manual scripting defines.
- Resolve shared shader includes through Packages/com.kibalab.tsmp.core for local and installed packages.
- Regenerate Udon program field metadata against Core 0.2.0 without legacy profiler fields, preserving the original program reference.
- Preserve codec IDs, settings, script/material/prefab GUIDs and the encoded wire format.

## 0.0.3-beta.1

- Beta release metadata for VPM distribution.
- Includes Color256 codec runtime, shaders, materials, prefab, and sample.
