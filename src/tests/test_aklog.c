#include <aklog.h>

void test_message_output()
{
    ak_log_print_log_line("1731664790 <TEST> [INFO] test message info");
}

void test_follow()
{
    ak_log_follow();
}

void test_grep()
{
    ak_log_grep("-h");
}

void test_rotate()
{
    ak_log_rotate();
}

void test_log_message()
{
    ak_log_message(__func__, "TEST", "test message info");
}

void test_exit()
{
    ak_log_exit(__func__, "test message info");
}

void test_warning()
{
    ak_log_warning(__func__, "test message info");
}

void test_debug()
{
    ak_log_debug(__func__, "test message info");
}

void test_error()
{
    ak_log_error(__func__, "test message info");
}

void test_info()
{
    ak_log_info(__func__, "test message info");
}

void test_write()
{
    ak_log_info(__func__, "test message info");
}

int main (void)
{
    test_follow();
    test_message_output();
    test_info();
    test_exit();
    test_error();
    test_debug();
    test_warning();
    test_log_message();
    test_rotate();
    test_grep();
    test_write();
    return 0;
}
