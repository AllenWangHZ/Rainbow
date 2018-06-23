TCDIR = /home/ferdinand/.local/gcc-arm-none-eabi
PREFIX = $(TCDIR)/bin/arm-none-eabi-

GCC     = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump
SIZE    = $(PREFIX)size
GDB     = $(PREFIX)gdb

#CFLAG += -v
CFLAG += -Wall -g -ggdb
CFLAG += -mcpu=cortex-m4 -mlittle-endian -mthumb
CFLAG += -nostartfiles -fno-builtin -nostdlib
CFLAG += -Iuser/inc/ -Iboard/inc/ -Isoc/cmsis/inc -Isoc/driver/inc
CFLAG += -Tstm32f407vg.ld

BUILD_DIR = build
$(shell mkdir -p $(BUILD_DIR))
$(shell mkdir -p $(BUILD_DIR)/.obj)

OBJ_PATH  = $(BUILD_DIR)/.obj
SRC_PATH  = user/src board/src soc/cmsis/src soc/driver/src/

SRC = $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*, .c .s)))
OBJ = $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

CSRC  = $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*, .c)))
CDEPS = $(addprefix $(OBJ_PATH)/, $(addsuffix .d, $(notdir $(basename $(CSRC)))))

vpath %.s $(SRC_PATH)
vpath %.c $(SRC_PATH)

main: $(OBJ)
	$(GCC) $(CFLAG) $^ -o $(BUILD_DIR)/main.elf
	$(SIZE) $(BUILD_DIR)/main.elf
	$(OBJCOPY) -O binary $(BUILD_DIR)/main.elf $(BUILD_DIR)/main.bin
	$(OBJDUMP) -S $(BUILD_DIR)/main.elf > $(BUILD_DIR)/main.asm

$(OBJ_PATH)/%.o: %.s
	@$(GCC) $(CFLAG) -c $< -o $@
	@echo compiling $(notdir $<)
$(OBJ_PATH)/%.o: %.c
	@$(GCC) $(CFLAG) -c $< -o $@
	@echo compiling $(notdir $<)
$(OBJ_PATH)/%.d: %.c
	@$(GCC) $(CFLAG) -MM $< | sed "s|$(notdir $(basename $@)).o:|$@ $(basename $@).o:|" >$@
	@echo depend $(notdir $@)

-include $(CDEPS)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: debug
debug: $(BUILD_DIR)/main.elf
	$(GDB) $< -q
