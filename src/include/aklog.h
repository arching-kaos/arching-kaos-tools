#ifndef AKLOG
#define AKLOG

void ak_log_print_log_line(char* line);
void ak_log_follow();
void ak_log_grep(char* string);
void ak_log_rotate();
void ak_log_message(char* program, char* type, char* message);
void ak_log_exit(char* program, char* message);
void ak_log_warning(char* program, char* message);
void ak_log_debug(char* program, char* message);
void ak_log_error(char* program, char* message);
void ak_log_info(char* program, char* message);

#endif // AKLOG
