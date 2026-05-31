Shader "Hidden/TSMP/Decode Color256 Robust Bytes"
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

            int MakeColor256Symbol(int r, int g, int b)
            {
                return r | (g << 3) | (b << 6);
            }

            float ChannelValue(float3 c, int channel)
            {
                return channel == 0 ? c.r : channel == 1 ? c.g : c.b;
            }

            float AverageCalibrationChannel(int level, int channel)
            {
                float sum = 0.0;
                int count = 0;

                [loop]
                for (int b = 0; b < 4; b++)
                {
                    [loop]
                    for (int g = 0; g < 8; g++)
                    {
                        [loop]
                        for (int r = 0; r < 8; r++)
                        {
                            bool include = false;
                            if (channel == 0 && r == level) include = true;
                            if (channel == 1 && g == level) include = true;
                            if (channel == 2 && b == level) include = true;

                            if (include)
                            {
                                int symbol = MakeColor256Symbol(r, g, b);
                                sum += ChannelValue(SampleBlockByIndex(_ColorCalibrationStartBlock + symbol), channel);
                                count++;
                            }
                        }
                    }
                }

                return sum / max(1, count);
            }

            int ClassifyChannelLevel(float value, int channel, int levelCount)
            {
                int bestLevel = 0;
                float bestDistance = 999999.0;

                [loop]
                for (int level = 0; level < 8; level++)
                {
                    if (level < levelCount)
                    {
                        float c = AverageCalibrationChannel(level, channel);
                        float d = abs(value - c);
                        if (d < bestDistance)
                        {
                            bestDistance = d;
                            bestLevel = level;
                        }
                    }
                }

                return bestLevel;
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

                float3 rgb = SampleBlockByIndex(_StartBlock + blockOffset);
                int r = ClassifyChannelLevel(rgb.r, 0, 8);
                int g = ClassifyChannelLevel(rgb.g, 1, 8);
                int b = ClassifyChannelLevel(rgb.b, 2, 4);
                return MakeColor256Symbol(r, g, b);
            }

            #include "../../../com.kibalab.tsmp.core/Runtime/Codecs/Common/Shaders/cgincs/TSMPDecodeByteOutput.cginc"
            ENDCG
        }
    }

    Fallback Off
}
