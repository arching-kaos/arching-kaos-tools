#ifndef AKFS
#define AKFS

#include <stdbool.h>
#include <stddef.h>

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
    char filename[256];
    /**
     * Root hash
     *
     */
    sha512sum rh;
    /**
     * Map hash
     *
     */
    sha512sum mh;
    /**
     * Should be "level.1.map" at all times
     *
     */
    char *root_name;
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
    /**
     * Map hash
     *
     */
    sha512sum mh;
} akfs_map_v4;

/**
 * Gets maps_dir
 * return char*
 */
const char* ak_fs_maps_v3_get_dir();

/**
 * Experimental
 */
char* ak_fs_return_hash_path(const char*);

/**
 * Experimental
 */
char* ak_fs_return_hash_dir(const char*);

/**
 * Verify that string looks like a SHA512 hash
 *
 * param char* string to be checked
 * returns boolean
 */
bool ak_fs_verify_input_is_hash(const char*, size_t);

/**
 * Unused
 */
int ak_fs_create_dir_for_hash(const char*);

/**
 * Converts string hash to struct
 * @param char*      Hash as string
 * @param sha512sum* Pointer to a sha512sum
 * @returns int      Status of exit
 */
int ak_fs_sha512sum_string_to_struct(const char*, sha512sum*);

/**
 * Returns struct from string hash
 * @param char*        Hash as string
 * @returns sha512sum* Pointer to a sha512sum
 */
sha512sum* ak_fs_sha512sum_from_string(char*);

/**
 * Converts hash struct to string
 */
void ak_fs_sha512sum_struct_to_string(const sha512sum*, char*);

/**
 * Opens a map file to an akfs_map_v3 struct
 */
int ak_fs_map_v3_open_from_file(akfs_map_v3*);

/**
 * Prints filenames from a map_store
 */
void ak_fs_print_filenames_from_map_store(akfs_map_v3**, size_t);

/**
 * Unused
 */
int ak_fs_map_v3_to_file(akfs_map_v3);

/**
 * Unused
 */
int ak_fs_convert_map_v3_string_to_struct(const char *, size_t, akfs_map_v3*);

/**
 * Unused
 */
void ak_fs_map_v3_print_map_hash(akfs_map_v3*);

/**
 * Unused
 */
void ak_fs_map_v3_print_original_hash(akfs_map_v3*);

/**
 * Unused
 */
void ak_fs_map_v3_print_root_hash(akfs_map_v3*);

/**
 * Unused
 */
void ak_fs_map_v3_print_filename(akfs_map_v3*);

/**
 * Unused
 */
void ak_fs_maps_v3_print_filenames(akfs_map_v3**, size_t);

void ak_fs_maps_v3_print_as_json(akfs_map_v3**, size_t);
void ak_fs_map_v3_print_as_json(akfs_map_v3*);
void ak_fs_maps_v3_print_bif(akfs_map_v3**, size_t);
void ak_fs_map_v3_print_bif(akfs_map_v3*);

/**
 * Unused
 */
void ak_fs_map_v3_print(akfs_map_v3*);

/**
 * Takes an array of sha512sums (maps) and puts it in an array of maps (v3)
 */
int ak_fs_maps_v3_resolve(akfs_map_v3**, size_t);

/**
 * Unused
 */
void ak_fs_print_available_maps(sha512sum**, size_t);

/**
 * Unused
 */
void ak_fs_maps_v3_print(akfs_map_v3**, size_t);

/**
 * Reads maps_dir and outputs it in an array of sha512sum
 */
void ak_fs_prepare_available_maps(sha512sum**, size_t);

/**
 * Unused
 */
void ak_fs_get_available_maps_from_fs(sha512sum**, size_t);

/**
 * Unused
 */
void ak_fs_print_map_all_avail(sha512sum**, size_t);

/**
 * Unused
 */
char* ak_fs_sha512sum_struct_read_as_string(const sha512sum *);

/**
 * Unused
 */
void ak_fs_init_string(char *, size_t );

/**
 * Unused
 */
bool ak_fs_sha512sum_compare(const sha512sum*, const sha512sum*);
/**
 * Unused
 */
bool ak_fs_sha512sum_is_null(const sha512sum*);
/**
 * Unused
 */
void ak_fs_sha512sum_init(sha512sum*);
/**
 * Unused
 */
void ak_fs_sha512sum_init_avail(sha512sum**, size_t);

/**
 * Initialize an akfs_map_v3
 */
void ak_fs_map_v3_init(akfs_map_v3*);

/**
 * Initializes an array of akfs_map_v3
 */
void ak_fs_maps_v3_init(akfs_map_v3**, size_t);

/**
 * returns: boolean
 * param: akfs_map_v3
 */
bool ak_fs_map_v3_is_null(akfs_map_v3*);
/**
 * Unused
 */
char* ak_fs_map_v3_get_filename(akfs_map_v3*);
/**
 * Unused
 */
sha512sum* ak_fs_map_v3_get_map_hash(akfs_map_v3*);
/**
 * Unused
 */
sha512sum* ak_fs_map_v3_get_root_hash(akfs_map_v3*);
/**
 * Gets original hash out of the akfs_map_v3
 * param: akfs_map_v3
 * return: pointer to sha512sum
 */
sha512sum* ak_fs_map_v3_get_orig_hash(akfs_map_v3*);
/**
 * Unused
 */
bool ak_fs_map_v3_compare(akfs_map_v3*, akfs_map_v3*);

/**
 * Initializes an array of akfs_map_v4
 */
void ak_fs_init_map_v4_store(akfs_map_v4**, size_t);


/**
 * Unused
 */
void ak_fs_map_v4_init(akfs_map_v4*);

/**
 * Initializes an array of sha512sum
 */
void ak_fs_init_map_avail(sha512sum**, size_t);


/**
 * Unused
 */
bool ak_fs_map_v4_compare(akfs_map_v4*, akfs_map_v4*);
/**
 * Unused
 */
bool ak_fs_map_v4_is_null(akfs_map_v4*);
/**
 * Unused
 */
char* ak_fs_map_v4_get_filename(akfs_map_v4*);
/**
 * Unused
 */
sha512sum* ak_fs_map_v4_get_map_hash(akfs_map_v4*);
/**
 * Unused
 */
sha512sum* ak_fs_map_v4_get_root_hash(akfs_map_v4*);
/**
 * Unused
 */
sha512sum* ak_fs_map_v4_get_orig_hash(akfs_map_v4*);

/**
 * Returns number of files found in maps fs location
 */
size_t ak_fs_maps_v3_found_in_fs();

/**
 * Prints a list of the maps (version 3 format) available on the local fs along
 * with their root hash and file name.
 * @returns int Status value
 *
 */
int ak_fs_ls();

/**
 * Main function for call from other programs
 * @returns: status
 */
int ak_fs_main(int, char**);

#endif // AKFS

