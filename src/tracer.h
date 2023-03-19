#ifndef __FTT_TRACER_H__
#define __FTT_TRACER_H__
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>
#include <errno.h>
#include <string.h>

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

typedef int8_t   i8;
typedef int16_t  i16;
typedef int32_t  i32;
typedef int64_t  i64;

typedef struct info {
    u64 addr;
    u64 prev_addr;
    u64 arg1;
    u64 arg2;
    u64 arg3;
    u64 arg4;
    u64 ts;   /* timestamp TDOO: */
}info;


typedef void (*ctracer_func_t)(u64 addr, u64 prev_addr, u64 arg1, u64 arg2, u64 arg3, u64 ts);

extern void __trace_on();
extern void __trace_off();
#endif /* __FTT_TRACER_H__ */