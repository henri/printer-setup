#!/bin/bash

## System to parses the printer aetup file and returns the contained values
## This is a utility component of the Printer Setup System.
##
##//////////////////////////////////////////////////////////
## 
## Copyright 2006 © Henri Shustak GNU GPL
##

########################################
##
##  What this script is going to do :
##
##       Export Arguments to this script it will then use these
##       arguments to perform a parse of a text file
##       for the appropriate informtion.
##

# Version 0001

# HISTORY
#
# Version 0001 : initial implimentation : Only Implimented PSS, not PSF
#
#


#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

file_to_parse=$1
search_key=$2
printer_setup_log="$printer_setup_log"
return_string=""


# Check log file exists 
if ! [ -f "$printer_setup_log" ] ; then
    printer_setup_log=/dev/null
fi

# Check the Varibles were supplied - this needs to be fixed - it is currently not working
if [ "$file_to_parse" == "" ] || [ "$search_key" == "" ] ; then
    echo "    WARNING!: Invalid arguments specified" | tee -ai "$printer_setup_log"
    echo "              Usage   : ./parsePSF.sh \"/absolute/path/to/PSFfile.conf\" \"search_key\"" | tee -ai "$printer_setup_log"
    echo "              Example : ./parsePSF.sh \"/Library/Tech Scripts/PrinterSetup/Printers/ROOM221.conf\" \"Printer Name\"" | tee -ai "$printer_setup_log"
    exit -127
fi

# Check the file_to_parse exists
if ! [ -f "$file_to_parse" ] ; then
    echo "    ERROR!: File to is not availible." | tee -ai "$printer_setup_log"
    echo "            $file_to_parse" | tee -ai "$printer_setup_log"
    exit -127
fi


#############################    FUNCTIONS    #############################
#
# Functions called in this script

function parse_the_file {
        
        # Take the file and parse it for the data
        return_string=`cat "$file_to_parse" | grep -v --regexp="^#" | grep --regexp="^$search_key" | awk 'BEGIN { FS = "\t" } ; { print $2$3$4$5$6$7 }'`
        if [ $? != 0 ] ; then
            echo "    ERROR! : while searching for key : $search_key"
            echo "             $file_to_parse "
            exit -127
        fi
        
}

function return_the_file {
        
        # Returns the information to the calling script via standard out
        echo "$return_string"
        
}
             

#############################      LOGIC      #############################
#
# Locic controlling this Script

parse_the_file
return_the_file

exit 0
