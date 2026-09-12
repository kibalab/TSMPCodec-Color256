# Color256 SDK-Optional Validation

Date: 2026-09-12. Unity 2022.3.22f1, Core 0.2.0, Luma4 0.0.3, Worlds SDK 3.10.4-beta.2 with bundled UdonSharp, RTX 4090 / Direct3D11.

Evidence directory: F:/Unity/TSMP/Validation-Results/s07.

| Check | Result | Log / result prefix |
| --- | --- | --- |
| SDK-free import, Setup, shaders and native GPU loopback | Pass, direct / robust / robust-refine modes | 20260912-195128-Color256-Play |
| Windows x64 Development Mono build, stripping disabled | Succeeded, zero errors, twelve shader warnings | 20260912-195346-Color256-Build |
| Actual Player, nine frames of Transform/Humanoid/Unicode/RPC loopback | Pass | 20260912-195432-Color256-Player |
| Full Udon client compile, automatic backing, real Udon VM block/full-resolution output parity and GPU decoding | Pass, all three modes | 20260912-195451-Color256-Udon |

Player: F:/Unity/TSMP/Validation-Codecs-NoSDK/Build/Color256/CodecValidation.exe. The adjacent .build-report.txt records the build result. All 1,027 test payload bytes matched the GPU output in each mode. RGB16 and RGB20 remained installed, also checking coexistence and automatic codec selection.

Program field metadata was regenerated without profiler instrumentation. Color256 has no bundled compiled program cache; UdonSharp generates it in the consuming project. The existing program reference is preserved instead of serializing the validation project's cache GUID.

Shader warnings concern existing sample/classifier initialization analysis and signed integer divisions, including other installed codecs. Codec algorithms were not changed. No SDK world upload, IL2CPP, Quest or lossy transport test was performed. The Udon VM test is not a claim of an uploaded VRChat client test.
