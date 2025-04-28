#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libakfs.h>
#include <libaklog.h>

static void test_correct_string_correct_length()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum hash = {0};
    sha512sum *resulted_hash = &hash;
    ak_fs_sha512sum_string_to_struct(queried_string, resulted_hash);
    char resulted_string[129] = {0};
    ak_fs_sha512sum_struct_to_string(resulted_hash, resulted_string);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) == 0 )
    {
        ak_log_info(__func__, "PASSED");
    }
    else
    {
        ak_log_error(__func__, "FAILED");
    }
}

static void test_bad_string_correct_length()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9az";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum hash = {0};
    sha512sum *resulted_hash = &hash;
    ak_fs_sha512sum_string_to_struct(queried_string, resulted_hash);
    char resulted_string[129] = {0};
    ak_fs_sha512sum_struct_to_string(resulted_hash, resulted_string);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        ak_log_info(__func__, "PASSED");
    }
    else
    {
        ak_log_error(__func__, "FAILED");
    }
}

static void test_less_than_length()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum hash = {0};
    sha512sum *resulted_hash = &hash;
    ak_fs_sha512sum_string_to_struct(queried_string, resulted_hash);
    char resulted_string[129] = {0};
    ak_fs_sha512sum_struct_to_string(resulted_hash, resulted_string);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        ak_log_info(__func__, "PASSED");
    }
    else
    {
        ak_log_error(__func__, "FAILED");
    }
}

static void test_more_than_length()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7aaa";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum hash = {0};
    sha512sum *resulted_hash = &hash;
    ak_fs_sha512sum_string_to_struct(queried_string, resulted_hash);
    char resulted_string[129] = {0};
    ak_fs_sha512sum_struct_to_string(resulted_hash, resulted_string);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        ak_log_info(__func__, "PASSED");
    }
    else
    {
        ak_log_error(__func__, "FAILED");
    }
}

static void test_string_is_empty()
{
    const char *queried_string = "";
    // printf("Hash given:\t%s\n", queried_string);
    //printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum hash = {0};
    sha512sum *resulted_hash = &hash;
    ak_fs_sha512sum_string_to_struct(queried_string, resulted_hash);
    char resulted_string[129] = {0};
    ak_fs_sha512sum_struct_to_string(resulted_hash, resulted_string);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        ak_log_info(__func__, "PASSED");
    }
    else
    {
        ak_log_error(__func__, "FAILED");
    }
}

static void test_hash_path_test()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    const char *resulted_string = ak_fs_return_hash_path(queried_string);
    // printf("Path returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        ak_log_info(__func__, "PASSED");
    }
    else
    {
        ak_log_error(__func__, "FAILED");
    }
}

static void test_hash_dir_test()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    const char *resulted_string = ak_fs_return_hash_dir(queried_string);
    // printf("Path returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        ak_log_info(__func__, "PASSED");
    }
    else
    {
        ak_log_error(__func__, "FAILED");
    }
}

static void test_hash_save_to_file()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum hash = {0};
    sha512sum *resulted_hash = &hash;
    ak_fs_sha512sum_string_to_struct(queried_string, resulted_hash);
    FILE* fd = fopen("tmpfile", "wb");
    if ( fd == NULL )
    {
        printf("Some error occured");
        exit(1);
    }
    fwrite(&resulted_hash, sizeof(sha512sum),1,fd);
    fclose(fd);
    sha512sum readone = {0};
    fd = fopen("tmpfile", "rb");
    if ( fd == NULL )
    {
        printf("Some error occured");
        exit(1);
    }
    fread (&readone, sizeof(sha512sum),1,fd);
    char resulted_string[129] = {0};
    ak_fs_sha512sum_struct_to_string(resulted_hash, resulted_string);
    if ( strcmp(queried_string, resulted_string) == 0 )
    {
        ak_log_debug(__func__, "PASSED");
    }
    else
    {
        ak_log_debug(__func__, "FAILED");
    }
    fclose(fd);
}

static void test_hash_check()
{
    const char *queried_string = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    sha512sum a;
    sha512sum b;
    ak_fs_sha512sum_string_to_struct(queried_string, &a);
    ak_fs_sha512sum_string_to_struct(queried_string, &b);
    if ( ak_fs_sha512sum_compare(&a,&b) )
    {
        ak_log_debug(__func__, "PASSED");
    }
    else
    {
        ak_log_debug(__func__, "FAILED");
    }
}

static void test_map_opener()
{
    akfs_map_v3 map;
    ak_fs_map_v3_init(&map);
    char *map_string = "28bde5fa7aacd8da0ec84b61cf3a69141686906c00f8cff904c9a0b12f5a4cf061da254feb188c32b711b2e1d6a3853d5ac3fb0bcd3564899bae55dd30470392";
    ak_fs_sha512sum_string_to_struct(map_string, &(map.mh));
    if ( ak_fs_map_v3_open_from_file(&map) != 0 )
    {
        ak_log_debug(__func__, "FAILED");
        return;
    }
    const char *orig_string = "fa19bdc471bedc42abf3ff52069214bc7339a7eafc03f8551e8af892a0e3ce175cff0dde6f815da031cd0566fded455c937f7cae27181f7a90ab92e6131ba2be";
    const char *root_string = "438aebe24c89d36f84a68ea29327b27af1abc05f8f85e69af650159c4928834bd6fd2b3df690de74d42f861a8dbe30cebc6cba6afe07fabb1066d1380cd3adea";
    const char *filename = "mixtapes-v0.0.0.tar.gz";
    // printf("%s\n",ak_fs_sha512sum_struct_read_as_string((const sha512sum*)&(map.mh)));
    // printf("%s\n",ak_fs_sha512sum_struct_read_as_string((const sha512sum*)&(map.oh)));
    // printf("%s\n",ak_fs_sha512sum_struct_read_as_string((const sha512sum*)&(map.rh)));
    // printf("%s\n",map.filename);

    ak_fs_map_v3_print(&map);
    ak_fs_map_v3_print_as_json(&map);

    if (
        (strcmp(map_string,  ak_fs_sha512sum_struct_read_as_string(&(map.mh)))!=0) ||
        (strcmp(orig_string, ak_fs_sha512sum_struct_read_as_string(&(map.oh)))!=0) ||
        (strcmp(root_string, ak_fs_sha512sum_struct_read_as_string(&(map.rh)))!=0) ||
        (strcmp(filename, map.filename)!=0))
    {
        ak_log_debug(__func__, "FAILED");
        return;
    }
    else
    {
        ak_log_debug(__func__, "PASSED");
        return;
    }
}

static void test_ak_fs_ls()
{
    ak_log_test(__func__, ".....=====.....");
    // size_t len = ak_fs_maps_v3_found_in_fs();
    // akfs_map_v3 map_store[len];
    // akfs_map_v3* mps_ptr = &map_store[0];
    // void* mps_start = &map_store[0];
    // (void)mps_start;
    // ak_fs_map_v3_init_store(&mps_ptr, len);

    // // TODO Rename the following to "ak_fs_resolve_map_v3_array" or close to it
    // ak_fs_map_v3_resolve_maps(&mps_ptr, len);

    // // TODO Decide what we should be printing
    // // Possibly, something like "maphex(6)_filename" so we can put multiple
    // // files with the same name into the list
    // ak_fs_maps_v3_print(&mps_ptr, len);
    // ak_fs_print_filenames_from_map_store(&mps_ptr, len);
    ak_fs_ls();
    // ak_log_test(__func__, ".....=END=.....");
}


int main(void)
{
    // Correct one
    test_correct_string_correct_length();

    // Supposingly a bad string but in correct length
    test_bad_string_correct_length();

    // Less than must be length
    test_less_than_length();

    // More than must be length
    test_more_than_length();

    // Empty string
    test_string_is_empty();

    // Hash path
    test_hash_path_test();

    // Hash dir
    test_hash_dir_test();

    // Tempfile test read-write
    test_hash_save_to_file();

    // Hash checking
    test_hash_check();

    // Map file opener
    test_map_opener();

    // Test ak_fs_ls
    test_ak_fs_ls();
    printf("%lu\n", (unsigned long)sizeof(sha512sum));
    printf("%lu\n", (unsigned long)sizeof(akfs_map_v3));
    printf("%lu\n", (unsigned long)sizeof(akfs_map_v4));
    return 0;
}
