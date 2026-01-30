COLOUR_BLACK=\033[0;30m
COLOUR_RED=\033[0;31m
COLOUR_GREEN=\033[0;32m
COLOUR_YELLOW=\033[0;33m
COLOUR_BLUE=\033[0;34m
COLOUR_PURPLE=\033[0;35m
COLOUR_CYAN=\033[0;36m
COLOUR_WHITE=\033[0;37m
COLOUR_END=\033[0m

%.PHONY: help
help::
	@echo ""
	@echo " $(COLOUR_PURPLE)Makefile Usage:$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)"
	@echo "================================================================"
	@echo "  COMMAND"
	@echo "================================================================"
	@echo "$(COLOUR_END)"
	@echo "  $(COLOUR_CYAN)make compile_all$(COLOUR_END) $(COLOUR_YELLOW)N=$(N)$(COLOUR_END) $(COLOUR_YELLOW)ITER=$(ITER)$(COLOUR_END)"
	@echo "  Compile all"
	@echo ""
	@echo "  $(COLOUR_CYAN)make simulate_all$(COLOUR_END)"
	@echo "  Simulate all"
	@echo ""
	@echo "  $(COLOUR_CYAN)make result_fft_recursive$(COLOUR_END)"
	@echo "  View fft recursive result"
	@echo ""
	@echo "  $(COLOUR_CYAN)make result_fft_iterative$(COLOUR_END)"
	@echo "  View fft iterative result"
	@echo ""
	@echo "  $(COLOUR_CYAN)make result_fft_precompute$(COLOUR_END)"
	@echo "  View fft precompute result"
	@echo "$(COLOUR_GREEN)"
	@echo "================================================================"
	@echo "  CLEAN"
	@echo "================================================================"
	@echo "$(COLOUR_END)"
	@echo "  $(COLOUR_CYAN)make clean$(COLOUR_END)"
	@echo "  Delete build repertory"
	@echo "$(COLOUR_GREEN)"
	@echo "================================================================"
	@echo "  OPTIONS"
	@echo "================================================================"
	@echo "$(COLOUR_END)"
	@echo " Use the make recipes with required values for options mentioned below"
	@echo "  $(COLOUR_YELLOW)N$(COLOUR_END)        - specifies fft size:                   Values: $(COLOUR_YELLOW)$(N)$(COLOUR_END) (default)"
	@echo "  $(COLOUR_YELLOW)ITER$(COLOUR_END)     - specifies number of iteration:        Values: $(COLOUR_YELLOW)$(ITER)$(COLOUR_END) (default)"
	@echo "$(COLOUR_GREEN)"
	@echo "================================================================"
	@echo "  INFORMATIONS"
	@echo "================================================================"
	@echo "$(COLOUR_END)"
	@echo "  $(COLOUR_RED)[*]$(COLOUR_END) use .cfg file"
	@echo ""

# ================================================================
#   DIRECTORY
# ================================================================

PROJECT_DIR := .

BUILD_DIR := $(PROJECT_DIR)/build
SRC_DIR := $(PROJECT_DIR)/src

# ================================================================
#   FILES
# ================================================================

# ================================================================
#   FLAGS
# ================================================================

GEM5_PATH := $(WORKSPACE)/gem5
M5_INC := $(GEM5_PATH)/include
M5_LIB := $(GEM5_PATH)/util/m5/build/riscv/out/libm5.a

# ================================================================
#   OPTIONS
# ================================================================

N := 256
ITER := 256

# ================================================================
#   COMMAND
# ================================================================

compile_fft_recursive:
	mkdir --parents $(BUILD_DIR); \
	cd $(BUILD_DIR); \
	riscv64-linux-gnu-gcc -Wall -O2 -static -DN=$(N) -DITER=$(ITER) -I$(M5_INC) $(SRC_DIR)/fft_recursive.c $(M5_LIB) -lm -o fft_recursive.riscv

compile_fft_iterative:
	mkdir --parents $(BUILD_DIR); \
	cd $(BUILD_DIR); \
	riscv64-linux-gnu-gcc -Wall -O2 -static -DN=$(N) -DITER=$(ITER) -I$(M5_INC) $(SRC_DIR)/fft_iterative.c $(M5_LIB) -lm -o fft_iterative.riscv

compile_fft_precompute:
	mkdir --parents $(BUILD_DIR); \
	cd $(BUILD_DIR); \
	riscv64-linux-gnu-gcc -Wall -O2 -static -DN=$(N) -DITER=$(ITER) -I$(M5_INC) $(SRC_DIR)/fft_precompute.c $(M5_LIB) -lm -o fft_precompute.riscv

compile_all: compile_fft_recursive compile_fft_iterative compile_fft_precompute

simulate_fft_recursive:
	mkdir --parents $(BUILD_DIR)/fft_recursive; \
	cd $(BUILD_DIR)/fft_recursive; \
	gem5.opt $(SRC_DIR)/RISCV_se.py -b $(BUILD_DIR)/fft_recursive.riscv

simulate_fft_iterative:
	mkdir --parents $(BUILD_DIR)/fft_iterative; \
	cd $(BUILD_DIR)/fft_iterative; \
	gem5.opt $(SRC_DIR)/RISCV_se.py -b $(BUILD_DIR)/fft_iterative.riscv

simulate_fft_precompute:
	mkdir --parents $(BUILD_DIR)/fft_precompute; \
	cd $(BUILD_DIR)/fft_precompute; \
	gem5.opt $(SRC_DIR)/RISCV_se.py -b $(BUILD_DIR)/fft_precompute.riscv

simulate_all: simulate_fft_recursive simulate_fft_iterative simulate_fft_precompute

result_fft_recursive:
	mkdir --parents $(BUILD_DIR)/fft_recursive; \
	cd $(BUILD_DIR)/fft_recursive; \
	grep -e "simInsts" \
	-e "numCycles" \
	-e "board.processor.cores.core.commit.committedInstType_0::MemRead" \
	-e "board.processor.cores.core.commit.committedInstType_0::MemWrite" \
	-e "board.processor.cores.core.branchPred.committed_0::total" \
	-e "board.processor.cores.core.commit.committedInstType_0::Int" \
	-e "board.processor.cores.core.commit.committedInstType_0::Float" \
	m5out/stats.txt

result_fft_iterative:
	mkdir --parents $(BUILD_DIR)/fft_iterative; \
	cd $(BUILD_DIR)/fft_iterative; \
	grep -e "simInsts" \
	-e "numCycles" \
	-e "board.processor.cores.core.commit.committedInstType_0::MemRead" \
	-e "board.processor.cores.core.commit.committedInstType_0::MemWrite" \
	-e "board.processor.cores.core.branchPred.committed_0::total" \
	-e "board.processor.cores.core.commit.committedInstType_0::Int" \
	-e "board.processor.cores.core.commit.committedInstType_0::Float" \
	m5out/stats.txt

result_fft_precompute:
	mkdir --parents $(BUILD_DIR)/fft_precompute; \
	cd $(BUILD_DIR)/fft_precompute; \
	grep -e "simInsts" \
	-e "numCycles" \
	-e "board.processor.cores.core.commit.committedInstType_0::MemRead" \
	-e "board.processor.cores.core.commit.committedInstType_0::MemWrite" \
	-e "board.processor.cores.core.branchPred.committed_0::total" \
	-e "board.processor.cores.core.commit.committedInstType_0::Int" \
	-e "board.processor.cores.core.commit.committedInstType_0::Float" \
	m5out/stats.txt

clean:
	rm -rf $(BUILD_DIR)
