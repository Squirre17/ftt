#include "tracer.h"

#define MAX_LOG_COUNT 0x1000

info infos[MAX_LOG_COUNT];
static u32 cur = 0;

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;


/*
    Specifically, attribute((section(".data.read_mostly"))) indicates that the variable 
    should be placed in the ".data.read_mostly" data section, which is usually located 
    after the read-only data section (.rodata) and marked as "read mostly".
*/
__attribute__((no_instrument_function))
void __trace_dump() {

    FILE *fp = fopen("./trace.data", "w+");
    if(fp == NULL){
        printf("[-] fopen error with errno<%s>\n", strerror(errno));
        exit(1);
    }

    for(u32 i = 0;i < cur; i++) {
        fprintf(fp ,"%#018lx %#018lx %#018lx %#018lx %#018lx %#018lx %#018lx\n",
            infos[i].addr      ,
            infos[i].prev_addr ,
            infos[i].arg1      ,
            infos[i].arg2      ,
            infos[i].arg3      ,
            infos[i].arg4      ,
            infos[i].ts
        );
    }

    fclose(fp);
}

__attribute__((no_instrument_function))
void __trace_log(u64 addr, u64 prev_addr, u64 arg1, u64 arg2, u64 arg3, u64 arg4){

    pthread_mutex_lock(&mutex);

    struct timespec ts;
    clock_getres(CLOCK_MONOTONIC, &ts);
    
    infos[cur].addr      = addr;
    infos[cur].prev_addr = prev_addr;
    infos[cur].arg1      = arg1;
    infos[cur].arg2      = arg2;
    infos[cur].arg3      = arg3;
    infos[cur].arg4      = arg4;
    infos[cur].ts        = ts.tv_sec + 2208988800UL;

    cur++;

    if(cur >= MAX_LOG_COUNT){
        printf("[-] container is fill new, eject dump and exit\n");
        __trace_dump();
        exit(1);
    }

    pthread_mutex_unlock(&mutex);
}

ctracer_func_t tracer_ptr __attribute__((__section__(".data.read_mostly"))) = NULL;

__attribute__((no_instrument_function))
void __trace_on() {
    tracer_ptr = __trace_log;
}

__attribute__((no_instrument_function))
void __trace_off() {
    tracer_ptr = NULL;
    __trace_dump();
}

