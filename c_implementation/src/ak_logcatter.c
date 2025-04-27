#include <libaklogcatter.h>
#include <stdio.h>
#include <libaklog.h>
#include <stdlib.h>

int ak_logcatter()
{
    printf("Testing: %s\n", __func__);
    FILE *fp;
    fp = fopen("/home/kaotisk/.arching-kaos/logs", "r");
    if (!fp)
    {
        perror("fopen");
        return EXIT_FAILURE;
    }
    char buffer[1] = {0};
    char line[1024] = {0};
    unsigned int i = 0;
    while ( fread(buffer, sizeof(char), sizeof(char), fp) )
    {
        if ( buffer[0] == '\n' )
        {
            line[i] = '\0';
            ak_log_print_log_line(line);
            i = 0;
        }
        else
        {
            line[i] = buffer[0];
            line[i+1] = '\0';
            i++;
        }
    }
    fclose(fp);
    return 0;
}
