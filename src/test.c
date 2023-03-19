#include <time.h>
#include <stdio.h>
#include <stdint.h>

int main(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    uint64_t timestamp = timegm(gmtime(&ts.tv_sec)) + (ts.tv_nsec / 1000000000.0);
    printf("%lx\n", timestamp);
    return 0;
}
