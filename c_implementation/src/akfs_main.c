#include <getopt.h>
#include <stdio.h>
#include <libaklog.h>
#include <libakfs.h>

static int ak_fs_usage()
{
    ak_log_debug(__func__, "Available commands:");
    ak_log_debug(__func__, "ak fs --list");
    return 1;
}

int ak_fs_main(int argc, char** argv)
{
    int option;
    int logind = 0;
    static struct option long_options[] = {
        {"help", no_argument, 0, 'h'},
        {"list", no_argument, 0, 'l'},
        {0,0,0,0}
    };
    while(1)
    {
        option = getopt_long(argc, argv, "hl", long_options, &logind);
        if ( option == -1 ) return ak_fs_usage();
        switch(option)
        {
            case 'h':
                return ak_fs_usage();
            case 'l':
                return ak_fs_ls();
            default:
                printf("double lol\n");
                return 4;
        }
    }
    return 0;
}

int main(int argc, char **argv)
{
    return ak_fs_main(argc, argv);
}
