float _InterleaveMode;

uint Color256PayloadBlock(uint index)
{
    if (_InterleaveMode > 0.5)
    {
        uint width = max(1u, (uint)_ActiveWidthBlocks);
        uint rows = 1u + ((uint)_ByteCount - 1u) / width;
        index = (index % rows) * width + index / rows;
    }
    return (uint)_StartBlock + index;
}
