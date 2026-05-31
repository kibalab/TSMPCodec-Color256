Shader "Hidden/TSMP/Decode Color256 Bytes"
{
    Properties
    {
        _MainTex ("TSMP Source", 2D) = "black" {}
        _BlockSize ("Block Size", Float) = 8
        _SampleSize ("Sample Size", Float) = 0
        _StartBlock ("Start Block", Float) = 0
        _ByteCount ("Byte Count", Float) = 0
        _ActiveWidthBlocks ("Active Width Blocks", Float) = 80
        _SourceWidth ("Source Width", Float) = 640
        _SourceHeight ("Source Height", Float) = 360
        _OutputWidth ("Output Width", Float) = 14
        _OutputHeight ("Output Height", Float) = 1
        _FlipY ("Flip Y", Float) = 1
        _ColorCalibrationStartBlock ("Color Calibration Start Block", Float) = 640
        _InterleaveMode ("Interleave Mode", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Overlay" }
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma target 3.5
            #pragma vertex vert
            #pragma fragment frag
            #include "../../../com.kibalab.tsmp.core/Runtime/Codecs/Common/Shaders/cgincs/TSMPDecodeCommon.cginc"

            float _ColorCalibrationStartBlock;
            float _InterleaveMode;

            int ClassifyColor256(float3 rgb)
            {
                float3 p = RgbToYCoCg(rgb);
                int symbol = 0;
                float bestDistance = 999999.0;

                [loop]
                for (int i = 0; i < 256; i++)
                {
                    float3 c = RgbToYCoCg(SampleBlockByIndex(_ColorCalibrationStartBlock + i));
                    float3 d = p - c;
                    float distance = d.x * d.x * 2.0 + d.y * d.y * 0.85 + d.z * d.z * 0.85;
                    if (distance < bestDistance)
                    {
                        bestDistance = distance;
                        symbol = i;
                    }
                }

                return symbol;
            }

            int DecodeByte(int byteIndex)
            {
                if (byteIndex < 0 || byteIndex >= (int)_ByteCount)
                    return 0;

                float blockOffset = byteIndex;
                if (_InterleaveMode > 0.5)
                {
                    float rows = ceil(_ByteCount / _ActiveWidthBlocks);
                    float logicalByte = (float)byteIndex;
                    blockOffset = fmod(logicalByte, rows) * _ActiveWidthBlocks + floor(logicalByte / rows);
                }

                return ClassifyColor256(SampleBlockByIndex(_StartBlock + blockOffset));
            }

            #include "../../../com.kibalab.tsmp.core/Runtime/Codecs/Common/Shaders/cgincs/TSMPDecodeByteOutput.cginc"
            ENDCG
        }
    }

    Fallback Off
}
