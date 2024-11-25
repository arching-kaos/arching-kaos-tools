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
    ak_log_message("TEST", "TEST", "test message info");
}

void test_exit()
{
    ak_log_exit("TEST", "test message info");
}

void test_warning()
{
    ak_log_warning("TEST", "test message info");
}

void test_debug()
{
    ak_log_debug("TEST", "test message info");
}

void test_error()
{
    ak_log_error("TEST", "test message info");
}

void test_info()
{
    ak_log_info("TEST", "test message info");
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
    return 0;
}
