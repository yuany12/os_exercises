################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
O_SRCS += \
../obj/bootblock.o 

ASM_SRCS += \
../obj/bootblock.asm \
../obj/kernel.asm 

OBJS += \
./obj/bootblock.o \
./obj/kernel.o 


# Each subdirectory must supply rules for building sources it contributes
obj/%.o: ../obj/%.asm
	@echo 'Building file: $<'
	@echo 'Invoking: Cross GCC Assembler'
	as  -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


