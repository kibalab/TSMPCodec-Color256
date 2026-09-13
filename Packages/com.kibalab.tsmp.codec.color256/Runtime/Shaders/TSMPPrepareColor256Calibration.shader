Shader "Hidden/TSMP/Prepare Color256 Calibration"
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
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma target 3.5
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.kibalab.tsmp.core/Runtime/Codecs/Common/Shaders/cgincs/TSMPDecodeCommon.cginc"

            float _ColorCalibrationStartBlock;
            #include "Color256Calibration.cginc"

            float4 frag(v2f i) : SV_Target
            {
                int index = (int)floor(i.pos.x);
                return index < 256
                    ? float4(SampleBlockByIndex(_ColorCalibrationStartBlock + index), 1)
                    : AverageCalibrationChannel(index < 264 ? index - 256 : index < 272 ? index - 264 : index - 272,
                        index < 264 ? 0 : index < 272 ? 1 : 2).xxxx;
            }
            ENDCG
        }
    }

    Fallback Off
}
