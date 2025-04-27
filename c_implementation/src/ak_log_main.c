#include <getopt.h>
#include <libaklog.h>

static int ak_log_usage()
{
    ak_log_info(__func__, "Available commands:");
    ak_log_info(__func__, "  ak_log");
    return 1;
}

int ak_log_main(int argc, char **argv)
{
    int option;
    while ( (option = getopt(argc, argv, ":h|:help")) != -1 )
    {
        switch(option)
        {
            case 'h':
                return ak_log_usage();
            case ':':
                return 1;
            case '?':
                return 2;
        }
    }
    return 0;
}

int main(int argc, char** argv)
{
    return ak_log_main(argc, argv);
}
