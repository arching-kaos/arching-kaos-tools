#include <libaklog.h>

void test_write()
{
    ak_log_info(__func__, "test message info");
    ak_log_warning(__func__, "test message warning");
    ak_log_error(__func__, "test message error");
    ak_log_debug(__func__, "test message debug");
}

int main (void)
{
    test_write();
    return 0;
}

