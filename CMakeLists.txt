cmake_minimum_required(VERSION 3.2)

enable_language(C ASM)
# global project name
set(PROJECT_NAME "stm-tc-demo")
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)


# cmake build guard
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

project(
  ${PROJECT_NAME}
  LANGUAGES C ASM
  VERSION "1.0.0"
  DESCRIPTION "STM32F411 CMake Toolchain Demo."
)

add_executable(
  ${PROJECT_NAME}
  src/main.c
  src/system_stm32f4xx.c
  src/startup_stm32f411vetx.s
)
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${PROJECT_NAME}.elf)
target_compile_definitions(
  ${PROJECT_NAME}
  PRIVATE
  -D${MCU}
  -DSTM32F411VETx
  -DSTM32F411E_DISCO
)
target_include_directories(${PROJECT_NAME} PUBLIC ${STM32CUBEF4_INCLUDE})

target_compile_options(
  ${PROJECT_NAME}
  PRIVATE
  -mcpu=cortex-m4
  -mthumb
  -mfpu=fpv4-sp-d16
  -mfloat-abi=hard
  -fdata-sections
  -ffunction-sections
  -Wpedantic
  -Wall
  -g
  -Wextra
  -Wno-unused-parameter
  $<$<CONFIG:Debug>:-Og>
)

target_link_options(
  ${PROJECT_NAME}
  PRIVATE
  -T${LINKER_SCRIPT}
  -mcpu=cortex-m4
  -mthumb
  -mfpu=fpv4-sp-d16
  -mfloat-abi=hard
  -specs=nano.specs
  -lnosys
  -Wl,-Map=${PROJECT_NAME}.map,--cref
  -Wl,--gc-sections
  -Wl,--print-memory-usage
)

message(STATUS "Adding custom targets")
add_custom_target(
  ${PROJECT_NAME}-size ALL DEPENDS ${PROJECT_NAME} COMMAND ${ARM_SIZE} -B -d --target=binary ${PROJECT_NAME}.elf
)
add_custom_target(hex ALL ${ARM_OBJCPY} -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex DEPENDS ${PROJECT_NAME})
add_custom_target(bin ALL ${ARM_OBJCPY} -O binary -S ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin DEPENDS ${PROJECT_NAME})
add_custom_target(objdump ${ARM_OBJDUMP} -S ${PROJECT_NAME}.elf DEPENDS ${PROJECT_NAME})
add_custom_target(
  flash DEPENDS ${PROJECT_NAME}-size
  COMMAND ${OPENOCD}
  -f ${OPENOCD_CONFIG}
)