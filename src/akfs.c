#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <akfs.h>
#include <sys/stat.h>

char* ak_fs_return_hash_path(char* string)
{
    if ( ak_fs_verify_input_is_hash(string) )
    {
        unsigned int i = 0;
        char *result = malloc((128*2)+1);
        while ( string[i] != '\0' )
        {
            result[i*2] = string[i];
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

char* ak_fs_return_hash_dir(char* string)
{
    if ( ak_fs_verify_input_is_hash(string) )
    {
        unsigned int i = 0;
        char *result = malloc((128*2)+1);
        while ( string[i] != '\0' )
        {
            result[i*2] = string[i];
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

bool ak_fs_verify_input_is_hash(char* string)
{
    unsigned int i = 0;
    while ( string[i] != '\0' )
    {
        if (
                i < 128 &&
                !(
                    ( string[i] >= 0x30 ) &&
                    (( string[i] <= 0x39) || ( string[i] >= 0x61 )) &&
                    ( string[i] <= 0x66 )
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

int ak_fs_create_dir_for_hash(char* string)
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
    if ( ak_fs_verify_input_is_hash(string) )
    {
        char* dir_path = ak_fs_return_hash_dir(string);
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
        //printf("%d\n", len);
        //printf("%s\n", dir_path);
        //const char *pathname = dir_path;
        //int ec = mkdir(pathname, 0777);
        //return ec;
        free(dir_path);
        return 0;
    }
    else
    {
        return -2;
    }
}

sha512sum ak_fs_sha512sum_string_to_struct(char* string)
{
    sha512sum hash = {0};
    if ( ak_fs_verify_input_is_hash(string) )
    {
        for (size_t l = 0; l < 8; ++l)
        {
            hash.sum[l]=0;
        }
        unsigned int i = 0;
        unsigned int j = 0;
        unsigned int k = 4;
        while ( string[i] != '\0' )
        {
            assert( i < 128  && "Length exceeded limit");
            if ( i % 16 == 0 ) j = i / 16;
            switch (string[i])
            {
                case 0x30:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x0;
                    break;
                case 0x31:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x1;
                    break;
                case 0x32:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x2;
                    break;
                case 0x33:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x3;
                    break;
                case 0x34:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x4;
                    break;
                case 0x35:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x5;
                    break;
                case 0x36:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x6;
                    break;
                case 0x37:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x7;
                    break;
                case 0x38:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x8;
                    break;
                case 0x39:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0x9;
                    break;
                case 0x61:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0xa;
                    break;
                case 0x62:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0xb;
                    break;
                case 0x63:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0xc;
                    break;
                case 0x64:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0xd;
                    break;
                case 0x65:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0xe;
                    break;
                case 0x66:
                    hash.sum[j] = hash.sum[j] << k;
                    hash.sum[j] += 0xf;
                    break;
                default:
                    assert(0 && "Character out of range");
            }
            i++;
        }
        if ( i != 128 )
        {
            sha512sum hash0 = {0};
            return hash0;
        }
        return hash;
    }
    else
    {
        return hash;
    }
}

void ak_fs_sha512sum_struct_to_string(sha512sum hash, char* string)
{
	int counter = 0;
    for (size_t i = 0; i < 8; ++i)
    {
        for (size_t j = 0; j < 16; ++j)
        {
            long unsigned first = hash.sum[i]/0xfffffffffffffff;
            switch(first){
                case 0:
                    string[counter] = '0';
                    break;
                case 1:
                    string[counter] = '1';
                    break;
                case 2:
                    string[counter] = '2';
                    break;
                case 3:
                    string[counter] = '3';
                    break;
                case 4:
                    string[counter] = '4';
                    break;
                case 5:
                    string[counter] = '5';
                    break;
                case 6:
                    string[counter] = '6';
                    break;
                case 7:
                    string[counter] = '7';
                    break;
                case 8:
                    string[counter] = '8';
                    break;
                case 9:
                    string[counter] = '9';
                    break;
                case 0xa:
                    string[counter] = 'a';
                    break;
                case 0xb:
                    string[counter] = 'b';
                    break;
                case 0xc:
                    string[counter] = 'c';
                    break;
                case 0xd:
                    string[counter] = 'd';
                    break;
                case 0xe:
                    string[counter] = 'e';
                    break;
                case 0xf:
                    string[counter] = 'f';
                    break;
                default:
                    assert(0 && "Should be unreachable");
            }
            counter++;
            hash.sum[i] = hash.sum[i] << 4;
        }
    }
    string[128] = '\0';
}
