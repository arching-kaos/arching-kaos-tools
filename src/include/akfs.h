#ifndef AKFS
#define AKFS

#include <stdbool.h>

typedef struct {
    long unsigned int sum[8];
} sha512sum;

//typedef char[64] sha512sum_as_string;

char* ak_fs_return_hash_path(char*);

char* ak_fs_return_hash_dir(char*);

bool ak_fs_verify_input_is_hash(char*);

int ak_fs_create_dir_for_hash(char*);

sha512sum ak_fs_sha512sum_string_to_struct(char*);

char* ak_fs_sha512sum_struct_to_string(sha512sum);

#endif // AKFS

