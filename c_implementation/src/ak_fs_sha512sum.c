#include <libakfs.h>
#include <libaklog.h>
#include <stdlib.h>
#include <assert.h>

void ak_fs_sha512sum_init(sha512sum *hash)
{
    for (int i = 0; i < 8; ++i)
    {
        hash->sum[i] = 0x0;
    }
}

bool ak_fs_sha512sum_compare(const sha512sum* a, const sha512sum* b)
{
    for ( int i = 0; i < 8; ++i )
    {
        if ( a->sum[i] != b->sum[i] ) return false;
    }
    return true;
}

void ak_fs_sha512sum_reset_struct(sha512sum* m)
{
    for (size_t i = 0; i < 8; ++i)
    {
        m->sum[i] = 0;
    }
}

void ak_fs_sha512sum_init_avail(sha512sum** m, size_t s)
{
    sha512sum *ptr = NULL;
    for (ptr = *m; ptr < *m+s; ++m)
    {
        ak_fs_sha512sum_reset_struct(ptr);
    }
}

char* ak_fs_sha512sum_struct_read_as_string(const sha512sum *ptr)
{
    char *str = malloc(129*sizeof(char));
    ak_fs_sha512sum_struct_to_string(ptr, str);
    ak_log_debug(__func__, str);
    return str;
}

bool ak_fs_sha512sum_is_null(const sha512sum *h)
{
    sha512sum n;
    ak_fs_sha512sum_init(&n);
    return ak_fs_sha512sum_compare(h,&n);
}

int ak_fs_sha512sum_string_to_struct(const char* str, sha512sum* hash)
{
    if ( ak_fs_verify_input_is_hash(str) )
    {
        for (size_t l = 0; l < 8; ++l)
        {
            hash->sum[l]=0;
        }
        unsigned int i = 0;
        unsigned int j = 0;
        unsigned int k = 4;
        while ( str[i] != '\0' )
        {
            assert( i < 128  && "Length exceeded limit");
            if ( i % 16 == 0 ) j = i / 16;
            switch (str[i])
            {
                case 0x30:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x0;
                    break;
                case 0x31:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x1;
                    break;
                case 0x32:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x2;
                    break;
                case 0x33:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x3;
                    break;
                case 0x34:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x4;
                    break;
                case 0x35:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x5;
                    break;
                case 0x36:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x6;
                    break;
                case 0x37:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x7;
                    break;
                case 0x38:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x8;
                    break;
                case 0x39:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0x9;
                    break;
                case 0x61:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0xa;
                    break;
                case 0x62:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0xb;
                    break;
                case 0x63:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0xc;
                    break;
                case 0x64:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0xd;
                    break;
                case 0x65:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0xe;
                    break;
                case 0x66:
                    hash->sum[j] = hash->sum[j] << k;
                    hash->sum[j] += 0xf;
                    break;
                default:
                    assert(0 && "Character out of range");
            }
            i++;
        }
        if ( i != 128 )
        {
            return 1;
        }
        return 0;
    }
    else
    {
        return 0;
    }
}

void ak_fs_sha512sum_struct_to_string(const sha512sum* hash, char* str)
{
	int count = 0;
    sha512sum lhash = *hash;
    for (size_t i = 0; i < 8; ++i)
    {
        for (size_t j = 0; j < 16; ++j)
        {
            long unsigned first = lhash.sum[i]/0xfffffffffffffff;
            switch(first){
                case 0:
                    str[count] = '0';
                    break;
                case 1:
                    str[count] = '1';
                    break;
                case 2:
                    str[count] = '2';
                    break;
                case 3:
                    str[count] = '3';
                    break;
                case 4:
                    str[count] = '4';
                    break;
                case 5:
                    str[count] = '5';
                    break;
                case 6:
                    str[count] = '6';
                    break;
                case 7:
                    str[count] = '7';
                    break;
                case 8:
                    str[count] = '8';
                    break;
                case 9:
                    str[count] = '9';
                    break;
                case 0xa:
                    str[count] = 'a';
                    break;
                case 0xb:
                    str[count] = 'b';
                    break;
                case 0xc:
                    str[count] = 'c';
                    break;
                case 0xd:
                    str[count] = 'd';
                    break;
                case 0xe:
                    str[count] = 'e';
                    break;
                case 0xf:
                    str[count] = 'f';
                    break;
                default:
                    assert(0 && "Should be unreachable");
            }
            count++;
            lhash.sum[i] = lhash.sum[i] << 4;
        }
    }
    str[128] = '\0';
}

