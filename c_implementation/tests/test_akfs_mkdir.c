#include <stdio.h>
#include <libakfs.h>

static void test_non_hash_string()
{
    char *path = "tes";
    int ec = ak_fs_create_dir_for_hash(path);
    printf("mkdir return code: %d\n", ec);
    path = "tes/t";
    ec = ak_fs_create_dir_for_hash(path);
    printf("mkdir return code: %d\n", ec);
}

static void test_hash_string()
{
    char *path = "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff";
    int ec = ak_fs_create_dir_for_hash(path);
    printf("mkdir return code: %d\n", ec);
}

static void test_hash_string2()
{
    char *path = "ee2ab0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff";
    int ec = ak_fs_create_dir_for_hash(path);
    printf("mkdir return code: %d\n", ec);
}

static void test_hash_string3()
{
    char *path = "ee2ab0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a800";
    int ec = ak_fs_create_dir_for_hash(path);
    printf("mkdir return code: %d\n", ec);
}

int main()
{
    test_non_hash_string();
    test_hash_string();
    test_hash_string2();
    test_hash_string3();
    return 0;
}
