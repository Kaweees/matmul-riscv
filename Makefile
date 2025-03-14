# Makefile for compiling, linking, and building the program.
# Begin Variables Section

## Program Section: change these variables based on your program
# The name of the program to build.
TARGET := matmul

## Architecture Section: change these variables based on your architecture
# The architecture executable.
ARCH := rv32i
ARCH_PREFIX := riscv64-unknown-elf-
# The architecture flags.
ARCH_FLAGS := -march=$(ARCH) -mabi=ilp32

## Compiler Section: change these variables based on your compiler
# -----------------------------------------------------------------------------
# The compiler executable.
CC := $(ARCH_PREFIX)gcc
# The compiler flags.
CFLAGS := -Wall
# The linker executable.
LD := $(ARCH_PREFIX)ld
# The linker flags.
LDFLAGS := -Wall
# The objcopy executable.
OBJ_COPY := $(ARCH_PREFIX)objcopy
# The objcopy flags.
OBJ_COPY_FLAGS := -O binary -R .eeprom
# The objdump executable.
OBJ_DUMP := $(ARCH_PREFIX)objdump
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
TEST_INPUT := test_input.txt
# The name of the test output file
TEST_OUTPUT := test_output.tar
# The name of the reference executable
REF_EXE := ~pn-cs357/demos/mytar
# The name of the reference output file
REF_OUTPUT := ref_output.tar

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
# executable file to build
BINS := $(BUILD_DIR)$(TARGET)

## Command Section: change these variables based on your commands
# -----------------------------------------------------------------------------
# Targets
.PHONY: all $(TARGET) test clean debug help

# Default target: build the program
all: $(BINS)

# Build the program
$(TARGET): $(BINS)

# Rule to build the program from linked object files
$(BINS): $(OBJS)
	@mkdir -p $(BUILD_DIR)
	$(LD) $(LDFLAGS) $(OBJS) -o $(BINS)

# Rule to compile source files into object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

# Test target: build and test the program against sample input
test: $(TARGET)
	$(BINS) -c -f $(TEST_OUTPUT) $(TEST_INPUT)

# @echo "Testing $(BINS)..."
# @echo "Testing memory leaks..."
# $(MEMCHECK) $(MEMCHECK_FLAGS) $(BINS)
# @echo "Comparing output to $(REF_EXE):"
# diff <($(BINS)) <($(REF_EXE))

# Clean target: remove build artifacts and non-essential files
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)
	rm -rf $(BUILD_DIR)

# Debug target: use a debugger to debug the program
debug: $(BINS)
	@echo "Debugging $(TARGET)..."
	$(DEBUGGER) $(DEBUGGER_FLAGS) $(BINS)

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
