set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR ARM)

# set toolchain path
set(CGT_ROOT "/opt/homebrew/bin")
# set stm32 header include path
set(STM32CUBEF4_BASE "/Applications/stm/f411/STM32CubeF4")
# set chip specific definitions
set(MCU STM32F411xE)

set(
  STM32CUBEF4_INCLUDE
  ${STM32CUBEF4_BASE}/Drivers/CMSIS/Device/ST/STM32F4xx/Include
  ${STM32CUBEF4_BASE}/Drivers/CMSIS/Core/Include
)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

message(STATUS "Discovering cgt executables.")
# find avr toolchain programs
find_program(ARM_CC NAMES arm-none-eabi-gcc PATHS ${CGT_ROOT} NO_DEFAULT_PATH)
find_program(ARM_CXX NAMES arm-none-eabi-g++ PATHS ${CGT_ROOT} NO_DEFAULT_PATH)
find_program(ARM_SIZE NAMES arm-none-eabi-size PATHS ${CGT_ROOT} NO_DEFAULT_PATH)
find_program(OPENOCD NAMES openocd PATHS ${CGT_ROOT} NO_DEFAULT_PATH)

message(STATUS "Setting compilers.")
set(CMAKE_C_COMPILER ${ARM_CC})
set(CMAKE_CXX_COMPILER ${ARM_CXX})
set(CMAKE_ASM_COMPILER ${AVR_CC})

get_filename_component(OPENOCD_CONFIG ${CMAKE_CURRENT_LIST_DIR}/stm32f4discovery-stlink-v2-1.cfg ABSOLUTE)

set(SHARED_OPTIONS "-mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffreestanding -ffunction-sections -fdata-sections")
set(CMAKE_C_FLAGS_INIT "${SHARED_OPTIONS}" CACHE INTERNAL "Initial options for C compiler.")
set(CMAKE_CXX_FLAGS_INIT "${SHARED_OPTIONS}" CACHE INTERNAL "Initial options for C++ compiler.")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--gc-sections" CACHE INTERNAL "Initial options for executable linker.")