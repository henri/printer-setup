#!/bin/bash

## This script builds looks for temporary PSF links and generates
## some files relating to the information stored in these PSF files
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
##       Save printer cups queue details to specified output files file
##

# Version 0002
# Requires Printer Setup Version 0025 or later
#

#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

printer_setup_log="$printer_setup_log"

# This is the file we call to make some files with details
temp_append_psf_details_to_file_script="$temp_append_psf_details_to_file_script"

# This is the directory which will contain the temporary links to PSF files we are setting up.
temp_details_symbolic_links_directory="$temp_details_symbolic_links_directory"

# Flag for Unique Detail File Generation
generate_unique_detail_files_local="YES"

# Input File Varibles
temp_details_enabled_print_queue_names_file="$temp_details_enabled_print_queue_names_file"
temp_details_enabled_print_queue_descriptions_file="$temp_details_enabled_print_queue_descriptions_file"
temp_details_enabled_print_queue_locations_file="$temp_details_enabled_print_queue_locations_file"
temp_details_enabled_print_queue_addresses_file="$temp_details_enabled_print_queue_addresses_file"

# Output Filie Varibles
temp_details_enabled_unique_print_queue_names_file="$temp_details_enabled_unique_print_queue_names_file"
temp_details_enabled_unique_print_queue_descriptions_file="$temp_details_enabled_unique_print_queue_descriptions_file"
temp_details_enabled_unique_print_queue_locations_file="$temp_details_enabled_unique_print_queue_locations_file"
temp_details_enabled_unique_print_queue_addresses_file="$temp_details_enabled_unique_print_queue_addresses_file"



#############################    FUNCTIONS    #############################
#
# Functions called in this script

function pre_flight_checks {

    
    # Check the psf_parsing_utility has been exported exits and is executable
    if ! [ -s "${temp_append_psf_details_to_file_script}" -a -x "${temp_append_psf_details_to_file_script}" ] ; then 
       echo "        ERROR!: Append PSF Details to File script is unable to be located or may not be executable" | tee -ai "$printer_setup_log"
       echo "                $temp_append_psf_details_to_file_script" | tee -ai "$printer_setup_log"
       exit -127
    fi
    
    # Check log file exists 
    if ! [ -f "$printer_setup_log" ] ; then
        printer_setup_log=/dev/null
    fi
    
    # Check the required input enviroment varibles are availible 
    if [ "$temp_details_enabled_print_queue_names_file" == "" ] ||  [ "$temp_details_enabled_print_queue_descriptions_file" == "" ] ||  [ "$temp_details_enabled_print_queue_locations_file" == "" ] ||  [ "$temp_details_enabled_print_queue_addresses_file" == "" ] ; then
        echo "        ERROR!: Required input enviroment varibles are not availible." | tee -ai "$printer_setup_log"
        exit -127
    fi
    
    # Check the required output enviroment varibles are availible 
    if [ "$temp_details_enabled_unique_print_queue_names_file" == "" ] ||  [ "$temp_details_enabled_unique_print_queue_descriptions_file" == "" ] ||  [ "$temp_details_enabled_unique_print_queue_locations_file" == "" ] ||  [ "$temp_details_enabled_unique_print_queue_addresses_file" == "" ] ; then
        echo "        ERROR!: Required output enviroment varibles are not availible." | tee -ai "$printer_setup_log"
        exit -127
    fi


}


function scan_temp_psf_links_dir_and_save_data {

    SEARCHDIR="$temp_details_symbolic_links_directory"
    SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PSF"  |  wc -l | awk '{ print $1 }'`
    
    if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
        for item in "${SEARCHDIR}/"PSF-*; do
            
            generate_unique_detail_files_local="YES"
                
            item_name=`basename "$item"`
        
            if [ -s "${item}" ]; then
                # run the script and pass the PSF to process to the script as argument 1
                # echo "Creating temporary data file for PSF : ${item}" | tee -ai "$printer_setup_log"
                "${temp_append_psf_details_to_file_script}" "${item}"
                exit_value=$?
                
                # Check that worked
                if [ $exit_value -ne 0 ]; then
                echo -n "    " ; logger -s -t SetupPrinters -p user.info "ERROR! : Generating tempoary details files for PSF : ${item_name}" 1>&2
                echo "     ERROR! : Generating tempoary details files for PSF : ${item_name}" | tee -ai "$printer_setup_log"
                fi
            fi        
        done
    fi


}


function generate_unique_files {

    if [ "${generate_unique_detail_files_local}" == "YES" ] ; then
    
        # Create Some Unique Tempoary Files
        if [ -f "${temp_details_enabled_print_queue_names_file}" ] ; then
            sort -u "${temp_details_enabled_print_queue_names_file}" >> "${temp_details_enabled_unique_print_queue_names_file}"
        else
            touch "${temp_details_enabled_unique_print_queue_names_file}"
        fi
        if [ -f "${temp_details_enabled_print_queue_descriptions_file}" ] ; then 
            sort -u "${temp_details_enabled_print_queue_descriptions_file}" >> "${temp_details_enabled_unique_print_queue_descriptions_file}"
        else
            touch "${temp_details_enabled_unique_print_queue_descriptions_file}"
        fi
        if [ -f "${temp_details_enabled_print_queue_locations_file}" ] ; then 
            sort -u "${temp_details_enabled_print_queue_locations_file}" >> "${temp_details_enabled_unique_print_queue_locations_file}"
        else
            touch "${temp_details_enabled_unique_print_queue_locations_file}"
        fi
        if [ -f "${temp_details_enabled_print_queue_addresses_file}" ] ; then 
            sort -u "${temp_details_enabled_print_queue_addresses_file}" >> "${temp_details_enabled_unique_print_queue_addresses_file}"
        else
            touch "${temp_details_enabled_unique_print_queue_addresses_file}"
        fi 
           
    fi

}



#############################      LOGIC      #############################
#
# Locic controlling this Script


pre_flight_checks 
scan_temp_psf_links_dir_and_save_data
generate_unique_files




exit 0
