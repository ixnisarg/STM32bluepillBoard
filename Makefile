#Read.mk for info about how make works
######################################
# target
######################################
TARGET ?= BluePillSTM32Board

######################################
# Tools Directory
######################################
PROJ_DIR = .
TOOLSDIR = $(PROJ_DIR)/tools

#######################################
# Build paths 
#######################################
BUILD_DIR = build
	   
#######################################
# Mysys commands
#######################################   
RM := $(TOOLSDIR)/msys/bin/rm -rf
MKDIR := $(TOOLSDIR)/msys/bin/mkdir
CP := $(TOOLSDIR)/msys/bin/cp
SED := $(TOOLSDIR)/msys/bin/sed
CAT := $(TOOLSDIR)/msys/bin/cat
MV := $(TOOLSDIR)/msys/bin/mv
GREP := $(TOOLSDIR)/msys/bin/grep
AWK := $(TOOLSDIR)/msys/bin/awk

#######################################
# GNU arm tool chain
#######################################   
PREFIX =$(TOOLSDIR)/toolchain/arm/bin/arm-none-eabi-
CC :=$(PREFIX)gcc
# AR and LD GCC Archive/loader 
AR := $(PREFIX)ar
LD := $(PREFIX)ld
AS := $(PREFIX)as

# GCC Utilities
SIZE := $(PREFIX)size
OBJCOPY := $(PREFIX)objcopy

######################################
# source files
######################################
#ASM sources
ASM_SRCS = \
startup_stm32f103xb.s

# C sources
C_SOURCES =  \
$(PROJ_DIR)/Src/main.c \
$(PROJ_DIR)/Src/user_diskio.c \
$(PROJ_DIR)/Src/fatfs.c \
$(PROJ_DIR)/Src/stm32f1xx_it.c \
$(PROJ_DIR)/Src/stm32f1xx_hal_msp.c \
$(PROJ_DIR)/drivers/STM32f1xx_HAL_Drivers/Src/stm32f1xx_hal_gpio_ex.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim_ex.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_spi_ex.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_spi.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c \
$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash_ex.c \
$(PROJ_DIR)/filesystem/src/option/syscall.c \
$(PROJ_DIR)/filesystem/src/diskio.c \
$(PROJ_DIR)/filesystem/src/ff.c \
$(PROJ_DIR)/filesystem/src/ff_gen_drv.c \
$(PROJ_DIR)/freeRTOSKernel/Source/portable/MemMang/heap_4.c \
$(PROJ_DIR)/freeRTOSKernel/Source/portable/GCC/ARM_CM3/port.c \
$(PROJ_DIR)/freeRTOSKernel/Source/event_groups.c \
$(PROJ_DIR)/freeRTOSKernel/Source/list.c \
$(PROJ_DIR)/freeRTOSKernel/Source/queue.c \
$(PROJ_DIR)/freeRTOSKernel/Source/tasks.c \
$(PROJ_DIR)/freeRTOSKernel/Source/timers.c \
$(PROJ_DIR)/freeRTOSKernel/Source/CMSIS_RTOS/cmsis_os.c \

# AS includes
AS_INCLUDES =  \
-I$(PROJ_DIR)/Inc

# C includes
C_INCLUDES =  \
-I$(PROJ_DIR)/Inc \
-I$(PROJ_DIR)/drivers/STM32f1xx_HAL_Drivers/Inc \
-I$(PROJ_DIR)/drivers/STM32F1xx_HAL_Driver/Inc/Legacy \
-I$(PROJ_DIR)/freeRTOSKernel/Source/portable/GCC/ARM_CM3 \
-I$(PROJ_DIR)/drivers/CMSIS/Device/ST/STM32F1xx/Include \
-I$(PROJ_DIR)/drivers/cmsis/Device/STM32F1xx/Include \
-I$(PROJ_DIR)/filesystem/src \
-I$(PROJ_DIR)/freeRTOSKernel/Source/include \
-I$(PROJ_DIR)/freeRTOSKernel/Source/CMSIS_RTOS \
-I$(PROJ_DIR)/drivers/cmsis/Include


HEX = $(CP)  ihex
BIN = $(CP)  binary -S

#################################
# Flags
#################################
# C flags
CPU = -mcpu=cortex-m3 -mthumb 
# C defines
C_DEFS = -DUSE_HAL_DRIVER -DSTM32F103xB
#.S Flags
AS_DEFS = 

OPT = -Og
# compile gcc flags
ASFLAGS =$(CPU) $(AS_DEFS) $(AS_INCLUDES) -Wall 
CFLAGS =$(CPU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections -mno-thumb-interwork -mfpu=vfp -msoft-float -mfix-cortex-m3-ldrd

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"
CFLAGS += -g -gdwarf-2
# link script
LDSCRIPT = STM32F103C8Tx_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = -specs=nano.specs -T$(LDSCRIPT) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

.PHONY : all clean

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf #$(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin
	
#######################################
# object lists
#######################################
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SRCS:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SRCS)))

$(BUILD_DIR)/%.o: %.c #Makefile | $(BUILD_DIR)
	$(MKDIR) -p $(BUILD_DIR)	
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s #Makefile | $(BUILD_DIR)
	$(AS) -c $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@echo "SIZE:" $(SZ) $@

#$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
#	$(HEX) $< $@
	
#$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
#	$(BIN) $< $@	

clean:
	$(RM) $(BUILD_DIR)