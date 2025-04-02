#ifndef AKFS
#define AKFS

#include <stdbool.h>

/**
 * This struct represents a HEX output of the SHA-512 algorithm.
 *
 */
typedef struct {
    /**
     * The array below has size of 8, which can store the 128 characters into
     * 16 digit length variables.
     *
     * While 512bits/8bits=64bytes, into converting to characters, we use 2bytes
     * per one digit, which gives us the 128 characters.
     *
     */
    long unsigned int sum[8];
} sha512sum;

/**
 * This struct describes explicitly the structure of a root_hash. It is the root
 * of a hash merkle tree. Note, that this structure can be used for roots and
 * branches. Possibly, the name will change to something more generic in the
 * future.
 * Another note is that instead of approaching this as left and right, as seen
 * in other codebases, we do a head-tail naming. That's because of the BASH
 * implementation that you can find at lib/_ak_fs.
 *
 */
typedef struct {
    /**
     * Hash of the thing
     */
    sha512sum root;
    /**
     * Hash of head
     */
    sha512sum head;
    /**
     * Hash of tail
     */
    sha512sum tail;
} root_hash;

/**
 * This is the current structure of an akfs_map. Due to potential short-comings
 * of it, akfs_map_v4 was introduced. Versions v1 and v2 won't be appearing in
 * this header file, since they were long abandoned. Version v0, on the other
 * hand, is what is called now as a root_hash. Refer to it for more.
 *
 */
typedef struct {
    /**
     * Original file's hash
     *
     */
    sha512sum oh;
    /**
     * Original file's name
     *
     */
    char* filename;
    /**
     * Root hash
     *
     */
    sha512sum rh;
    /**
     * Should be "level.1.map" at all times
     *
     */
    char* root_name;
} akfs_map_v3;

/**
 * This is a proposed structure for akfs_map. It is called after its version.
 * Previous versions have been mostly abandoned, except v3 which is where v4
 * was derived from. See akfs_map_v3 for more.
 *
 */
typedef struct {
    /**
     * Original file's hash
     *
     */
    sha512sum oh;
    /**
     * Original filename's AKFS maphash
     *
     */
    sha512sum fn;
    /**
     * Root hash
     *
     */
    sha512sum rh;
} akfs_map_v4;

//typedef char[64] sha512sum_as_string;

char* ak_fs_return_hash_path(char*);

char* ak_fs_return_hash_dir(char*);

bool ak_fs_verify_input_is_hash(char*);

int ak_fs_create_dir_for_hash(char*);

sha512sum ak_fs_sha512sum_string_to_struct(char*);

void ak_fs_sha512sum_struct_to_string(sha512sum, char*);

int ak_fs_open_map_v3(char*);
int ak_fs_from_map_v3_to_file(akfs_map_v3);

#endif // AKFS

