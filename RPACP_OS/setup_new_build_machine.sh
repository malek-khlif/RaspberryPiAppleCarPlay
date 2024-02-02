#!/bin/bash

# This file is to setup a new build machine for RPACP_OS (Raspberry Pi Apple CarPlay Operating System)
# This script is tested on Ubuntu 22.04 LTS
# This script should be run as root only once after a fresh installation of Ubuntu 22.04 LTS

# Author: Malek Khlif (malek.khlif@outlook.com)
# Date: 3 February 2024
# Version: 1.0
# License: GPLv3

# Script arguments:
#   -h: help
#   -i: install
#   -u: uninstall

##############################
##############################
##############################

################################################################################
# Global variables

PROJECT_NAME="RPACP_OS"
PROJECT_VERSION="1.0"
PROJECT_FULL_NAME="${PROJECT_NAME} v${PROJECT_VERSION}"

COMMAND=""

OS_MACHINE_CONFIGURED_FILE="/etc/RPACP_OS.machine.configured"

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
# Function Name: print_help
#
# Description:
#   This function is used to print the help message.
#
# Parameters:
#
# Usage:
#   print_help
################################################################################
function print_help {
    printMessage $INFO_MESSAGE_TYPE "Usage: ${0} [-h] [-i] [-u]\n
    \t-h: help      - Print this help message
    \t-i: install   - Install the necessary packages to build RPACP_OS
    \t-u: uninstall - Uninstall the necessary packages to build RPACP_OS"
}

################################################################################
# Function Name: parse_arguments
#
# Description:
#   This function is used to parse the arguments of the script.
#
# Parameters:
#
# Usage:
#   parse_arguments
################################################################################
function parse_arguments {
    declare opt
    declare OPTARG
    declare OPTIND

    # Check if no arguments were passed
    if [ $# -eq 0 ]; then
        printMessage $ERROR_MESSAGE_TYPE "No arguments provided. Please specify options."
        print_help
        exit 1
    fi    

    while getopts "hiu" opt; do
        case ${opt} in
            h )
                print_help
                exit 0
                ;;
            i )
                COMMAND="install"
                ;;
            u )
                COMMAND="uninstall"
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
# Function Name: apt_install_necessary_packages
#
# Description:
#   This function is used to install the necessary packages.
#
# Parameters:
#
# Usage:
#   apt_install_necessary_packages
################################################################################
function apt_install_necessary_packages {
    #FROM https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html#build-host-packages
    printMessage $INFO_MESSAGE_TYPE "Installing necessary packages..."

    if apt install -qq -y gcc g++ cmake make gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales libacl1; then
        printMessage $INFO_MESSAGE_TYPE "Package installation succeeded."
    else
        printMessage $ERROR_MESSAGE_TYPE "Package installation failed."
        exit 1
    fi

    locale-gen en_US.UTF-8

    touch ${OS_MACHINE_CONFIGURED_FILE}
}

################################################################################
# Function Name: apt_uninstall_necessary_packages
#
# Description:
#   This function is used to uninstall the necessary packages.
#
# Parameters:
#
# Usage:
#   apt_uninstall_necessary_packages
################################################################################
function apt_uninstall_necessary_packages {
    printMessage $INFO_MESSAGE_TYPE "Uninstalling necessary packages..."
    rm -f ${OS_MACHINE_CONFIGURED_FILE}
    printMessage $INFO_MESSAGE_TYPE "Package uninstallation succeeded."
}

################################################################################
# Script start
################################################################################

# Parse the arguments of the script
parse_arguments "$@"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    printMessage $ERROR_MESSAGE_TYPE "Please run as root"
    exit 1
fi

# Check if the COMMAND is empty
if [ -z "${COMMAND}" ]; then
    printMessage $ERROR_MESSAGE_TYPE "No arguments provided. Please specify options."
    print_help
    exit 1
fi

# If the COMMAND is install
if [ "${COMMAND}" == "install" ]; then
    apt_install_necessary_packages
elif [ "${COMMAND}" == "uninstall" ]; then
    apt_uninstall_necessary_packages
else
    printMessage $ERROR_MESSAGE_TYPE "Invalid command"
    print_help
    exit 1    
fi

