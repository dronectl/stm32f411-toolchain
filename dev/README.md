# Developers Guide

Modified: 2022-11

## Navigation
1. [Toolchain Installation](#toolchain-installation)
2. [STM32 Headers](#stm32-headers)

## Toolchain Installation

### MacOSX
Get the CMSIS `arm-none-eabi-gcc` binary for ARM Cortex microcontrollers:
```bash
brew install --cask gcc-arm-embedded
```

### Windows
TODO

## STM32 Headers
Get the STM32 headers from github. This includes CMSIS directives:
```bash
git clone git@github.com:STMicroelectronics/STM32CubeF4.git
```

I chose to use these header definitions since it does not force us to use the HAL APIs. This will allow us to program using standard bitwise operations.

> Note: This repository contains a ton of extra overhead meant for CubeIDE and other toolchains. This has no effect on the binary size since only what we include (and subsequent includes) will be used.

## VSCode Configuration
TODO