# Makefile for compiling, linking, and building the program.
# Begin Variables Section

## Program Section: change these variables based on your program
# The name of the program to build.
TARGET := matmul

## Architecture Section: change these variables based on your architecture
# The architecture executable.
ARCH := rv32i
ARCH_PREFIX := riscv32-none-elf-
# The architecture flags.
ARCH_FLAGS := -march=$(ARCH) -mabi=ilp32

## Compiler Section: change these variables based on your compiler
# -----------------------------------------------------------------------------
# The compiler executable.
CC := $(ARCH_PREFIX)gcc
# The compiler flags.
CC_FLAGS := -Wall
# The linker executable.
LD := $(ARCH_PREFIX)ld
# The linker flags.
LD_FLAGS := -Wall
# The objcopy executable.
OBJ_COPY := $(ARCH_PREFIX)objcopy
# The objcopy flags.
OBJ_COPY_FLAGS := -O binary --only-section=.data* --only-section=.text*
# The objdump executable.
OBJ_DUMP := $(ARCH_PREFIX)objdump
# The objdump flags.
OBJ_DUMP_FLAGS := --no-show-raw-insn -S -s
# The hexdump executable.
HEXDUMP := hexdump
# The hexdump flags.
HEXDUMP_FLAGS := -v -e '"%08x\n"'
# The shell executable.
SHELL := /bin/bash

## Testing Suite Section: change these variables based on your testing suite
# -----------------------------------------------------------------------------
# The memory checker executable.
MEMCHECK := valgrind
# The memory checker flags.
MEMCHECK_FLAGS := --leak-check=full --show-leak-kinds=all --track-origins=yes
# The debugger executable.
DEBUGGER := gdb
# The debugger flags.
DEBUGGER_FLAGS :=

# The name of the test input file
TEST_INPUT :=
# The name of the test output file
TEST_OUTPUT :=
# The name of the reference executable
REF_EXE :=
# The name of the reference output file
REF_OUTPUT :=

## Output Section: change these variables based on your output
# -----------------------------------------------------------------------------
# top directory of project
TOP_DIR := $(shell pwd)
# directory to locate source files
SRC_DIR := $(TOP_DIR)/src
# directory to locate header files
INC_DIR := $(TOP_DIR)/include
# directory to locate object files
OBJ_DIR := $(TOP_DIR)/obj
# directory to place build artifacts
BUILD_DIR := $(TOP_DIR)/target/$(ARCH)/release/

# header files to preprocess
INCS := -I$(INC_DIR)
# source files to compile
SRCS := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*.s) $(wildcard $(SRC_DIR)/*.S)
# object files to link
OBJS := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(filter %.c,$(SRCS))) \
             $(patsubst $(SRC_DIR)/%.s, $(OBJ_DIR)/%.o, $(filter %.s,$(SRCS))) \
             $(patsubst $(SRC_DIR)/%.S, $(OBJ_DIR)/%.o, $(filter %.S,$(SRCS)))

ifneq ($(filter %.c,$(SRCS)),)
CC_FLAGS += -O3 $(ARCH_FLAGS) -g
else
CC_FLAGS += -O0 $(ARCH_FLAGS)
endif
# executable file to build
BINS := $(BUILD_DIR)$(TARGET)
# binary file to convert to hex
TARGET_BIN := $(BINS).bin
# elf file to convert to hex
TARGET_ELF := $(BINS).elf
# hex file to flash
TARGET_HEX := $(BINS).hex
# memory image file
TARGET_TXT  := $(BINS).txt
# disassembly/dump file depending on whether C code is present
ifneq ($(filter %.c,$(SRCS)),)
TARGET_DUMP:= $(BINS).dump
else
TARGET_DUMP:= $(BINS).dis
endif

## Command Section: change these variables based on your commands
# -----------------------------------------------------------------------------
# Targets
.PHONY: all $(TARGET) dirs test clean debug help

# Default target: build the program
all: $(BINS)

# Build the program
$(TARGET): $(BINS)

# Rule to build the program from linked object files
$(BINS): dirs $(TARGET_TXT) $(TARGET_DUMP)

# Rule to compile source files into object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CC_FLAGS) $(INCS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	$(CC) $(CC_FLAGS) $(INCS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	$(CC) $(CC_FLAGS) $(INCS) -c $< -o $@

# Rule to link object files into an ELF file
$(TARGET_ELF): ${OBJS}
ifneq ($(filter %.c,$(SRCS)),)
	$(CC)  -o $@ $^ -T link.ld $(CC_FLAGS)
else
	$(CC) -o $@ $^ -T link.ld -nostdlib -nostartfiles -mcmodel=medany $(CC_FLAGS)
endif

# Rule to convert an ELF file into a binary file
$(TARGET_DUMP): $(TARGET_ELF)
ifneq ($(filter %.c,$(SRCS)),)
	$(OBJ_DUMP) $(OBJ_DUMP_FLAGS) $< > $@
else
	$(OBJ_DUMP) -d $< > $@
endif

$(TARGET_BIN): $(TARGET_ELF)
	$(OBJ_COPY) $(OBJ_COPY_FLAGS) $< $@

# convert to an ASCII hex file for OTTER memory
$(TARGET_TXT): $(TARGET_BIN)
	$(HEXDUMP) $(HEXDUMP_FLAGS) $< > $@

# Test target: build and test the program against sample input
test: $(TARGET)
	$(BINS) -c -f $(TEST_OUTPUT) $(TEST_INPUT)

# Directory target: create the build and object directories
dirs:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OBJ_DIR)

# Clean target: remove build artifacts and non-essential files
clean:
	@rm -rf $(OBJ_DIR) $(BIN_DIR)
	@rm -rf $(BUILD_DIR)

# Debug target: use a debugger to debug the program
debug: $(BINS)
	@echo "Debugging $(TARGET)..."
	@$(DEBUGGER) $(DEBUGGER_FLAGS) $(BINS)

# Help target: display usage information
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  all              Build $(TARGET)"
	@echo "  $(TARGET) 	   Build $(TARGET)"
	@echo "  test             Build and test $(TARGET) against a sample input, use $(MEMCHECK) to check for memory leaks, and compare the output to $(REF_EXE)"
	@echo "  clean            Remove build artifacts and non-essential files"
	@echo "  debug            Use $(DEBUGGER) to debug $(HENCODE_TARGET) and $(HDECODE_TARGET)"
	@echo "  help             Display this help information"
