################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include src/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
dcmi_ctrl_example.elf.size \

ELFCHECK += \
dcmi_ctrl_example.elf.elfcheck \


# All Target
all: dcmi_ctrl_example.elf secondary-outputs

# Tool invocations
dcmi_ctrl_example.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: PowerPC gcc linker
	powerpc-eabi-gcc -Wl,-T -Wl,../src/lscript.ld -L../../master_burst_example_bsp/ppc440_0/lib -mcpu=440 -o"dcmi_ctrl_example.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

dcmi_ctrl_example.elf.size: dcmi_ctrl_example.elf
	@echo Invoking: PowerPC Print Size
	powerpc-eabi-size dcmi_ctrl_example.elf  |tee "dcmi_ctrl_example.elf.size"
	@echo Finished building: $@
	@echo ' '

dcmi_ctrl_example.elf.elfcheck: dcmi_ctrl_example.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck dcmi_ctrl_example.elf -hw ../../ppc_dcmi_devl_hw_platform/system.xml -pe ppc440_0  |tee "dcmi_ctrl_example.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) dcmi_ctrl_example.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
