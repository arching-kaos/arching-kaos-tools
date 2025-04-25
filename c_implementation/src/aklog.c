#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include "libaklog.h"

#define AK_DEBUG true
#define AK_DEBUG_LEVEL DEBUG

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

int ak_log_write_to_file(const char* message)
{
    FILE *fp;
    char *fullpath_to_log_file={0};
    char *relative_location = "/.arching-kaos/logs/log";
    char *home_dir = getenv("HOME");
    asprintf(&fullpath_to_log_file, "%s%s", home_dir, relative_location);
    fp = fopen(fullpath_to_log_file, "ab");
    if (!fp)
    {
        perror("fopen");
        return EXIT_FAILURE;
    }
    fwrite(message, strlen(message),1,fp);
    fwrite("\n", strlen("\n"),1,fp);
    fclose(fp);
    return 0;
}

void ak_log_print_log_line(const char* line)
{
    int spaces_found = 0;
    int sa[] = { -1, -1, -1, -1 };
    long int l = 1000000000;
    long int ts = 0;
    const struct tm *timeInfo;
    char ts_string[16]; // %Y%Y%Y%Y%m%m%d%d_%H%H%M%M%S%S
    for (size_t i = 0; i < strlen(line); ++i)
    {
        if ( line[i] == ' ' && spaces_found < 3 )
        {
            spaces_found++;
            sa[spaces_found] = i;
        }
    }
    for ( int k = 0; k < sa[1]; ++k)
    {
        switch(line[k])
        {
            case '0':
                ts = 0*l + ts;
                break;
            case '1':
                ts = 1*l + ts;
                break;
            case '2':
                ts = 2*l + ts;
                break;
            case '3':
                ts = 3*l + ts;
                break;
            case '4':
                ts = 4*l + ts;
                break;
            case '5':
                ts = 5*l + ts;
                break;
            case '6':
                ts = 6*l + ts;
                break;
            case '7':
                ts = 7*l + ts;
                break;
            case '8':
                ts = 8*l + ts;
                break;
            case '9':
                ts = 9*l + ts;
                break;
        }
        l = l/10;
    }
    timeInfo = localtime(&ts);
    strftime(ts_string, sizeof(ts_string), "%Y%m%d_%H%M%S", timeInfo);
    printf("%s", ts_string);
    printf(" \033[1;32m");
    for ( int k = sa[1]+1; k < sa[2]; ++k)
    {
        printf("%c", line[k]);
    }
    printf("\033[0m \033[1;31m");
    for ( int k = sa[2]+1; k < sa[3]; ++k)
    {
        printf("%c", line[k]);
    }
    printf("\033[0m ");
    for ( size_t k = sa[3]+1; k < strlen(line); ++k)
    {
        printf("%c", line[k]);
    }
    printf("\033[0m");
    printf("\n");
}

void ak_log_follow()
{
    //    tail -f $AK_LOGSFILE | while read -r p || [ -n "$p" ]
    //    do
    //        ak_log_print_log_line "$p"
    //    done
}

void ak_log_grep(char* message)
{
    (void)message;
    printf("ak_log_grep: not implemented\n");
    return;
    // exit(2);
    // if ( message )
    // {
    //     if ( strcmp(message, "-h") || strcmp(message, "--help") )
    //     {
    //         // description();
    //         printf("Launch with no arguments and select from the menu that will appear\n");
    //         exit(1);
    //     }
    // }
    // printf("The following scripts have entries in the log file.\n");
    // printf("Select one of those by entering the number of it below and hit enter:\n");
    //    select x in $(cat $AK_LOGSFILE | cut -d ' ' -f 2 | sort | uniq)
    //    do
    //        grep $x $AK_LOGSFILE | while read line
    //        do
    //            ak_log_print_log_line "$line"
    //        done
    //        break
    //    done
}

void ak_log_rotate()
{
    //    if [ -f $AK_LOGSFILE ]
    //    then
    //        tar cvfz $AK_ARCHIVESDIR/logs_$(date -u +%s).tar.gz $AK_WORKDIR/logs
    //        cat /dev/null > $AK_WORKDIR/logs
    //    fi
    //    if [ -f $AK_WORKDIR/akd.log ]
    //    then
    //        tar cvfz $AK_ARCHIVESDIR/akd-logs_$(date -u +%s).tar.gz $AK_WORKDIR/akd.log
    //        cat /dev/null > $AK_WORKDIR/akd.log
    //    fi
    printf("ak_log_rotate: not implemented\n");
    return;
    // exit(2);
}

void ak_log_message(const char* program, LogMessageType lmtype, char* message)
{
    time_t ts = time(NULL);
    time(&ts);
    char* some_string = {0};
    char* type = {0};
    if ( program == NULL )
    {
        // echo "$TS" "<$(basename $0)>" "[ERROR]" "No arguments given" >> $AK_LOGSFILE
        asprintf(&some_string, "%ld <NULL> [ERROR] No arguments given\n", ts);
        ak_log_write_to_file(some_string);
        if ( AK_DEBUG ) ak_log_print_log_line(some_string);
        return;
    }
    if ( message == NULL )
    {
        asprintf(&some_string, "%ld <%s> [ERROR] No message\n", ts, program);
        ak_log_write_to_file(some_string);
        if ( AK_DEBUG ) ak_log_print_log_line(some_string);
        return;
    }
    switch(lmtype)
    {
        case ERROR:
            type = "ERROR";
            break;
        case INFO:
            type = "INFO";
            break;
        case WARNING:
            type = "WARNING";
            break;
        case EXIT:
            type = "EXIT";
            break;
        case DEBUG:
            type = "DEBUG";
            break;
        case TEST:
            type = "TEST";
            break;
        default:
            asprintf(&some_string, "%ld <%s> [ERROR] No message type\n", ts, program);
            ak_log_write_to_file(some_string);
            if ( AK_DEBUG ) ak_log_print_log_line(some_string);
            return;
    }
    asprintf(&some_string, "%ld <%s> [%s] %s", ts, program, type, message);
    ak_log_write_to_file(some_string);
    if ( lmtype <= AK_DEBUG_LEVEL ) ak_log_print_log_line(some_string);
}

void ak_log_exit(const char* program, char* message)
{
    ak_log_message(program, EXIT, message);
}

void ak_log_warning(const char* program, char* message)
{
    ak_log_message(program, WARNING, message);
}

void ak_log_debug(const char* program, char* message)
{
    ak_log_message(program, DEBUG, message);
}

void ak_log_error(const char* program, char* message)
{
    ak_log_message(program, ERROR, message);
}

void ak_log_info(const char* program, char* message)
{
    ak_log_message(program, INFO, message);
}

void ak_log_test(const char* program, char* message)
{
    ak_log_message(program, TEST, message);
}

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
        printf("%d\n", option);
        switch(option)
        {
            case 'h':
                return ak_log_usage();
            case ':':
                printf("kek\n");
                return 1;
            case '?':
                printf("lol\n");
                return 2;
        }
    }
    return 0;
}
