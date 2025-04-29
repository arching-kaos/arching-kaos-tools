#include <stdio.h>
#include <libakfs.h>
#include <libaklog.h>
#include <stdbool.h>

bool ak_fs_mt_branch_is_null(mt_branch* node)
{
    if ( node == NULL )
    {
        ak_log_warning(__func__, "A NULL mt_branch* node was given");
        return false;
    }
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
    if ( a == NULL || b == NULL )
    {
        ak_log_warning(__func__, "One or two NULL mt_branch* node was given");
        return false;
    }
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

void ak_fs_mt_branch_print(mt_branch *n)
{
    printf("r: %s\n", ak_fs_sha512sum_struct_read_as_string(&n->root));
    printf("h: %s\n", ak_fs_sha512sum_struct_read_as_string(&n->head));
    printf("t: %s\n", ak_fs_sha512sum_struct_read_as_string(&n->tail));
}
