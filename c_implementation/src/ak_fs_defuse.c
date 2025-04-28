#define FUSE_USE_VERSION 31
#include <fuse3/fuse.h>
#include <libakfs.h>
#include <libaklog.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

// Called when a file is read
static int akfs_fuse_read(const char *path, char *buf, size_t size, off_t offset,
		struct fuse_file_info *fi)
{
	(void) fi;  // Unused
	const char *content = "Hello, World!\n";
	size_t len = strlen(content);

	if (strcmp(path, "/hello") != 0)  // Only support "/hello"
		return -ENOENT;

    if (offset < 0 || (size_t)offset >= len)
		return 0;

	size = (size < len - offset) ? size : len - offset;
	memcpy(buf, content + offset, size);
	return size;
}

// Called to list files in the root directory
static int akfs_fuse_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
		off_t offset, struct fuse_file_info *fi,
		enum fuse_readdir_flags flags)
{
	(void) offset; (void) fi; (void) flags;  // Unused

	if (strcmp(path, "/") != 0)  // Only support root dir
		return -ENOENT;

	filler(buf, ".", NULL, 0, 0);
	filler(buf, "..", NULL, 0, 0);

    // example file
	filler(buf, "hello", NULL, 0, 0);

    // ak fs integration
    size_t ms_len = ak_fs_maps_v3_found_in_fs();
    akfs_map_v3 map_store[ms_len];
    akfs_map_v3* mps_ptr = &map_store[0];
    void* mps_start = &map_store[0];
    (void)mps_start;
    ak_fs_maps_v3_init(&mps_ptr, ms_len);
    ak_fs_maps_v3_resolve(&mps_ptr, ms_len);
    akfs_map_v3 *ptr = NULL;
    for (ptr = mps_ptr; ptr < mps_ptr + ms_len; ++ptr)
    {
        if ( ak_fs_map_v3_is_null(ptr) )
        {
            ak_fs_map_v3_print_filename(ptr);
            filler(buf, ak_fs_map_v3_get_filename(ptr), NULL, 0, 0);
        }
    }

    return 0;
}

// Called to get file attributes (metadata)
static int akfs_fuse_getattr(const char *path, struct stat *st, struct fuse_file_info *fi)
{
	(void) fi;
	st->st_uid = getuid();
	st->st_gid = getgid();
	st->st_atime = st->st_mtime = time(NULL);

	if (strcmp(path, "/") == 0) {
		st->st_mode = S_IFDIR | 0755;  // Directory
		st->st_nlink = 2;
	} else if (strcmp(path, "/hello") == 0) {
		st->st_mode = S_IFREG | 0644;  // Regular file
		st->st_nlink = 1;
		st->st_size = strlen("Hello, World!\n");
	} else {
		return -ENOENT;  // Not found
	}
	return 0;
}

// FUSE operations struct (only implementing needed functions)
static struct fuse_operations akfs_fuse_ops = {
	.getattr = akfs_fuse_getattr,
	.readdir = akfs_fuse_readdir,
	.read = akfs_fuse_read,
};

int main(int argc, char *argv[])
{
	return fuse_main(argc, argv, &akfs_fuse_ops, NULL);
}
