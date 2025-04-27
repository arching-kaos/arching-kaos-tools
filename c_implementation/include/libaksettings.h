#ifndef AK_SETTINGS_H
#define AK_SETTINGS_H

#include <stdbool.h>

typedef struct {
    char *key;
    char *value;
} AKSetting;

void ak_settings_print_setting(AKSetting);
int ak_settings_from_file();
int ak_setting_to_file(AKSetting);

AKSetting* ak_settings_get_all();

char *ak_settings_get_setting(const char*);
bool ak_settings_set_setting(const char*, const char*);
bool ak_settings_save_settings();
bool ak_settings_load_settings_binary();
int ak_settings_find_setting(const char *key);
void ak_settings_free_settings();
bool ak_settings_save_settings_binary();
void ak_settings_import_from_environment();

#endif // AK_SETTINGS_H
