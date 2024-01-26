#!/bin/bash

# This file is to setup a new build machine for RPACP_OS (Raspberry Pi Apple CarPlay Operating System)
# This script is tested on Ubuntu 22.04 LTS
# This script should be run as root only once after a fresh installation of Ubuntu 22.04 LTS

# Author: Malek Khlif (malek.khlif@outlook.com)
# Date: 26 Januray 2024
# Version: 1.0
# License: GPLv3

# Script arguments:
#   -h: help
#   -c: clean

##############################
##############################
##############################

################################################################################
# Global variables

PROJECT_NAME="RPACP_OS"
PROJECT_VERSION="1.0"
################################################################################

################################################################################
# Function Name: printMessage
#
# Description:
#   This function is used to print a message in a specific format.
#
# Parameters:
#   $1 - message: Message to be printed.
#   $2 - type: Type of the message. It can be one of the following:
#       - 0: INFO
#       - 1: WARNING
#       - 2: ERROR
#
# Usage:
#   printMessage "This is a message" 0
################################################################################
function printMessage {
    local message=$1
    local type=$2
    local timestamp=$(date +'%H:%M:%S - %d/%m/%Y')
    
    local red='\033[0;31m'
    local green='\033[0;32m'
    local yellow='\033[0;33m'
    local NC='\033[0m' # No Color

    case $type in
        0)
            echo -e "[${PROJECT_NAME}] - [${timestamp}] - ${green}[INFO]${NC} - ${message}"
            ;;
        1)
            echo -e "[${PROJECT_NAME}] - [${timestamp}] - ${yellow}[WARNING]${NC} - ${message}"
            ;;
        2)
            echo -e "[${PROJECT_NAME}] - [${timestamp}] - ${red}[ERROR]${NC} - ${message}"
            ;;
        *)
            echo -e "[${PROJECT_NAME}] - [${timestamp}] - ${red}[ERROR]${NC} - ${message}"
            ;;
    esac
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
    printMessage "Usage: ${0} [-h]\n
    \t-h: help\n" 0
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
        printMessage "No arguments provided. Please specify options." 2
        print_help
        exit 1
    fi    

    while getopts "h" opt; do
        case ${opt} in
            h )
                print_help
                exit 0
                ;;
            \? )
                printMessage "Invalid Option: -$OPTARG" 2
                print_help
                exit 1
                ;;
            : )
                printMessage "Invalid Option: -$OPTARG requires an argument" 2
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

