cmake_minimum_required(VERSION 3.2)

# global project name
set(PROJECT_NAME "stm-tc-demo")

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
set(ELF_FILE ${PROJECT_NAME}.elf)
add_executable(
  ${PROJECT_NAME}
  src/main.c
)
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${PROJECT_NAME}.elf)
target_compile_definitions(
  ${PROJECT_NAME}
  PRIVATE
  -D${MCU}
)
target_include_directories(${PROJECT_NAME} PUBLIC ${STM32CUBEF4_INCLUDE})
set(SHARED_OPTIONS -Wall -Wextra -Os -nostdlib)
target_compile_options(${PROJECT_NAME} PRIVATE ${SHARED_OPTIONS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${SHARED_OPTIONS})
target_compile_options(${PROJECT_NAME} PUBLIC -fno-exceptions)

message(STATUS "Adding custom targets")
add_custom_target(
  ${PROJECT_NAME}-size DEPENDS ${ELF_FILE} COMMAND ${ARM_SIZE} -B -d --target=binary ${ELF_FILE}
)
add_custom_target(
  flash DEPENDS ${PROJECT_NAME}-size COMMAND ${OPENOCD}
  -f ${OPENOCD_CONFIG}
  --command "program ${ELF_FILE} verify reset exit"
)