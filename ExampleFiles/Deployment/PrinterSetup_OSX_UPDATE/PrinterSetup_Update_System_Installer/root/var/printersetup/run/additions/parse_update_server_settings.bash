#!/bin/bash

## System to parses the server_settings file and returns the contained values
## This is a utility component of the Printer Setup Update System.
##
##//////////////////////////////////////////////////////////
## 
## Copyright 2008 © Henri Shustak GNU GPL
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
# Version 0001 : initial implimentation
#
#


#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

file_to_parse=$1
search_key=$2
return_string=""

printersetup_update_log_file="${printersetup_update_log_file}"

# Check log file exists 
if ! [ -f "$printersetup_update_log_file" ] ; then
    printersetup_update_log_file=/dev/null
fi

# Check the Varibles were supplied - this needs to be fixed - it is currently not working
if [ "$file_to_parse" == "" ] || [ "$search_key" == "" ] ; then
    echo "    WARNING!: Invalid arguments specified" | tee -ai "$printersetup_update_log_file"
    echo "              Usage   : parse_update_server_settings.bash \"/absolute/path/to/update_server_search_keys.config\" \"search_key\"" | tee -ai "$printersetup_update_log_file"
    echo "              Example : parse_update_server_settings.bash \"/var/printersetup/run/additions/update_server_search_keys.config\" \"Remote Path\"" | tee -ai "$printersetup_update_log_file"
    exit -127
fi

# Check the file_to_parse exists
if ! [ -f "$file_to_parse" ] ; then
    echo "    ERROR!: File to is not availible." | tee -ai "$printersetup_update_log_file"
    echo "            $file_to_parse" | tee -ai "$printersetup_update_log_file"
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
