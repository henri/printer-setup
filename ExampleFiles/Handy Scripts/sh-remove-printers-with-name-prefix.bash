#!/bin/bash

##
## This script will remove queues which have matching prefixes 
## in the queue names.
##
## If you want to remove queues with the prefix you specify then 
## this is the script for you
##
##//////////////////////////////////////////////////////////
## 
## Copyright 2008 © Henri Shustak GNU GPL
## http://www.lucidsystems.org/printingworks/printersetup
##


########################################
##
##  What this script is going to do :
##
##       Remove queue names on this system which have queue names with the specified prefix.
##       You can specify multiple prefixes to clean out various prefixes with one call to this script
##       Essentially, this script processes each argument as a queue name prefix and removes any
##       queues which have matching prefixes queue names.
##


# Version 0001
#

#############################   Settings    #############################
#
# User configurable options
#

printer_name_prefix_delimiter="-"
printer_setup_log="$printer_setup_log"


#########################    INTERNAL VARIBLES    #########################
#
# These Varibles are only used in this script
#

script_return_value=0
num_arguments=$#

#############################    FUNCTIONS    #############################
#
# Functions called in this script


function pre_flight_checks {
        
    # Check we are running as root
    currentUser=`whoami`
    if [ $currentUser != "root" ] ; then
        echo This script must be run with super user privileges
        exit -127
    fi
        
    # Check log file exists 
    if ! [ -f "$printer_setup_log" ] ; then
        printer_setup_log=/dev/null
    fi
    
    if ! [ $num_arguments -ge 1 ] ; then
        echo "ERROR! : You must specify at least one printer name prefix"
        echo "         Usage : ./sh-remove-printers-with-prefix.bash MYQUEUEPREFIX"
        exit -126
    fi
           
}


function remove_print_queue_with_specified_prefix {


    # Skip past problematic printers
    bypass_level=1
    
    # How many times we have tried to remove a printer
    run_level=1
    
    # Number of printers on this system
    number_of_printers_to_remove_from_system=`lpstat -v 2> /dev/null | cut -d' ' -f3 | awk -F ":" '{print $1}' | grep -e "^${printer_prefix_complete_with_delimiter}" | wc -l | awk '{ print $1 }'`

    # This method should deal version of cups which dose not make a printcap file
    printers_with_prefix_exist=0
    
    while [ ${run_level} -le ${number_of_printers_to_remove_from_system} ] ; do
    
        printer_to_delete=`lpstat -v 2> /dev/null | cut -d' ' -f3 | awk -F ":" '{print $1}' | grep -e "^${printer_prefix_complete_with_delimiter}" | head -n ${bypass_level} | tail -n 1`
        if [ $? != 0 ] || [ "${printer_to_delete}" == "" ] ; then
            echo "ERROR! : Unable to determine the next printers which should be removed from the system"
            echo "         No more printers will be removed by this execution of this script"
            script_return_value=-127
            break
        fi 
        
        
        
        # delete the printer
        lpadmin -x "${printer_to_delete}" > /dev/null 2>&1
        if [ $? != 0 ] ; then
            echo "ERROR! : Removing : $printer_to_delete"
            echo "         Removal of this print queue has been skipped."
            ((bypass_level++))
            script_return_value=-1
        fi
        
        # Finished a run
        ((run_level++))
    done

}




#############################      LOGIC      #############################
#
# Locic controlling this Script



pre_flight_checks

# Process each argument and remove any queues which have a matching prefix name 
while [ $# -ge 1 ] ; do

    # process the current argument    
    printer_name_prefix="${1}"
    printer_prefix_complete_with_delimiter="${printer_name_prefix}${printer_name_prefix_delimiter}"

    # Remove some queues with this prefix
    remove_print_queue_with_specified_prefix
    
    #shuffle these arguments along
    shift
    if [ $? != 0 ] ; then
        echo "ERROR! : Processing Input Arguments"
        script_return_value=-126
        break
    fi
    
done


exit $script_return_value

