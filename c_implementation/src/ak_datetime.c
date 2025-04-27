#include <libakdatetime.h>
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <stdlib.h>

// Returns Unix timestamp (seconds since epoch)
long ak_datetime_unix() {
	return time(NULL);
}

// Returns Unix timestamp with nanoseconds
void ak_datetime_unix_nanosecs(char *buffer, size_t size) {
	struct timespec ts;
	clock_gettime(CLOCK_REALTIME, &ts);
	snprintf(buffer, size, "%ld.%09ld", ts.tv_sec, ts.tv_nsec);
}

// Returns human-readable datetime in format YYYYMMDD_HHMMSS
void ak_datetime_human(char *buffer, size_t size) {
	time_t now = time(NULL);
	const struct tm *tm = gmtime(&now);
	strftime(buffer, size, "%Y%m%d_%H%M%S", tm);
}

// Returns human-readable date in format YYYYMMDD
void ak_datetime_human_date_only(char *buffer, size_t size) {
	time_t now = time(NULL);
	const struct tm *tm = gmtime(&now);
	strftime(buffer, size, "%Y%m%d", tm);
}

// Returns yesterday's date in format YYYYMMDD
void ak_datetime_human_date_only_yesterday(char *buffer, size_t size) {
	time_t now = time(NULL);
	now -= 24 * 60 * 60; // Subtract one day
	const struct tm *tm = gmtime(&now);
	strftime(buffer, size, "%Y%m%d", tm);
}

// Checks if string contains only digits
static bool is_digits_only(const char *str) {
	while (*str) {
		if (!isdigit(*str)) {
			return false;
		}
		str++;
	}
	return true;
}

// Converts Unix timestamp to human-readable format YYYYMMDD_HHMMSS
bool ak_datetime_unix_to_human(const char *timestamp_str, char *buffer, size_t size) {
	// Check if input is valid (10-digit number)
	if (timestamp_str == NULL || strlen(timestamp_str) != 10 || !is_digits_only(timestamp_str)) {
		return false;
	}

	time_t timestamp = (time_t)atol(timestamp_str);
	const struct tm *tm = gmtime(&timestamp);
	if (tm == NULL) {
		return false;
	}

	strftime(buffer, size, "%Y%m%d_%H%M%S", tm);
	return true;
}

