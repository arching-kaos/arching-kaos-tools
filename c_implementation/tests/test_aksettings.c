#include <libaksettings.h>
#include <libaklog.h>
#include <stdio.h>

static int test_ak_settings_read_example()
{
    printf("Testing: %s\n", __func__);
    if (!ak_settings_load_settings_binary())
    {
        ak_log_warning(__func__, "No existing settings or error loading.\n");
    }
    const char *bindir = ak_settings_get_setting("AK_BINDIR");
    if (bindir)
    {
        char *some_text;
        asprintf(&some_text, "Current bin directory: %s\n", bindir);
        ak_log_info(__func__, some_text);
    }
    ak_settings_free_settings();
    return 0;
}

static int test_ak_settings_read_write_example()
{
    printf("Testing: %s\n", __func__);
    if (!ak_settings_load_settings_binary())
    {
        ak_log_warning(__func__, "No existing settings or error loading.\n");
    }
    ak_settings_import_from_environment();
    ak_settings_set_setting("username", "john_doe");
    ak_settings_set_setting("theme", "dark");
    ak_settings_set_setting("volume", "75");
    ak_settings_set_setting("theme", "light");
    if (!ak_settings_save_settings_binary())
    {
        printf("Error saving settings!\n");
        ak_settings_free_settings();
        return 1;
    }
    const char *theme = ak_settings_get_setting("theme");
    if (theme)
    {
        char *some_text;
        asprintf(&some_text, "Current theme: %s\n", theme);
        ak_log_info(__func__, some_text);
    }
    const char *bindir = ak_settings_get_setting("AK_BINDIR");
    if (bindir)
    {
        char *some_text;
        asprintf(&some_text, "Current bin directory: %s\n", bindir);
        ak_log_info(__func__, some_text);
    }
    ak_settings_free_settings();
    return 0;
}

static int test_ak_settings()
{
    char *some_text;
    if ( test_ak_settings_read_write_example() == 0 )
    {
        asprintf(&some_text, "Passed test");
        ak_log_info(__func__, some_text);
        return 0;
    }
    else
    {
        asprintf(&some_text, "Failed test");
        ak_log_error(__func__, some_text);
        return 1;
    }
}

static void test_import()
{
    ak_settings_import_from_environment();
}

static int test_read_and_dump()
{
    printf("Testing: %s\n", __func__);
    if (!ak_settings_load_settings_binary())
    {
        ak_log_warning(__func__, "No existing settings or error loading.\n");
    }
    AKSetting* ak_settings;
    ak_settings = ak_settings_get_all();
    for ( int i = 0; ak_settings[i].key != NULL; ++i )
    {
        printf("%s=%s\n", ak_settings[i].key, ak_settings[i].value);
    }
    ak_settings_free_settings();
    return 0;
}

static int test_find()
{
    printf("Testing: %s\n", __func__);
    if (!ak_settings_load_settings_binary())
    {
        ak_log_warning(__func__, "No existing settings or error loading.\n");
    }
    AKSetting* ak_settings;
    ak_settings = ak_settings_get_all();
    int i =  ak_settings_find_setting("volume");
    if ( i > -1 )
        printf("%s=%s\n", ak_settings[i].key, ak_settings[i].value);
    ak_settings_free_settings();
    return 0;
}

int main()
{
    test_import();
    test_ak_settings();
    test_ak_settings_read_example();
    test_read_and_dump();
    test_find();
    return 0;
}
