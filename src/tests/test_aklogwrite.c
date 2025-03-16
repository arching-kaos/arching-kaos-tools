#include <aklog.h>

void test_write()
{
    ak_log_info(__func__, "test message info");
}

int main (void)
{
    test_write();
    return 0;
}

