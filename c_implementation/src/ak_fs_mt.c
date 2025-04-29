#include <stdio.h>
#include <libakfs.h>
#include <stdlib.h>

bool ak_fs_mt_branch_is_null(mt_branch* node)
{
    if (
            ak_fs_sha512sum_is_null(&node->root) &&
            ak_fs_sha512sum_is_null(&node->head) &&
            ak_fs_sha512sum_is_null(&node->tail)
       )
    {
        return true;
    }
    return false;
}

bool ak_fs_mt_branch_compare(mt_branch *a, mt_branch *b)
{
    if (
            ak_fs_sha512sum_compare(&a->root, &b->root) &&
            ak_fs_sha512sum_compare(&a->head, &b->head) &&
            ak_fs_sha512sum_compare(&a->tail, &b->tail)
       )
    {
        return true;
    }
    return false;
}

int ak_fs_mt_branch_resolve(mt_branch *node)
{
    const char* leafs_dir = getenv("AK_LEAFSDIR");
    FILE *fd;
    char *fullpath;
    asprintf(&fullpath, "%s/%s", leafs_dir, ak_fs_sha512sum_struct_read_as_string(&node->head));
    fd = fopen(fullpath, "r");
    if ( fd == NULL )
    {
        perror("fopen");
        return 1;
    }
    char buffer[258];
    fread(&buffer, sizeof(buffer), 1, fd);
    fclose(fd);
    char h1[129] = {0};
    char h2[129] = {0};
    if ( buffer[128] == '\n' && buffer[257] == '\n' ) printf("\\n found on the expected spot!\n");
    mt_branch h0;
    ak_fs_sha512sum_init(&h0.root);
    ak_fs_sha512sum_init(&h0.head);
    ak_fs_sha512sum_init(&h0.tail);
    h0.root = node->root;
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
    ak_fs_mt_branch_resolve(&h0);
    return 0;
}
