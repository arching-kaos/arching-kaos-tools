#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include "libakfs.h"

const char* ak_fs_maps_v3_get_dir()
{
    return getenv("AK_MAPSDIR");
}

void ak_fs_maps_v3_init(akfs_map_v3** ms, size_t l)
{
    akfs_map_v3 *m = NULL;
    for (m = *ms; m < *ms+l; ++m)
    {
        ak_fs_map_v3_init(m);
    }
}

void ak_fs_maps_v3_print_map_hashes(akfs_map_v3** m, size_t s)
{
    akfs_map_v3 *ptr = NULL;
    for (ptr = *m; ptr < *m+s; ++ptr)
    {
        if ( !ak_fs_map_v3_is_null(ptr) ) ak_fs_map_v3_print_map_hash(ptr);
    }
}

void ak_fs_maps_v3_print_filenames(akfs_map_v3** m, size_t s)
{
    akfs_map_v3 *ptr = NULL;
    for (ptr = *m; ptr < *m+s; ++ptr)
    {
        if ( ptr != NULL )
        {
            ak_fs_map_v3_print_filename(ptr);
            printf("\n");
        }
    }
}

void ak_fs_maps_v3_print(akfs_map_v3 **map_store, size_t length)
{
    akfs_map_v3 *ptr = NULL;
    for ( ptr = *map_store; ptr < *map_store + length; ++ptr)
    {
        ak_fs_map_v3_print(ptr);
        printf("\n");
    }
}

void ak_fs_maps_v3_print_as_json(akfs_map_v3 **map_store, size_t length)
{
    akfs_map_v3 *ptr = NULL;
    for ( ptr = *map_store; ptr < *map_store + length; ++ptr)
    {
        ak_fs_map_v3_print_as_json(ptr);
    }
}

size_t ak_fs_maps_v3_found_in_fs()
{
    DIR *d;
    size_t counter = 0;
    d = opendir(ak_fs_maps_v3_get_dir());
    if (d)
    {
        const struct dirent *dir;
        while ((dir = readdir(d)) != NULL )
        {
            if (ak_fs_verify_input_is_hash(dir->d_name, strlen(dir->d_name))) counter++;
        }
    }
    closedir(d);
    return counter;
}
