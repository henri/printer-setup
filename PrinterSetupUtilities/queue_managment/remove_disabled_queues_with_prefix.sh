#!/bin/bash

## This script relies upon the tempoary storage structures being enabled.
##
## This script will remove queues which have matching prefixes in the queue names
## and also are not enabled with this cnfiguraton of PrinterSetup. 
##
## Basically this script removes any old queues which were managed with a prefix.
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
##       Look at the list of queues which are 
##       Save queue names on the system which have queue names begining with the prefix.
##


# Version 0001
# Requires Printer Setup Version 0025 or later
#

#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

# Input Varibles
temp_all_system_queue_names_with_prefixt_but_not_enabled_file="${temp_all_system_queue_names_with_prefixt_but_not_enabled_file}"
printer_name_prefix="$printer_name_prefix"
printer_name_prefix_delimiter="$printer_name_prefix_delimiter"
printer_setup_log="$printer_setup_log"


#########################    INTERNAL VARIBLES    #########################
#
# These Varibles are only used in this script
#

current_queue_name_to_remove=""
printer_prefix_complete_with_delimiter="${printer_name_prefix}${printer_name_prefix_delimiter}"


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
    
    # Check the required enviroment varibles are availible 
    if [ "$temp_all_system_queue_names_with_prefixt_but_not_enabled_file" == "" ] || [ "$printer_name_prefix_delimiter" == "" ] || [ "$printer_name_prefix" == "" ]  ; then
        echo "        ERROR!: Required enviroment varibles are not availible." | tee -ai "$printer_setup_log"
        exit -127
    fi
    
    if ! [ -f "$temp_all_system_queue_names_with_prefixt_but_not_enabled_file" ] ; then
        echo "        ERROR!: Required file is not availible." | tee -ai "$printer_setup_log"
        echo "                The file which should contain the list of queues to remove is not availible." | tee -ai "$printer_setup_log"
        echo "                Therefore, no print queues have been removed from this system." | tee -ai "$printer_setup_log"
        exit -127
    fi
       
}


function remove_current_print_queue {

    # Check there is a printer to remove
    if [ "${current_queue_name_to_remove}" != "" ] ; then
        # Remove the Current Printer
        lpadmin -x "${current_queue_name_to_remove}"
        if [ $? != 0 ] ; then
            echo "    ERROR! : Removing print queue : \""${current_queue_name_to_remove}"\"" | tee -ai "$printer_setup_log"
        fi
    fi
    
}


function remove_queues_as_specified_in_the_input_file {
    
    # Make sure this is blank.
    current_queue_name_to_remove=""

    # Set the input file
    exec < "$temp_all_system_queue_names_with_prefixt_but_not_enabled_file"
    
    # Read Each Line From the Input File and then call the remove printer command for this file.
    while true ; do
		read LINE || break
		current_queue_name_to_remove="${LINE}"

        # Double Check This Queue Has the Same Prefix We Are Looking For.
        double_check_we_are_removing_the_current_print_queue=`echo "$current_queue_name_to_remove" | grep -e "^${printer_prefix_complete_with_delimiter}"`
		if [ "$double_check_we_are_removing_the_current_print_queue" != "" ] ; then
            # Remove The Current Printer - We have now checked twice that it has the same prefix.
            remove_current_print_queue
        fi
	done 
    

}



#############################      LOGIC      #############################
#
# Locic controlling this Script


pre_flight_checks 
remove_queues_as_specified_in_the_input_file


exit 0
