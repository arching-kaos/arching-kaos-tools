#include <libaksettings.h>
#include <libaklog.h>
#include <stdio.h>

void test_ak_settings_from_file()
{
    printf("Testing: %s\n", __func__);
    if (!ak_settings_load_settings_binary()) {
        ak_log_warning(__func__, "No existing settings or error loading.\n");
	}
    const char *theme = ak_settings_get_setting("theme");
    if (theme) {
        printf("Current theme: %s\n", theme);
    }
    ak_settings_free_settings();
}


int main()
{
    test_ak_settings_from_file();
    return 0;
}
