#include <stdio.h>
#include <string.h>
#include <libakfs.h>
#include <libaklog.h>
#include <sys/stat.h>

// const char maps_dir[] = "/home/kaotisk/.arching-kaos/akfs/maps/";

void ak_fs_map_v3_init(akfs_map_v3 *map)
{
    ak_fs_sha512sum_init(&map->oh);
    ak_fs_sha512sum_init(&map->rh);
    ak_fs_sha512sum_init(&map->mh);
    ak_fs_init_string(map->filename, 256);
}

void ak_fs_map_v3_init_store(akfs_map_v3** ms, size_t l)
{
    akfs_map_v3 *m = NULL;
    for (m = *ms; m < *ms+l; ++m)
    {
        ak_fs_map_v3_init(m);
    }
}

void ak_fs_map_v3_print_original_hash(akfs_map_v3 *map)
{
    if (!ak_fs_map_v3_is_null(map))
    {
        char str[129];
        ak_fs_sha512sum_struct_to_string(&(map->oh), str);
        printf(" .oh: %s\n", str);
    }
    else
    {
        ak_log_debug(__func__,"map is null");
    }
}

void ak_fs_map_v3_print_root_hash(akfs_map_v3 *map)
{
    if (!ak_fs_map_v3_is_null(map))
    {
        char str[129];
        ak_fs_sha512sum_struct_to_string(&(map->rh), str);
        printf(" .rh: %s\n", str );
    }
    else
    {
        ak_log_debug(__func__,"map is null");
    }
}

char* ak_fs_map_v3_get_filename(akfs_map_v3 *map)
{
    if (!ak_fs_map_v3_is_null(map))
    {
        return map->filename;
    }
    else
    {
        return "";
    }
}

void ak_fs_map_v3_print_filename(akfs_map_v3 *map)
{
    if (!ak_fs_map_v3_is_null(map))
    {
        printf("%s\n", ak_fs_map_v3_get_filename(map));
    }
}

void ak_fs_map_v3_print_map_hash(akfs_map_v3 *map)
{
    if (!ak_fs_map_v3_is_null(map))
    {
        char str[129];
        ak_fs_sha512sum_struct_to_string(&(map->mh), str);
        printf(" .mh: %s\n", str );
    }
}

void ak_fs_map_v3_print(akfs_map_v3 *map)
{
    printf("map_v3 {\n");
    ak_fs_map_v3_print_map_hash(map);
    ak_fs_map_v3_print_original_hash(map);
    ak_fs_map_v3_print_root_hash(map);
    ak_fs_map_v3_print_filename(map);
    printf("}\n");
}

int ak_fs_open_map_v3_file(char* maphash, akfs_map_v3 * map)
{
    if (map==0x0)
    {
        ak_log_debug(__func__, "Zeropointer");
        return 1;
    }
    if ( !ak_fs_verify_input_is_hash(maphash) )
    {
        ak_log_debug(__func__,"not a hash");
        return 1;
    }
    FILE *fd;
    char *full_path = {0};
    asprintf(&full_path, "%s%s", ak_fs_maps_v3_get_dir(), maphash);
    // printf("Trying path: %s\n", full_path);
    fd = fopen(full_path, "rb");
    if (!fd)
    {
        // perror("fopen");
        return 1;
    }
    struct stat sb;
    if (stat(full_path, &sb) == -1) {
        perror("stat");
        fclose(fd);
        return 2;
    }
    // File size: %lld in bytes: (long long) sb.st_size);
    char buffer[(long long) sb.st_size+1];
    fread(&buffer, sizeof(buffer), (long long) sb.st_size, fd);
    ak_fs_sha512sum_string_to_struct(maphash, &(map->mh));
    if ( ak_fs_convert_map_v3_string_to_struct(buffer, strlen(buffer), map) != 0 )
    {
        ak_log_debug(__func__,"conversion failed");
        fclose(fd);
        return 1;
    }
    fclose(fd);
    return 0;
}

int ak_fs_map_v3_to_file(akfs_map_v3 maphash)
{
    (void)maphash;
    return 0;
}
