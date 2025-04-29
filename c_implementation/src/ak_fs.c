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

char* ak_fs_return_hash_path(const char* str)
{
    if ( ak_fs_verify_input_is_hash(str, strlen(str)) )
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
    if ( ak_fs_verify_input_is_hash(str, strlen(str)) )
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

bool ak_fs_verify_input_is_hash(const char* str, size_t len)
{
    size_t i = 0;
    if (len != 128)
    {
        return false;
    }
    while ( str[i] != '\0' )
    {
        if (
                i < 128 &&
                !(
                    ( str[i] >= 0x30 ) &&
                    ( str[i] <= 0x39 || str[i] >= 0x61 ) &&
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
    if ( ak_fs_verify_input_is_hash(str, strlen(str)) )
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
            sa[++spaces_found] = i;
        }
        if ( str[i] == '\n' )
        {
            na[++newlines_found] = i;
        }
    }
    int si = 0;
    for ( size_t i = 0; i < sa[1]; ++i)
    {
        original_hash_str[si] = str[i];
        si++;
    }
    original_hash_str[si] = '\0';
    if( !ak_fs_verify_input_is_hash(original_hash_str, strlen(original_hash_str)) )
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
    if( !ak_fs_verify_input_is_hash(root_hash_str, strlen(root_hash_str)) )
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

void ak_fs_maps_v3_get_from_fs(akfs_map_v3 **ma, size_t length)
{
    (void)length;
    DIR *d;
    d = opendir(ak_fs_maps_v3_get_dir());
    akfs_map_v3 *ptr = NULL;
    ptr = *ma;
    if (d)
    {
        const struct dirent *dir;
        while((dir = readdir(d)) != NULL )
        {
            if (!ak_fs_verify_input_is_hash(dir->d_name, 128)) continue;
            ak_fs_sha512sum_string_to_struct(dir->d_name, &(ptr->mh));
            ++ptr;
        }
    }
    closedir(d);
}

void ak_fs_init_string(char *str, size_t len)
{
    for (size_t i = 0; i < len; ++i)
    {
        str[i] = '\0';
    }
}

int ak_fs_ls()
{
    size_t len = ak_fs_maps_v3_found_in_fs();
    akfs_map_v3 map_store[len];
    akfs_map_v3* maps_ptr = &map_store[0];
    ak_fs_maps_v3_init(&maps_ptr, len);
    ak_fs_maps_v3_get_from_fs(&maps_ptr, len);
    ak_fs_maps_v3_resolve(&maps_ptr, len);
    ak_fs_maps_v3_print_bif(&maps_ptr, len);
    return 0;
}

int ak_fs_cat_file_from_root_hash(sha512sum* rh)
{
    const char* chunks_dir = getenv("AK_CHUNKSDIR");
    const char* leafs_dir = getenv("AK_LEAFSDIR");
    FILE *fd;
    char *fullpath;
    bool is_chunk = false;
    if ( asprintf(&fullpath, "%s/%s", leafs_dir, ak_fs_sha512sum_struct_read_as_string(rh))  == -1 ) return -1;
    fd = fopen(fullpath, "r");
    if ( fd == NULL )
    {
        // perror("fopen");
        if ( asprintf(&fullpath, "%s/%s", chunks_dir, ak_fs_sha512sum_struct_read_as_string(rh)) == -1 ) return -1;
        fd = fopen(fullpath, "r");
        if ( fd == NULL )
        {
            ak_log_error(__func__, "Could not be found");
            return 1;
        }
        is_chunk = true;
    }
    if ( !is_chunk )
    {
        char buffer[258];
        fread(&buffer, sizeof(buffer), 1, fd);
        fclose(fd);
        char h1[129] = {0};
        char h2[129] = {0};
        if ( buffer[128] != '\n' && buffer[257] != '\n' )
        {
            ak_log_error(__func__, "Unknown format");
            return 2;
        }
        mt_branch h0;
        ak_fs_sha512sum_init(&h0.root);
        ak_fs_sha512sum_init(&h0.head);
        ak_fs_sha512sum_init(&h0.tail);
        h0.root = *rh;
        for( size_t i = 0; i < 128; ++i )
        {
            h1[i] = buffer[i];
        }
        h1[128] = '\0';
        for( size_t i = 0; i < 128; ++i )
        {
            h2[i] = buffer[i+129];
        }
        h2[128] = '\0';
        ak_fs_sha512sum_string_to_struct(h1, &h0.head);
        ak_fs_sha512sum_string_to_struct(h2, &h0.tail);
        ak_fs_cat_file_from_root_hash(&h0.head);
        if ( !ak_fs_sha512sum_compare(&h0.head, &h0.tail) ) ak_fs_cat_file_from_root_hash(&h0.tail);
        // ak_fs_mt_branch_resolve(&h0);
    }
    else
    {
        struct stat sb;
        if (stat(fullpath, &sb) == -1) {
            perror("stat");
            fclose(fd);
            return 2;
        }
        // File size: %lld in bytes: (long long) sb.st_size);
        char buffer[(long long) sb.st_size+1];
        fread(&buffer, sizeof(buffer), 1, fd);
        fclose(fd);
        buffer[sizeof(buffer)-1] = '\0';
        printf("%s", buffer);
    }
    // ak_log_debug(__func__, ak_fs_sha512sum_struct_read_as_string(&h0.root));
    // ak_log_debug(__func__, ak_fs_sha512sum_struct_read_as_string(&h0.head));
    // ak_log_debug(__func__, ak_fs_sha512sum_struct_read_as_string(&h0.tail));
    // if ( ak_fs_verify_input_is_hash(h1, strlen(h1))) printf("head:\n%s\n---\n", h1);
    // if ( ak_fs_verify_input_is_hash(h2, strlen(h2))) printf("tail:\n%s\n---\n", h2);
    return 0;
}

int ak_fs_cfm(akfs_map_v3* map)
{
    sha512sum x;
    ak_fs_sha512sum_init(&x);
    x = *(ak_fs_map_v3_get_root_hash(map));
    // printf("%s\n", ak_fs_sha512sum_struct_read_as_string(&x));
    ak_fs_cat_file_from_root_hash(&x);
    return 0;
}
