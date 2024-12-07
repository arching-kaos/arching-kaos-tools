#ifndef AKLOG
#define AKLOG

void ak_log_print_log_line(char* line);
void ak_log_follow();
void ak_log_grep(char* string);
void ak_log_rotate();
void ak_log_message(const char* program, char* type, char* message);
void ak_log_exit(const char* program, char* message);
void ak_log_warning(const char* program, char* message);
void ak_log_debug(const char* program, char* message);
void ak_log_error(const char* program, char* message);
void ak_log_info(const char* program, char* message);

#endif // AKLOG
