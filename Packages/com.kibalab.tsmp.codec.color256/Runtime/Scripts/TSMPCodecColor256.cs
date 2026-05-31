using UnityEngine;

namespace K13A.TSMP
{
    [AddComponentMenu("TSMP/Codecs/Color256 Codec")]
    public sealed class TSMPCodecColor256 : TSMPCodec
    {
        private const int SymbolModeColor256 = 3;
        private const int SymbolCount = 256;

        public bool robustChannelDecode = true;
        public bool localRefine = true;
        public Material directByteDecodeMaterial;
        public Material robustByteDecodeMaterial;
        public Material robustRefineByteDecodeMaterial;
        public Material[] debugMaterials;

#if !COMPILER_UDONSHARP
        public override int SymbolMode => SymbolModeColor256;
        public override int GetPayloadStartRow(int width, int blockSize)
        {
            int activeWidthBlocks = Mathf.Max(1, FrameCapacity.GetActiveWidthBlocks(width, blockSize));
            return Luma4Raster.PayloadStartRow + ((SymbolCount + activeWidthBlocks - 1) / activeWidthBlocks);
        }

        public override int GetPayloadCapacityBytes(int width, int height, int blockSize)
        {
            int activeWidthBlocks = FrameCapacity.GetActiveWidthBlocks(width, blockSize);
            int activeHeightBlocks = FrameCapacity.GetActiveHeightBlocks(height, blockSize);
            int payloadRows = Mathf.Max(0, activeHeightBlocks - GetPayloadStartRow(width, blockSize) - Luma4Raster.ReservedEndRows);
            return activeWidthBlocks * payloadRows;
        }

        public override int GetPayloadBlocksForBytes(int byteCount) => byteCount;

        public override bool TryWriteFrame(Texture2D texture, int blockSize, byte[] headerBytes, byte[] payloadBytes, out string error)
        {
            if (!ValidateFrame(texture, blockSize, headerBytes, payloadBytes, out error))
                return false;

            Color32[] pixels = FrameRaster.CreateClearedPixels(texture.width, texture.height);
            Luma4Raster.WriteBaseRegions(pixels, texture.width, texture.height, blockSize, headerBytes);
            WriteCalibration(pixels, texture.width, texture.height, blockSize);
            WritePayload(pixels, texture.width, texture.height, blockSize, payloadBytes, payloadBytes.Length);
            FrameRaster.WriteEndMarker(pixels, texture.width, texture.height, blockSize);
            texture.SetPixels32(pixels);
            texture.Apply(false, false);
            return true;
        }

        public override byte[] GetCodecOptionBytes()
        {
            return new[] { (byte)(robustChannelDecode ? 1 : 0), (byte)(localRefine ? 1 : 0) };
        }

        public override int DecodeMaterialCount => 3;
        public override int DebugMaterialCount => debugMaterials != null ? debugMaterials.Length : 0;
        public override Material GetDebugMaterial(int index) => debugMaterials != null && index >= 0 && index < debugMaterials.Length ? debugMaterials[index] : null;

        public override Material GetDecodeMaterial(int index)
        {
            if (index == 0) return directByteDecodeMaterial;
            if (index == 1) return robustByteDecodeMaterial;
            if (index == 2) return robustRefineByteDecodeMaterial;
            return null;
        }

        public override void ConfigureMaterials(CodecMaterialContext context)
        {
            base.ConfigureMaterials(context);
            ConfigureColor256Material(directByteDecodeMaterial, context);
            ConfigureColor256Material(robustByteDecodeMaterial, context);
            ConfigureColor256Material(robustRefineByteDecodeMaterial, context);
            ConfigureMaterialGroup(debugMaterials, context, false);
            if (debugMaterials != null)
            {
                for (int i = 0; i < debugMaterials.Length; i++)
                    ConfigureColor256Material(debugMaterials[i], context);
            }
        }

        private static void ConfigureColor256Material(Material material, CodecMaterialContext context)
        {
            if (material == null)
                return;

            SetFloatIfPresent(material, "_ColorCalibrationStartBlock", Luma4Raster.PayloadStartRow * context.FrameLayout.ActiveWidthBlocks);
        }

        private bool ValidateFrame(Texture2D texture, int blockSize, byte[] headerBytes, byte[] payloadBytes, out string error)
        {
            return ValidateRasterFrame(texture, blockSize, headerBytes, payloadBytes, out error);
        }

        private static void WriteCalibration(Color32[] pixels, int width, int height, int blockSize)
        {
            int activeWidthBlocks = FrameCapacity.GetActiveWidthBlocks(width, blockSize);
            int startBlock = Luma4Raster.PayloadStartRow * activeWidthBlocks;
            for (int symbol = 0; symbol < SymbolCount; symbol++)
                FrameRaster.WriteColorBlockAtIndex(pixels, width, height, blockSize, startBlock + symbol, SymbolToColor256((byte)symbol));
        }

        private void WritePayload(Color32[] pixels, int width, int height, int blockSize, byte[] payloadBytes, int payloadByteCount)
        {
            int activeWidthBlocks = FrameCapacity.GetActiveWidthBlocks(width, blockSize);
            int payloadStartBlock = GetPayloadStartRow(width, blockSize) * activeWidthBlocks;
            int maxBlocks = GetPayloadBlocksForBytes(GetPayloadCapacityBytes(width, height, blockSize));
            for (int i = 0; i < payloadByteCount && i < maxBlocks; i++)
                FrameRaster.WriteColorBlockAtIndex(pixels, width, height, blockSize, payloadStartBlock + i, SymbolToColor256(payloadBytes[i]));
        }
#endif

        public override void ApplyDecodeOptions()
        {
            bool robust = ReadCodecOptionFlag(0, false);
            bool refine = ReadCodecOptionFlag(1, false);

            if (robust && refine && robustRefineByteDecodeMaterial != null)
                selectedDecodeMaterial = robustRefineByteDecodeMaterial;
            else if (robust && robustByteDecodeMaterial != null)
                selectedDecodeMaterial = robustByteDecodeMaterial;
            else
                selectedDecodeMaterial = directByteDecodeMaterial;

            payloadStartRow = activeWidthBlocks > 0 ? 5 + ((256 + activeWidthBlocks - 1) / activeWidthBlocks) : 5;
            payloadBlockCount = byteCount;

            if (selectedDecodeMaterial != null)
            {
                selectedDecodeMaterial.SetFloat("_ColorCalibrationStartBlock", calibrationStartBlock);
                selectedDecodeMaterial.SetFloat("_InterleaveMode", decodeStage == 2 && payloadInterleaved ? 1f : 0f);
            }
        }

#if UDONSHARP
        public override int GetEncoderSymbolMode()
        {
            return SymbolModeColor256;
        }

        public override int GetEncoderPayloadStartRow(int width, int blockSize)
        {
            int activeWidthBlocks = Mathf.Max(1, GetEncoderActiveWidthBlocks(width, blockSize));
            return 5 + ((256 + activeWidthBlocks - 1) / activeWidthBlocks);
        }

        public override int GetEncoderPayloadCapacityBytes(int width, int height, int blockSize)
        {
            int activeWidthBlocks = GetEncoderActiveWidthBlocks(width, blockSize);
            int activeHeightBlocks = GetEncoderActiveHeightBlocks(height, blockSize);
            int payloadRows = Mathf.Max(0, activeHeightBlocks - GetEncoderPayloadStartRow(width, blockSize) - 1);
            return activeWidthBlocks * payloadRows;
        }

        public override int GetEncoderCodecOptionByteCount()
        {
            return 2;
        }

        public override int GetEncoderCodecOptionByte(int index)
        {
            if (index == 0)
                return robustChannelDecode ? 1 : 0;
            if (index == 1)
                return localRefine ? 1 : 0;
            return 0;
        }

        public override bool WriteEncoderPayload(Color32[] pixels, int width, int height, int blockSize, byte[] payloadBytes, int payloadByteCount)
        {
            int activeWidthBlocks = GetEncoderActiveWidthBlocks(width, blockSize);
            int activeHeightBlocks = GetEncoderActiveHeightBlocks(height, blockSize);
            if (pixels == null || payloadBytes == null || activeWidthBlocks <= 0 || activeHeightBlocks <= 0)
                return false;

            int calibrationStartBlock = 5 * activeWidthBlocks;
            for (int symbol = 0; symbol < 256; symbol++)
                WriteEncoderColorBlockAtIndex(pixels, width, height, blockSize, calibrationStartBlock + symbol, SymbolToColor256((byte)symbol));

            int payloadStartRow = GetEncoderPayloadStartRow(width, blockSize);
            int payloadStartBlock = payloadStartRow * activeWidthBlocks;
            int maxBlocks = activeWidthBlocks * Mathf.Max(0, activeHeightBlocks - payloadStartRow - 1);
            for (int i = 0; i < payloadByteCount && i < maxBlocks; i++)
                WriteEncoderColorBlockAtIndex(pixels, width, height, blockSize, payloadStartBlock + i, SymbolToColor256(payloadBytes[i]));

            return true;
        }
#endif

        private static Color32 SymbolToColor256(byte symbol)
        {
            int rIndex = symbol & 0x07;
            int gIndex = (symbol >> 3) & 0x07;
            int bIndex = (symbol >> 6) & 0x03;
            return new Color32(QuantizeColorLevel(rIndex, 7), QuantizeColorLevel(gIndex, 7), QuantizeColorLevel(bIndex, 3), 255);
        }

        private static byte QuantizeColorLevel(int index, int maxIndex)
        {
            if (maxIndex <= 0)
                return 128;

            return (byte)Mathf.RoundToInt(24f + index * (208f / maxIndex));
        }
    }
}
