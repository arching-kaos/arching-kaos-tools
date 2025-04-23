#include <libaklog.h>

static void test_message_output()
{
    ak_log_print_log_line("1731664790 <TEST> [INFO] test message info");
}

static void test_follow()
{
    ak_log_follow();
}

static void test_grep()
{
    ak_log_grep("-h");
}

static void test_rotate()
{
    ak_log_rotate();
}

static void test_log_message()
{
    ak_log_message(__func__, DEBUG, "test message info");
}

static void test_exit()
{
    ak_log_exit(__func__, "test message exit");
}

static void test_warning()
{
    ak_log_warning(__func__, "test message WARNING");
}

static void test_debug()
{
    ak_log_debug(__func__, "test message debug");
}

static void test_error()
{
    ak_log_error(__func__, "test message error");
}

static void test_info()
{
    ak_log_info(__func__, "test message info");
}

static void test_test()
{
    ak_log_test(__func__, "test message test");
}

static void test_one_word()
{
    ak_log_info(__func__, "test");
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
    test_test();
    test_log_message();
    test_rotate();
    test_grep();
    test_one_word();
    return 0;
}
