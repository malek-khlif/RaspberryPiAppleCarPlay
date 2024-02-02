#!/bin/bash

# This file is the entry point to build the operating system of the RPACP (RaspberryPiAppleCarPlay) project.
# It will build the kernel, the bootloader, and the rootfs.

# Author: Malek Khlif (malek.khlif@outlook.com)
# Date: 3 February 2024
# Version: 1.0
# License: GPLv3

# Script arguments:
#   -h, --help: Print the help message.
#   -p, --path <path>: The path to build the operating system. Default is "/tmp/RPACP_OS".
#   -b, --build <recipe>: The recipe to build. Default is "all".
#   -c, --clean: Clean the build directory.

################################################################################
# Global variables

PROJECT_NAME="RPACP_OS"
PROJECT_VERSION="1.0"
PROJECT_FULL_NAME="${PROJECT_NAME} v${PROJECT_VERSION}"

OS_MACHINE_CONFIGURED_FILE="/etc/RPACP_OS.machine.configured"

PATH_TO_BUILD="/tmp/RPACP_OS"
RECIPE_TO_BUILD="all"
COMMAND="build"

INFO_MESSAGE_TYPE=0
WARNING_MESSAGE_TYPE=1
ERROR_MESSAGE_TYPE=2
################################################################################

################################################################################
# Function Name: printMessage
#
# Description:
#   This function is used to print a message in a specific format.
#
# Parameters:
#   $1 - Type of the message. It can be one of the following:
#       - INFO_MESSAGE_TYPE
#       - WARNING_MESSAGE_TYPE
#       - ERROR_MESSAGE_TYPE
#
#   $2 - message: Message to be printed.
#
# Usage:
#   printMessage $INFO_MESSAGE_TYPE "This is an info message"
################################################################################
function printMessage {
    local type=$1
    local message=$2
    local timestamp=$(date --iso-8601=seconds)

    local reset_color="\033[0m"
    local green_color="\033[32m"
    local yellow_color="\033[33m"
    local red_color="\033[31m"
    local color="$reset_color"

    local log_level=""

    case $type in
        $INFO_MESSAGE_TYPE)
            color=$green_color
            log_level="INFO"
            ;;
        $WARNING_MESSAGE_TYPE)
            color=$yellow_color
            log_level="WARNING"
            ;;
        $ERROR_MESSAGE_TYPE)
            color=$red_color
            log_level="ERROR"
            ;;
        *)
            color=$red_color
            log_level="ERROR"
            ;;
    esac

    echo -e "[${timestamp}] - [${PROJECT_FULL_NAME}] - ${color}[${log_level}]${reset_color} - ${message}"
}

################################################################################
# Function Name: printUsage
#
# Description:
#   This function is used to print the help message.
#
# Parameters:
#
# Usage:
#   printUsage
################################################################################
function printUsage {
    printMessage $INFO_MESSAGE_TYPE "Usage: ${0} [-h] [-p <path>] [-b <recipe>] [-c]
    \t-h: help      - Print this help message
    \t-p: path      - The path to build the operating system. Default is '/tmp/RPACP_OS'.
    \t-b: build     - The recipe to build. Default is "all".
    \t-c: clean     - Clean the build directory."
}

################################################################################
# Function Name: parseArguments
#
# Description:
#   This function is used to parse the arguments of the script.
#
# Parameters:
#
# Usage:
#   parseArguments
################################################################################
function parseArguments {
    declare opt
    declare OPTARG
    declare OPTIND

    while getopts "hpbc" opt; do
        case ${opt} in
            h )
                printUsage
                exit 0
                ;;

            p )
                PATH_TO_BUILD=$OPTARG
                ;;

            b )
                RECIPE_TO_BUILD=$OPTARG
                ;;

            c )
                COMMAND="clean"
                ;;

            \? )
                printMessage $ERROR_MESSAGE_TYPE "Invalid Option: -$OPTARG"
                print_help
                exit 1
                ;;
            : )
                printMessage $ERROR_MESSAGE_TYPE "Invalid Option: -$OPTARG requires an argument"
                print_help
                exit 1
                ;;                
        esac
    done
}

################################################################################
# Script start
################################################################################

# Parse the arguments of the script
parse_arguments "$@"