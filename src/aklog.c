#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#define AK_DEBUG true

void ak_log_print_log_line(char* line)
{
    if ( line )
    {
        int i = 0;
        int spaces_found = 0;
        int last_space = -1;
        long int l = 1000000000;
        long int ts = 0;
        struct tm *timeInfo;
        char ts_string[16]; // %Y%Y%Y%Y%m%m%d%d_%H%H%M%M%S%S
        while ( line[i] != '\0' )
        {
            if ( line[i] == ' ' ) //  && spaces_found < 4)
            {
                spaces_found++;
                if (true) //( spaces_found < 4 )
                {
                    for ( int k = last_space+1; k < i; k++ )
                    {
                        switch(spaces_found){
                            case 1:
                                // TS
                                while (true)
                                {
                                    if ( line[k] == ' ' )
                                    {
                                        timeInfo = localtime(&ts);
                                        strftime(ts_string, sizeof(ts_string), "%Y%m%d_%H%M%S", timeInfo);
                                        printf("%s ", ts_string);
                                        break;
                                    }
                                    else
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
                                    k++;
                                }
                                break;
                            case 2:
                                // PROGRAM
                                printf("\033[1;32m");
                                while (true)
                                {
                                    if ( line[k] == ' ' )
                                    {
                                        break;
                                    }
                                    else
                                    {
                                        printf("%c", line[k]);
                                    }
                                    k++;
                                }
                                break;
                            case 3:
                                // TYPE
                                printf("\033[0;00m \033[1;31m");
                                while (true)
                                {
                                    if ( line[k] == ' ' )
                                    {
                                        break;
                                    }
                                    else
                                    {
                                        printf("%c", line[k]);
                                    }
                                    k++;
                                }
                                break;
                            case 4:
                                // MESSAGE
                                printf("\033[0;00m ");
                                while (true)
                                {
                                    if ( line[k] == '\0' )
                                    {
                                        printf("\n");
                                        break;
                                    }
                                    else
                                    {
                                        printf("%c", line[k]);
                                    }
                                    k++;
                                }
                                break;
                        }
                    }
                    last_space = i;
                }
            }
            i++;
        }
    }
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
    printf("ak_log_grep: not implemented\n");
    return;
    exit(2);
    if ( message )
    {
        if ( strcmp(message, "-h") || strcmp(message, "--help") )
        {
            // description();
            printf("Launch with no arguments and select from the menu that will appear\n");
            exit(1);
        }
    }

    printf("The following scripts have entries in the log file.\n");
    printf("Select one of those by entering the number of it below and hit enter:\n");
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
    exit(2);
}

void ak_log_message(char* program, char* type, char* message)
{
    time_t ts = time(NULL);
    struct tm *timeInfo;
    char ts_string[16]; // %Y%Y%Y%Y%m%m%d%d_%H%H%M%M%S%S
    time(&ts);
    timeInfo = localtime(&ts);
    char* some_string = {0};
    strftime(ts_string, sizeof(ts_string), "%Y%m%d_%H%M%S", timeInfo);
    if ( program != NULL )
    {
        if ( type != NULL )
        {
            if ( message != NULL )
            {
                // msg="$(echo -n $*| cut -d ' ' -f 3-)"
                // echo "$TS" "<$1>" "[$2]" "$msg" >> $AK_LOGSFILE
                printf( "%ld <%s> [%s] %s\n", ts, program, type, message); // out to file though
                if ( AK_DEBUG )
                {
                    asprintf(&some_string, "%s <%s> [%s] %s", ts_string, program, type, message);
                    ak_log_print_log_line(some_string);
                    // fprintf(stderr, "%s <%s> [%s] %s\n", ts_string, program, type, message);
                }
            }
            else
            {
                // echo "$TS" "<$1>" "[ERROR]" "No message" >> $AK_LOGSFILE
                printf("%s <%s> [ERROR] No message\n", ts_string, program); // out to file
                if ( AK_DEBUG )
                {
                    fprintf(stderr, "%s <%s> [ERROR] No message\n", ts_string, program);
                }
                exit(1);
            }
        }
        else
        {
            // echo "$TS" "<$1>" "[ERROR]" "No type and message" >> $AK_LOGSFILE

            printf("%s <%s> [ERROR] No type and message\n", ts_string, program); // out to file
            if ( AK_DEBUG )
            {
                fprintf(stderr, "%s <%s> [ERROR] No type and message\n", ts_string, program);
            }
            exit(1);
        }
    }
    else
    {
        // echo "$TS" "<$(basename $0)>" "[ERROR]" "No arguments given" >> $AK_LOGSFILE
        printf("%s <%s> [ERROR] No arguments given\n", ts_string, program); // out to file
        if ( AK_DEBUG )
        {
            fprintf(stderr, "%s <%s> [ERROR] No arguments given\n", ts_string, program);
        }
        exit(1);
    }
}

void ak_log_exit(char* program, char* message)
{
    ak_log_message(program, "EXIT", message);
}

void ak_log_warning(char* program, char* message)
{
    ak_log_message(program, "WARNING", message);
}

void ak_log_debug(char* program, char* message)
{
    ak_log_message(program, "DEBUG", message);
}

void ak_log_error(char* program, char* message)
{
    ak_log_message(program, "ERROR", message);
}

void ak_log_info(char* program, char* message)
{
    ak_log_message(program, "INFO", message);
}

