#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <libakfs.h>
#include <libaklog.h>
#include <libaksettings.h>
#include <sys/stat.h>
#include <dirent.h>

const char* ak_fs_maps_v3_get_dir()
{
    return getenv("AK_MAPSDIR");
}

char* ak_fs_return_hash_path(const char* str)
{
    if ( ak_fs_verify_input_is_hash(str) )
    {
        unsigned int i = 0;
        char *result = malloc((128*2)+1);
        if ( result == NULL )
        {
            return "";
        }
        while ( str[i] != '\0' )
        {
            result[i*2] = str[i];
            if ( (i*2) + 1 <= 254 )
            {
                result[(i*2)+1] = '/';
            }
            else
            {
                result[(i*2)+1] = '\0';
            }
            ++i;
        }
        return result;
    }
    else
    {
        return NULL;
    }
}

char* ak_fs_return_hash_dir(const char* str)
{
    if ( ak_fs_verify_input_is_hash(str) )
    {
        unsigned int i = 0;
        char *result = malloc((128*2)+1);
        if ( result == NULL ) return "";
        while ( str[i] != '\0' )
        {
            result[i*2] = str[i];
            if ( (i*2) + 1 <= 254-2 )
            {
                result[(i*2)+1] = '/';
            }
            else
            {
                result[(i*2)+1] = '\0';
            }
            ++i;
        }
        return result;
    }
    else
    {
        return NULL;
    }
}

bool ak_fs_verify_input_is_hash(const char* str)
{
    size_t i = 0;
    while ( str[i] != '\0' )
    {
        if (
                i < 128 &&
                !(
                    ( str[i] >= 0x30 ) &&
                    (( str[i] <= 0x39) || ( str[i] >= 0x61 )) &&
                    ( str[i] <= 0x66 )
                )
            )
        {
            return false;
        }
        else {
            i++;
        }
    }
    if ( i > 128 )
    {
        return false;
    }
    return true;
}

int ak_fs_create_dir_for_hash(const char* str)
{
    /* TODO
     * Some aspects of this function
     * 1. We need a "root" place to put our dirs into, this is not specified
     *    anywhere in this code but it is spartially specified in other files
     *    like lib/_ak_fs bash script and the rc/config file we currently source
     *    in $HOME/.bashrc
     * 2. We might need to "lock" onto some version of glibc and be aware of
     *    other systems that do not use that one.
     */
    if ( ak_fs_verify_input_is_hash(str) )
    {
        char* dir_path = ak_fs_return_hash_dir(str);
        // We will need to separate the string so we can create the path one
        // directory at the time
        int len = strlen(dir_path);
        for ( int i = 0; i < len+1; ++i)
        {
            if ( dir_path[i] == '/' )
            {
                //printf("%c\n", dir_path[i]);
                //char* test = strndup(dir_path, i);
                //printf("A: [i:%d] [c:%c] - %s\n", i, dir_path[i], test);
                continue;
            }
            else
            {
                char* incremental_dir_path = strndup(dir_path, i+1);
                // printf("B: [i:%d] [c:%c] - %s\n", i, dir_path[i], test);
                struct stat sb;
                if (stat(incremental_dir_path, &sb) == 0 && S_ISDIR(sb.st_mode))
                {
                    continue;
                }
                else
                {
                    int return_code = mkdir(incremental_dir_path, 0777);
                    if ( return_code == 0 )
                    {
                        continue;
                    }
                    else
                    {
                        // should be unreachable I guess since previous checks
                        // though it could be caused by some other kind of error
                        // like, no permission, or exists but is not a directory
                        // but a file, dev, char, pipe whatever this thing
                        // supports anyway
                        free(incremental_dir_path);
                        free(dir_path);
                        return -3;
                    }
                }
                free(incremental_dir_path);
            }
        }
        free(dir_path);
        return 0;
    }
    else
    {
        return -2;
    }
}

int ak_fs_convert_map_v3_string_to_struct(const char *str, size_t ssize, akfs_map_v3* map)
{
    size_t sa[] = { -1, -1, -1, -1, -1 };
    size_t na[] = { -1, -1, -1 };
    int spaces_found = 0;
    int newlines_found = 0;
    char original_hash_str[129] = {0};
    char root_hash_str[129] = {0};
    char filename[256] = {0};
    if ( map == 0x0 )
    {
        printf("FAILED IN %s! : %p \n", __func__, (void*)map);
        return 1;
    }
    for ( size_t i = 0; i < ssize; ++i)
    {
        if ( str[i] == ' ' )
        {
            spaces_found++;
            sa[spaces_found] = i;
        }
        if ( str[i] == '\n' )
        {
            newlines_found++;
            na[newlines_found] = i;
        }
    }
    int si = 0;
    for ( size_t i = 0; i < sa[1]; ++i)
    {
        original_hash_str[si] = str[i];
        si++;
    }
    original_hash_str[si] = '\0';
    if( !ak_fs_verify_input_is_hash(original_hash_str) )
    {
        ak_log_error(__func__, "original_hash_str not a hash");
        return 1;
    }
    if ( ak_fs_sha512sum_string_to_struct(original_hash_str, &(map->oh)) != 0 )
    {
        ak_log_error(__func__, "String convertion of original_hash_str");
        return 1;
    }
    si = 0;
    for ( size_t i = na[1]+1; i < sa[3]; ++i)
    {
        root_hash_str[si] = str[i];
        si++;
    }
    root_hash_str[si] = '\0';
    if( !ak_fs_verify_input_is_hash(root_hash_str) )
    {
        ak_log_error(__func__, "root_hash_str not a hash");
        return 1;
    }
    if ( ak_fs_sha512sum_string_to_struct(root_hash_str, &(map->rh)) != 0 )
    {
        ak_log_error(__func__, "String convertion of root_hash_str");
        return 1;
    }
    si = 0;
    if ( sa[2] < na[1] )
    {
        for ( size_t i = sa[2]+1; i < na[1]; ++i)
        {
            filename[si] = str[i];
            si++;
        }
        filename[si] = '\0';
    }
    strncpy(map->filename, filename, sizeof(map->filename));
    return 0;
}

void ak_fs_get_available_maps_from_fs(sha512sum **ma, size_t length)
{
    DIR *d;
    d = opendir(ak_fs_maps_v3_get_dir());
    sha512sum *ptr = NULL;
    if (d)
    {
        for ( ptr = *ma; ptr < *ma+length; ++ptr)
        {
            const struct dirent *dir;
            if ((dir = readdir(d)) == NULL ) break;
            if (!ak_fs_verify_input_is_hash(dir->d_name)) continue;
            ak_fs_sha512sum_string_to_struct(dir->d_name, ptr);
        }
    }
    closedir(d);
}

int ak_fs_load_available_maps(sha512sum **ma, size_t ma_len, akfs_map_v3 **ms, size_t ms_len)
{
    sha512sum *ptr = NULL;
    akfs_map_v3 *mptr = NULL;
    mptr = *ms;
    (void)ms_len;
    for ( ptr = *ma; ptr < *ma+ma_len; ++ptr)
    {
        if ( ak_fs_sha512sum_is_null(ptr))
        {
            continue;
        }
        if( ak_fs_open_map_v3_file(ak_fs_sha512sum_struct_read_as_string(ptr), mptr) != 2)
        {
            ++(mptr);
            continue;
        }
        else
        {
            ++(mptr);
            // return 1;
        }
    }
    return 0;
}

void ak_fs_print_loaded_maps(akfs_map_v3 **map_store, size_t length)
{
    akfs_map_v3 *ptr = NULL;
    for ( ptr = *map_store; ptr < *map_store + length; ++ptr)
    {
        if ( !ak_fs_map_v3_is_null(ptr) ) ak_fs_map_v3_print(ptr);
    }
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

void ak_fs_print_available_maps(sha512sum **ma, size_t ma_len)
{
    sha512sum *ptr = NULL;
    for ( ptr = *ma; ptr < *ma+ma_len; ++ptr)
    {
        ak_log_debug(__func__, ak_fs_sha512sum_struct_read_as_string(ptr));
    }

}

void ak_fs_init_string(char *str, size_t len)
{
    for (size_t i = 0; i < len; ++i)
    {
        str[i] = '\0';
    }
}


void ak_fs_print_map_avail(const sha512sum* m)
{
    printf(" .MA: %s\n", ak_fs_sha512sum_struct_read_as_string(m));
}

void ak_fs_print_map_all_avail(sha512sum** m, size_t s)
{
    sha512sum *ptr = NULL;
    for (ptr = *m; ptr < *m+s; ++ptr)
    {
        ak_fs_print_map_avail(ptr);
    }
}

void ak_fs_print_filenames_from_map_store(akfs_map_v3** m, size_t s)
{
    akfs_map_v3 *ptr = NULL;
    for (ptr = *m; ptr < *m+s; ++ptr)
    {
        if ( !ak_fs_map_v3_is_null(ptr) ) ak_fs_map_v3_print_filename(ptr);
    }
}

// char* ak_fs_fuse_list_filenames_from_map_store(akfs_map_v3** m, size_t s)
// {
//     akfs_map_v3 *ptr = NULL;
//     for (ptr = *m; ptr < *m+s; ++ptr)
//     {
//         if ( !ak_fs_map_v3_is_null(ptr) ) ak_fs_map_v3_get_filename(ptr);
//     }
// }

void ak_fs_print_all_maps_from_map_store(akfs_map_v3** m, size_t s)
{
    akfs_map_v3 *ptr = NULL;
    for (ptr = *m; ptr < *m+s; ++ptr)
    {
        if (!ak_fs_map_v3_is_null(ptr)) ak_fs_map_v3_print(ptr);
    }
}

int ak_fs_ls()
{
    size_t ms_len = 100;
    size_t ma_len = 100;
    akfs_map_v3 map_store[ms_len];
    akfs_map_v3* mps_ptr = &map_store[0];
    void* mps_start = &map_store[0];
    (void)mps_start;
    sha512sum maps_avail[ma_len];
    sha512sum *mav_ptr = &maps_avail[0];
    void* mav_start = &map_store[0];
    (void)mav_start;
    ak_fs_map_v3_init_store(&mps_ptr, ms_len);
    ak_fs_sha512sum_init_avail(&mav_ptr, ma_len);
    ak_fs_print_all_maps_from_map_store(&mps_ptr, ms_len);
    ak_fs_get_available_maps_from_fs(&mav_ptr, ma_len);
    ak_fs_load_available_maps(&mav_ptr, ma_len, &mps_ptr, ms_len);
    ak_fs_print_loaded_maps(&mps_ptr, ms_len);
    ak_fs_print_filenames_from_map_store(&mps_ptr, ms_len);
    return 0;
}
