#include <stdio.h>
#include <stdbool.h>
#include <assert.h>

//#include <test_sha512_string.h>

typedef struct {
    long unsigned int sum[8];
} sha512sum;

void shifting_example()
{
    long unsigned int X = 0xf;
    for ( long unsigned i = 0; i < 64; i=i+4 )
    {
        printf("shift[%02lu]:\t%#018lx\n", i, X << i);
    }
}

void structed_sum()
{
    sha512sum struct_sample = {
        .sum[0] = 0x921618bc6d9f8059,
        .sum[1] = 0x437c5e0397b13f97,
        .sum[2] = 0x3ab7c7a7b81f0ca3,
        .sum[3] = 0x1b70bf448fd800a4,
        .sum[4] = 0x60b67efda0020088,
        .sum[5] = 0xbc97bf7d9da97a9e,
        .sum[6] = 0x2ce7b20d46e06646,
        .sum[7] = 0x2ec44cf60284f9a7
    };
    printf("stru:\t");
    for ( long unsigned i = 0; i < 8; ++i )
    {
        printf("%lx", struct_sample.sum[i]);
    }
    printf("\n");
}

void long_unsigned_example()
{
    printf("hex:\t%#018lx\n",0xffffffffffffffff);
}

void char_based_sum()
{
    char sum_sample[] = "921618bc6d9f8059437c5e0397b13f973ab7c7a7b81f0ca31b70bf448fd800a460b67efda0020088bc97bf7d9da97a9e2ce7b20d46e066462ec44cf60284f9a7";
//    printf("Size:\t%08lu\n",sizeof(sum_sample));
//    printf("String:\t%s\n",sum_sample);
//    printf("Last:\t%c\n",sum_sample[sizeof(sum_sample)-2]); // Null byte
    printf("Loop:\t"); // Null byte
    for ( long unsigned i = 0; i < sizeof(sum_sample)-1; ++i )
    {
        assert (( sum_sample[i] >= 0x30 ) && (( sum_sample[i] <= 0x39) || ( sum_sample[i] >= 0x60 )) && ( sum_sample[i] <= 0x66 ));
        printf("%c", sum_sample[i]);
//            printf(" 0x%x", sum_sample[i]);
    }
    printf("\n");
}

int main (void)
{
    char_based_sum();
    structed_sum();
    long_unsigned_example();
    shifting_example();

    return 0;
}

