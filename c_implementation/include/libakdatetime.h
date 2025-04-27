#include <stdbool.h>
#include <stddef.h>
#ifndef AK_DATETIME_H
#define AK_DATETIME_H

long ak_datetime_unix();
void ak_datetime_unix_nanosecs(char *buffer, size_t size);
void ak_datetime_human(char *buffer, size_t size);
void ak_datetime_human_date_only(char *buffer, size_t size);
void ak_datetime_human_date_only_yesterday(char *buffer, size_t size);
//static bool is_digits_only(const char *str);
bool ak_datetime_unix_to_human(const char *timestamp_str, char *buffer, size_t size);

#endif // AK_DATETIME_H
