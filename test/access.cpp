#include <stdio.h>
#include <string.h>
#include <assert.h>

#include <World.h>
#include <Chunk.h>
#include <Access.h>

using namespace vman;

enum LayerIndex
{
    BASE_LAYER = 0,
    EXTRA_LAYER,
    LAYER_COUNT
};

void CopyBytes( const void* source, void* destination, int count )
{
    memcpy(destination, source, count);
}

static const vmanLayer layers[LAYER_COUNT] =
{
    {"Material", 1, 1, CopyBytes, CopyBytes},
    {"Pressure", 1, 1, CopyBytes, CopyBytes}
};

static const int CHUNK_EDGE_LENGTH = 8;

int main()
{
    World world(layers, LAYER_COUNT, CHUNK_EDGE_LENGTH, ".");
    Access access(&world);

    {
        vmanVolume volume;
        volume.x = -20;
        volume.y = -20;
        volume.z = -20;
        volume.w = 40;
        volume.h = 40;
        volume.d = 40;

        access.setVolume(&volume);
    }

    {
        access.lock(VMAN_WRITE_ACCESS);

        char* voxel = (char*)access.readWriteVoxelLayer(0,0,0, BASE_LAYER);
        *voxel = 'X';

        access.unlock();
    }

    {
        access.lock(VMAN_READ_ACCESS);

        const char* voxel = (const char*)access.readVoxelLayer(0,0,0, BASE_LAYER);
        assert(*voxel == 'X');

        access.unlock();
    }

    puts("No problems detected.");

    return 0;
}