#!/bin/bash

# This file is the entry point to build the operating system of the RPACP (RaspberryPiAppleCarPlay) project.
# It will build the kernel, the bootloader, and the rootfs.

# Author: Malek Khlif (malek.khlif@outlook.com)
# Date: 3 February 2024
# Version: 1.0
# License: GPLv3

# Script arguments:
#   -p, --path <path>: The path to build the operating system. Default is "/tmp/RPACP_OS".
#   -b, --build <recipe>: The recipe to build. Default is "all".
#   -c, --clean: Clean the build directory.
