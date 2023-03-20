CC      := gcc
CFLAGS  := -Wall -Wextra -g -Isrc $(@:.o=.d)
LDFLAGS := $(CFLAGS) --static
OBJ_DIR := build

CFLAGS  += -mfentry
ASFLAGS += -mfentry
LDFLAGS += -mfentry -lpthread

TRACER_SOURCES     := $(wildcard src/tracer.c)
TRAMPOLINE_SOURCES := $(wildcard src/trampoline.S)
SOURCES            := $(wildcard *.c)
OBJECTS            := $(patsubst %.c,$(OBJ_DIR)/%.o,$(SOURCES))
TRACER_OBJECT      := $(OBJ_DIR)/tracer.o
TRAMPOLINE_OBJECT  := $(OBJ_DIR)/trampoline.o
EXECUTABLE         := $(OBJ_DIR)/main



.PHONY: all clean

all: $(OBJ_DIR) $(EXECUTABLE)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TRACER_OBJECT): $(TRACER_SOURCES)
	$(CC) $(CFLAGS) -c $< -o $@

$(TRAMPOLINE_OBJECT): $(TRAMPOLINE_SOURCES)
	$(CC) $(CFLAGS) -c $< -o $@

$(EXECUTABLE): $(OBJECTS) $(TRACER_OBJECT) $(TRAMPOLINE_OBJECT)
	$(CC)  $^ -o $@ $(LDFLAGS)

clean:
	rm -rf $(OBJ_DIR)
