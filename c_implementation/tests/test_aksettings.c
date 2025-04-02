#include <aksettings.h>
#include <aklog.h>
#include <stdio.h>

int test_ak_settings_read_write_example()
{
    printf("Testing: %s\n", __func__);
    if (!ak_settings_load_settings_binary())
    {
        ak_log_warning(__func__, "No existing settings or error loading.\n");
    }
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
    ak_settings_free_settings();
    return 0;
}

int test_ak_settings()
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

int main()
{
    return test_ak_settings();
}
