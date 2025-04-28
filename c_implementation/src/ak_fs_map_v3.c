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

bool ak_fs_map_v3_compare(akfs_map_v3* a, akfs_map_v3* b)
{
    return (
            (ak_fs_sha512sum_compare(&a->oh, &b->oh) == true) &&
            (ak_fs_sha512sum_compare(&a->rh, &b->rh) == true) &&
            (ak_fs_sha512sum_compare(&a->mh, &b->mh) == true) &&
            (strcmp(a->filename, b->filename) == 0)
           );
}


bool ak_fs_map_v3_is_null(akfs_map_v3* m)
{
    akfs_map_v3 n;
    ak_fs_map_v3_init(&n);
    if ( ak_fs_map_v3_compare(m, &n) )
    {
        ak_log_debug(__func__, "true");
    }
    else
    {
        ak_log_debug(__func__, "false");
    }
    return ak_fs_map_v3_compare(m, &n);
}

void ak_fs_map_v3_print_map_hash(akfs_map_v3 *map)
{
    if( !ak_fs_sha512sum_is_null(&(map->mh)) )
    {
        char str[129] = {0};
        char* s = &str[0];
        ak_fs_sha512sum_struct_to_string(&(map->mh), s);
        printf("%s", s);
    }
    else
    {
        ak_log_debug(__func__,"hash is null");
    }
}

void ak_fs_map_v3_print_original_hash(akfs_map_v3 *map)
{
    if (!ak_fs_sha512sum_is_null(&(map->oh)))
    {
        printf("%s", ak_fs_sha512sum_struct_read_as_string(&(map->oh)));
    }
    else
    {
        ak_log_debug(__func__,"hash is null");
    }
}

void ak_fs_map_v3_print_root_hash(akfs_map_v3 *map)
{
    if (!ak_fs_sha512sum_is_null(&(map->rh)))
    {
        printf("%s", ak_fs_sha512sum_struct_read_as_string(&(map->rh)));
    }
    else
    {
        ak_log_debug(__func__,"hash is null");
    }
}

sha512sum* ak_fs_map_v3_get_map_hash(akfs_map_v3 *map)
{
    return &(map->mh);
}

sha512sum* ak_fs_map_v3_get_root_hash(akfs_map_v3 *map)
{
    if (!ak_fs_sha512sum_is_null(&(map->rh)))
    {
        return &(map->rh);
    }
    else
    {
        return NULL;
    }
}

sha512sum* ak_fs_map_v3_get_orig_hash(akfs_map_v3 *map)
{
    if (!ak_fs_sha512sum_is_null(&(map->oh)))
    {
        return &(map->oh);
    }
    else
    {
        return NULL;
    }
}

char* ak_fs_map_v3_get_filename(akfs_map_v3 *map)
{
    return map->filename;
}

void ak_fs_map_v3_print_filename(akfs_map_v3 *map)
{
    printf("%s", ak_fs_map_v3_get_filename(map));
}

void ak_fs_map_v3_print(akfs_map_v3 *map)
{
    printf("map_v3 {");
    printf("\n .mh: ");
    ak_fs_map_v3_print_map_hash(map);
    printf("\n .oh: ");
    ak_fs_map_v3_print_original_hash(map);
    printf("\n .rh: ");
    ak_fs_map_v3_print_root_hash(map);
    printf("\n .fn: ");
    ak_fs_map_v3_print_filename(map);
    printf("\n}\n");
}

void ak_fs_map_v3_print_as_json(akfs_map_v3 *map)
{
    printf("{\"type\":\"map_v3\",");
    printf("\"map\":\"");
    ak_fs_map_v3_print_map_hash(map);
    printf("\",");
    printf("\"original\":\"");
    ak_fs_map_v3_print_original_hash(map);
    printf("\",");
    printf("\"root\":\"");
    ak_fs_map_v3_print_root_hash(map);
    printf("\",");
    printf("\"filename\":\"");
    ak_fs_map_v3_print_filename(map);
    printf("\"");
    printf("}\n");
}

void ak_fs_map_v3_print_bif(akfs_map_v3 *map)
{
    ak_fs_map_v3_print_map_hash(map);
    printf(" ");
    ak_fs_map_v3_print_root_hash(map);
    printf(" ");
    ak_fs_map_v3_print_filename(map);
}

int ak_fs_map_v3_open_from_file(akfs_map_v3 * map)
{
    if (map==0x0)
    {
        ak_log_debug(__func__, "Zeropointer");
        return 1;
    }
    FILE *fd;
    char *full_path = {0};
    asprintf(&full_path,
            "%s/%s",
            ak_fs_maps_v3_get_dir(),
            ak_fs_sha512sum_struct_read_as_string(ak_fs_map_v3_get_map_hash(map))
            );
    // printf("Trying path: %s\n", full_path);
    fd = fopen(full_path, "rb");
    if (!fd)
    {
        // perror("fopen");
        ak_log_debug(__func__, "File not found or other error");
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
    // ak_fs_sha512sum_string_to_struct(maphash, &(map->mh));
    if ( ak_fs_convert_map_v3_string_to_struct(buffer, strlen(buffer), map) != 0 )
    {
        ak_log_debug(__func__,"conversion failed");
        fclose(fd);
        return 1;
    }
    fclose(fd);
    return 0;
}

int ak_fs_open_map_v3_file(char* maphash, akfs_map_v3 * map)
{
    ak_log_debug(__func__, "Started");
    if (map==0x0)
    {
        ak_log_debug(__func__, "Zeropointer");
        return 1;
    }
    if ( !ak_fs_verify_input_is_hash(maphash, strlen(maphash)) )
    {
        ak_log_debug(__func__,"not a hash");
        return 1;
    }
    FILE *fd;
    char *full_path = {0};
    asprintf(&full_path, "%s/%s", ak_fs_maps_v3_get_dir(), maphash);
    printf("Trying path: %s\n", full_path);
    fd = fopen(full_path, "rb");
    if (!fd)
    {
        // perror("fopen");
        ak_log_debug(__func__, "file not found");
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
