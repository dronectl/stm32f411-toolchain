cmake_minimum_required(VERSION 3.2)

set(application_name stm32f4test)

if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "ARM")
    set(building_for_target true)
    set(building_for_host false)
else()
    set(building_for_target false)
    set(building_for_host true)
endif()

set(target_base_name ${application_name}_firmware)
project(${target_base_name} CXX)

set(elf_file ${target_base_name}.elf)

file(GLOB sources *.cpp)
add_executable(${elf_file} ${sources})
target_link_libraries(${elf_file} PUBLIC stm32f4xx)

set(shared_options -Wall -Wextra -Os -nostdlib)
target_compile_options(${elf_file} PRIVATE ${shared_options})
target_link_libraries(${elf_file} PRIVATE ${shared_options})

target_compile_options(${elf_file} PUBLIC -fno-exceptions)
target_compile_options(${elf_file} PUBLIC -fno-rtti)
target_compile_options(${elf_file} PUBLIC -std=c++11)

add_custom_target(${elf_file}-size DEPENDS ${elf_file} COMMAND ${ARM_SIZE_EXECUTABLE} -B -d --target=binary ${elf_file})

add_custom_target(${target_base_name} ALL DEPENDS ${elf_file}-size)

add_custom_target(flash_firmware DEPENDS ${elf_file}-size COMMAND ${OPENOCD_EXECUTABLE}
        -f ${OPENOCD_CONFIG}
        --command "program ${elf_file} verify reset exit")