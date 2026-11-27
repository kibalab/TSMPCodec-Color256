Shader "Hidden/TSMP/Decode Color256 Bytes"
{
    Properties
    {
        [HideInInspector] _TSMPHeaderTex ("Decoded Header", 2D) = "black" {}
        [HideInInspector] _TSMPHeaderPixels ("Header Pixels", Float) = 0
        [HideInInspector] _UseBilinear4 ("Bilinear 4x4 sampling", Float) = 0
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
            #define TSMP_ENABLE_RGB_BOX4
            #include "Packages/com.kibalab.tsmp.core/Runtime/Codecs/Common/Shaders/cgincs/TSMPDecodeCommon.cginc"

            float _ColorCalibrationStartBlock;
            #include "Color256Payload.cginc"

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

                return ClassifyColor256(SampleBlockByIndex(Color256PayloadBlock((uint)byteIndex)));
            }

            #include "Packages/com.kibalab.tsmp.core/Runtime/Codecs/Common/Shaders/cgincs/TSMPDecodeByteOutput.cginc"
            ENDCG
        }
    }

    Fallback Off
}
