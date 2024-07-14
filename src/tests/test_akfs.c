#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <akfs.h>

void correct_string_correct_length()
{
    printf("%s\t", __func__);
    char queried_string[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum resulted_hash = ak_fs_sha512sum_string_to_struct(queried_string);
    char* resulted_string = ak_fs_sha512sum_struct_to_string(resulted_hash);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) == 0 )
    {
        printf("PASS!\n");
    }
    else
    {
        printf("NO PASS :(\n");
    }
    free(resulted_string);
}

void bad_string_correct_length()
{
    printf("%s\t", __func__);
    char queried_string[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9az";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum resulted_hash = ak_fs_sha512sum_string_to_struct(queried_string);
    char* resulted_string = ak_fs_sha512sum_struct_to_string(resulted_hash);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        printf("PASS!\n");
    }
    else
    {
        printf("NO PASS :(\n");
    }
    free(resulted_string);
}

void less_than_length()
{
    printf("%s\t", __func__);
    char queried_string[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum resulted_hash = ak_fs_sha512sum_string_to_struct(queried_string);
    char* resulted_string = ak_fs_sha512sum_struct_to_string(resulted_hash);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        printf("\tPASS!\n");
    }
    else
    {
        printf("\tNO PASS :(\n");
    }
    free(resulted_string);
}

void more_than_length()
{
    printf("%s\t", __func__);
    char queried_string[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7aaa";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum resulted_hash = ak_fs_sha512sum_string_to_struct(queried_string);
    char* resulted_string = ak_fs_sha512sum_struct_to_string(resulted_hash);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        printf("\tPASS!\n");
    }
    else
    {
        printf("\tNO PASS :(\n");
    }
    free(resulted_string);
}

void string_is_empty()
{
    printf("%s\t", __func__);
    char queried_string[128] = "";
    // printf("Hash given:\t%s\n", queried_string);
    //printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum resulted_hash = ak_fs_sha512sum_string_to_struct(queried_string);
    char* resulted_string = ak_fs_sha512sum_struct_to_string(resulted_hash);
    // printf("Hash returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        printf("\t\tPASS!\n");
    }
    else
    {
        printf("\t\tNO PASS :(\n");
    }
    free(resulted_string);
}

void hash_path_test()
{
    printf("%s\t", __func__);
    char queried_string[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    char* resulted_string = ak_fs_return_hash_path(queried_string);
    // printf("Path returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        printf("\t\tPASS!\n");
    }
    else
    {
        printf("\t\tNO PASS :(\n");
    }
    free(resulted_string);
}

void hash_dir_test()
{
    printf("%s\t", __func__);
    char queried_string[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    char* resulted_string = ak_fs_return_hash_dir(queried_string);
    // printf("Path returned:\t%s\n", resulted_string);
    if ( strcmp(queried_string, resulted_string) != 0 )
    {
        printf("\t\tPASS!\n");
    }
    else
    {
        printf("\t\tNO PASS :(\n");
    }
    free(resulted_string);
}

void hash_save_to_file()
{
    printf("%s\t", __func__);
    char queried_string[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
    // printf("Hash given:\t%s\n", queried_string);
    // printf("Is a hash: %s\n", ak_fs_verify_input_is_hash(queried_string) ? "true": "false");
    sha512sum resulted_hash = ak_fs_sha512sum_string_to_struct(queried_string);
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
    char* resulted_string = ak_fs_sha512sum_struct_to_string(readone);

    if ( strcmp(queried_string, resulted_string) == 0 )
    {
        printf("\tPASS!\n");
    }
    else
    {
        printf("\tNO PASS :(\n");
    }
    fclose(fd);
    free(resulted_string);
}

int main(void)
{
    // Correct one
    correct_string_correct_length();

    // Supposingly a bad string but in correct length
    bad_string_correct_length();

    // Less than must be length
    less_than_length();

    // More than must be length
    more_than_length();

    // Empty string
    string_is_empty();

    // Hash path
    hash_path_test();

    // Hash dir
    hash_dir_test();

    // Tempfile test read-write
    hash_save_to_file();
    return 0;
}
