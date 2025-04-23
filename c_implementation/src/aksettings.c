#include <libaksettings.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_SETTINGS 100

AKSetting settings[MAX_SETTINGS];
int settings_count = 0;

AKSetting* ak_settings_get_all(){
    return settings;
}

void ak_settings_import_from_environment()
{
    ak_settings_set_setting("AK_BINDIR",getenv("AK_BINDIR"));
    ak_settings_set_setting("AK_BLOCKDIR",getenv("AK_BLOCKDIR"));
    ak_settings_set_setting("AK_CACHEDIR",getenv("AK_CACHEDIR"));
    ak_settings_set_setting("AK_CHUNKSDIR",getenv("AK_CHUNKSDIR"));
    ak_settings_set_setting("AK_CONFIGDIR",getenv("AK_CONFIGDIR"));
    ak_settings_set_setting("AK_DATADIR",getenv("AK_DATADIR"));
    ak_settings_set_setting("AK_GENESIS",getenv("AK_GENESIS"));
    ak_settings_set_setting("AK_GENESISASC",getenv("AK_GENESISASC"));
    ak_settings_set_setting("AK_GPGHOME",getenv("AK_GPGHOME"));
    ak_settings_set_setting("AK_IPFS",getenv("AK_IPFS"));
    ak_settings_set_setting("AK_LEAFSDIR",getenv("AK_LEAFSDIR"));
    ak_settings_set_setting("AK_LIBDIR",getenv("AK_LIBDIR"));
    ak_settings_set_setting("AK_MAPSDIR",getenv("AK_MAPSDIR"));
    ak_settings_set_setting("AK_MINEDBLOCKSDIR",getenv("AK_MINEDBLOCKSDIR"));
    ak_settings_set_setting("AK_MODULESDIR",getenv("AK_MODULESDIR"));
    ak_settings_set_setting("AK_ROOT",getenv("AK_ROOT"));
    ak_settings_set_setting("AK_SETTINGS",getenv("AK_SETTINGS"));
    ak_settings_set_setting("AK_WORKDIR",getenv("AK_WORKDIR"));
    ak_settings_set_setting("AK_ZBLOCKDIR",getenv("AK_ZBLOCKDIR"));
    ak_settings_set_setting("AK_ZBLOCKSFILE",getenv("AK_ZBLOCKSFILE"));
    ak_settings_set_setting("AK_ZCHAIN",getenv("AK_ZCHAIN"));
    ak_settings_set_setting("AK_ZCHAINASC",getenv("AK_ZCHAINASC"));
    ak_settings_set_setting("AK_ZGENESIS",getenv("AK_ZGENESIS"));
    ak_settings_set_setting("AK_ZGENESISASC",getenv("AK_ZGENESISASC"));
    ak_settings_set_setting("AK_ZLATEST",getenv("AK_ZLATEST"));
    ak_settings_set_setting("AK_ZLATEST_HISTORY",getenv("AK_ZLATEST_HISTORY"));
    ak_settings_set_setting("AK_ZLIST",getenv("AK_ZLIST"));
    ak_settings_set_setting("AK_ZPAIRSFILE",getenv("AK_ZPAIRSFILE"));
    ak_settings_set_setting("AK_ZPEERSDIR",getenv("AK_ZPEERSDIR"));
    ak_settings_set_setting("AK_ZPEERSFILE",getenv("AK_ZPEERSFILE"));
    ak_settings_set_setting("AK_ZZCHAIN",getenv("AK_ZZCHAIN"));
    ak_settings_set_setting("AK_ARCHIVESDIR",getenv("AK_ARCHIVESDIR"));
}

bool ak_settings_write_string(FILE *file, const char *str) {
    size_t len = strlen(str) + 1; // Include null terminator
    if (fwrite(&len, sizeof(size_t), 1, file) != 1) return false;
    if (fwrite(str, sizeof(char), len, file) != len) return false;
    return true;
}

char *ak_settings_read_string(FILE *file) {
    size_t len;
    if (fread(&len, sizeof(size_t), 1, file) != 1) return NULL;
    char *str = malloc(len);
    if (!str) return NULL;
    if (fread(str, sizeof(char), len, file) != len) {
        free(str);
        return NULL;
    }
    return str;
}

void ak_settings_free_settings() {
    for (int i = 0; i < settings_count; i++) {
        free(settings[i].key);
        free(settings[i].value);
    }
    settings_count = 0;
}

int ak_settings_find_setting(const char *key) {
    for (int i = 0; i < settings_count; i++) {
        if (strcmp(settings[i].key, key) == 0) {
            return i;
        }
    }
    return -1;
}

bool ak_settings_load_settings_binary() {
    FILE *file = fopen("settings.bin", "rb");
    if (!file) return false;
    if (fread(&settings_count, sizeof(int), 1, file) != 1) {
        fclose(file);
        return false;
    }
    for (int i = 0; i < settings_count; i++) {
        settings[i].key = ak_settings_read_string(file);
        settings[i].value = ak_settings_read_string(file);
        if (!settings[i].key || !settings[i].value) {
            ak_settings_free_settings();
            fclose(file);
            return false;
        }
    }
    fclose(file);
    return true;
}

bool ak_settings_save_settings_binary() {
    FILE *file = fopen("settings.bin", "wb");
    if (!file) return false;
    if (fwrite(&settings_count, sizeof(int), 1, file) != 1) {
        fclose(file);
        return false;
    }
    for (int i = 0; i < settings_count; i++) {
        if (!ak_settings_write_string(file, settings[i].key)) {
            fclose(file);
            return false;
        }
        if (!ak_settings_write_string(file, settings[i].value)) {
            fclose(file);
            return false;
        }
    }
    fclose(file);
    return true;
}

bool ak_settings_set_setting(const char *key, const char *value) {
    int index = ak_settings_find_setting(key);
    if (index == -1) {
        if (settings_count >= MAX_SETTINGS) return false;
        settings[settings_count].key = strdup(key);
        settings[settings_count].value = strdup(value);
        if (!settings[settings_count].key || !settings[settings_count].value) {
            free(settings[settings_count].key);
            free(settings[settings_count].value);
            return false;
        }
        settings_count++;
    } else {
        char *new_value = strdup(value);
        if (!new_value) return false;
        free(settings[index].value);
        settings[index].value = new_value;
    }
    return true;
}

char *ak_settings_get_setting(const char *key) {
    int index = ak_settings_find_setting(key);
    return (index == -1) ? NULL : settings[index].value;
}
