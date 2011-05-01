#!/bin/bash

## Adds Printer To Pykota
##
##//////////////////////////////////////////////////////////
## 
## Copyright 2008 © Henri Shustak GNU GPL
##

# Version 0001

# HISTORY
#
# Version 0001 : initial implimentation : Basic Implementation
#
#


#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

printer_name=$1
printer_description=$2
printer_setup_log="$printer_setup_log"
return_string=""


# Check log file exists 
if ! [ -f "$printer_setup_log" ] ; then
    printer_setup_log=/dev/null
fi

# Check the Varibles were supplied - this needs to be fixed - it is currently not working
if [ "$printer_name" == "" ] || [ "$printer_description" ="" ] ; then
    echo "    WARNING!: Invalid arguments specified" | tee -ai "$printer_setup_log"
    echo "              Usage   : ./AddPrinter.sh \"printer_name\" \"printer_description\"" | tee -ai "$printer_setup_log"
    echo "              Example : ./AddPrinter.sh \"AdminCopier\" \"Copier in the Admin Office\"" | tee -ai "$printer_setup_log"
    exit -127
fi

#############################    FUNCTIONS    #############################
#
# Functions called in this script


function add_printer {
        
        # Setup Printer with no Description
        pkprinters --add --description "${printer_description}" ${printer_name} | tee -ai "$printer_setup_log"
        if [ $? != 0 ] ; then
            echo "    ERROR! : Adding Printer to Pykota" | tee -ai "$printer_setup_log"
            exit -127
        fi
        
}
             

#############################      LOGIC      #############################
#
# Locic controlling this Script

add_printer


exit 0
