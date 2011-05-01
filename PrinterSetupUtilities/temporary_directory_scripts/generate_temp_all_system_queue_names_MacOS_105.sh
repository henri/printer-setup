#!/bin/bash

## Generate a file containing each print queue name on this system
## We also generate a file which contains all queue names which being with
## the prefix specifed in PrinterSetup.
##
## If no prefix is defined, then prifinx will have been disabled and an empty
## file is created.
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
##       Save queue names of the cups print queues on this machine.
##       Save queue names on the system which have queue names begining with the prefix.
##


# Version 0002
# Requires Printer Setup Version 0025 or later
#

#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

# Output File Varibles
temp_all_system_queue_names_file="${temp_all_system_queue_names_file}"
temp_all_system_queue_names_with_prefix_file="$temp_all_system_queue_names_with_prefix_file"
temp_all_system_queue_names_with_prefixt_but_not_enabled_file="$temp_all_system_queue_names_with_prefixt_but_not_enabled_file"


# Other Required Enviroment Varibles
printer_name_prefix="$printer_name_prefix"
printer_name_prefix_delimiter="$printer_name_prefix_delimiter"
printer_prefixing="$printer_prefixing"
temp_details_enabled_unique_print_queue_names_file="$temp_details_enabled_unique_print_queue_names_file"
printer_setup_log="$printer_setup_log"



#############################    FUNCTIONS    #############################
#
# Functions called in this script

function pre_flight_checks {
        
    # Check log file exists 
    if ! [ -f "$printer_setup_log" ] ; then
        printer_setup_log=/dev/null
    fi
    
    # Check the required enviroment varibles are availible 
    if [ "$temp_all_system_queue_names_file" == "" ] || [ "$printer_name_prefix" == "" ] || [ "$printer_name_prefix_delimiter" == "" ] || [ "$temp_all_system_queue_names_with_prefix_file" == "" ] || [ "$temp_all_system_queue_names_with_prefixt_but_not_enabled_file" == "" ] || [ "$temp_details_enabled_unique_print_queue_names_file" == "" ]  ; then
        # Do not exit if the "temp_all_system_queue_names_file" is set and pre fixing is disabled.
        if [ "$temp_all_system_queue_names_file" == "" ] || [ "${printer_prefixing}" == "YES" ] ; then
            echo "        ERROR!: Required enviroment varibles are not availible." | tee -ai "$printer_setup_log"
            exit -127
        fi
    fi
       
}



function generate_system_printers_with_queue_name_prefix {

    if [ "${printer_prefixing}" == "YES" ] ; then
        prefix_and_delimiter="${printer_name_prefix}${printer_name_prefix_delimiter}"
        grep -e "^${prefix_and_delimiter}" "${temp_all_system_queue_names_file}" >> "${temp_all_system_queue_names_with_prefix_file}"
    fi
        
}


function generate_printers_matching_prefix_but_are_not_enabled {

    if [ "${printer_prefixing}" == "YES" ] ; then
        grep -vx -f "${temp_details_enabled_unique_print_queue_names_file}" "${temp_all_system_queue_names_with_prefix_file}" >> "${temp_all_system_queue_names_with_prefixt_but_not_enabled_file}"
    fi 

}


function generate_system_printers_queue_name_file_and_others {
    # Creates the Printer Using the Information Parsed from the Printer Setup File
   
    lpstat -p 2> /dev/null | awk '{ print $2 }' >> "${temp_all_system_queue_names_file}"  
    if [ $? != 0 ] ; then
        echo "    No printers have been configured on this system." | tee -ai "$printer_setup_log"
    else
        generate_system_printers_with_queue_name_prefix
    fi
   
    # make sure this prefix file exists - somthing else may expect to see it. 
    # Therefore we will make this file - regardless of wheather prefixing is enabled - 
    touch "${temp_all_system_queue_names_with_prefix_file}"
    
    generate_printers_matching_prefix_but_are_not_enabled
    
    # make sure this prefix file exists - somthing else may expect to see it. 
    # Therefore we will make this file - regardless of wheather prefixing is enabled - 
    touch "${temp_all_system_queue_names_with_prefixt_but_not_enabled_file}"

}




#############################      LOGIC      #############################
#
# Locic controlling this Script


pre_flight_checks 
generate_system_printers_queue_name_file_and_others


exit 0
