# STM32F411 Toolchain

Modified: 2022-10

A toolchain for baremetal development of STM32F411 microcontrollers.

## Navigation
1. [Software Requirements](#software-requirements)
2. [Quickstart](#quickstart)
3. [License](#license)

## Software Requirements
This toolchain leverages the following software tools:
 - [CMake](https://cmake.org) (Build system)
 - [ARM GCC](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) (Code generation toolchain)
 - [STM32CubeF4](https://www.st.com/en/embedded-software/stm32cubef4.html) (STM microcontroller header files)
 - [OpenOCD](https://openocd.org) (Open source on-chip debugger)

For installation instructions see the [developers guide](./dev/README.md)

## Quickstart
Clone this repository and navigate to the repository root:
```bash
git clone git@github.com:dronectl/stm32f411-toolchain.git
cd stm32f411-toolchain
```
Initialize the build system using `cmake`:
```bash
mkdir build
cd build
# pass the basepath of the STM32CUBEF4 install directory
cmake .. -DSTM32CUBEF4_BASE=/path/to/STM32CubeF4
...
```
Compile the firmware
```bash
make -j
...
```
Plugin the evaluation board to your PC over mini USB and flash the microcontroller over UART:
```bash
make flash
```
> OpenOCD automatically detects STLINK debugger interfaces over USB. 

![img](/docs/demo.gif)

## License
This project is licensed under the terms of the [MIT License](LICENSE)