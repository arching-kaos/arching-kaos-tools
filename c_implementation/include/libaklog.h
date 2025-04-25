#ifndef AKLOG
#define AKLOG

typedef enum {
    TEST,
    INFO,
    WARNING,
    ERROR,
    EXIT,
    DEBUG,
} LogMessageType;

void ak_log_print_log_line(const char*);
void ak_log_follow();
void ak_log_grep(char*);
void ak_log_rotate();
int ak_log_write_to_file(const char*);
void ak_log_message(const char*, LogMessageType, char*);
void ak_log_exit(const char*, char*);
void ak_log_warning(const char*, char*);
void ak_log_debug(const char*, char*);
void ak_log_error(const char*, char*);
void ak_log_info(const char*, char*);
void ak_log_test(const char*, char*);
int ak_log_main(int, char**);

#endif // AKLOG
