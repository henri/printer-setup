#!/bin/bash

## This script parses a PSF passed in as argument 1 and appends the information
## in the printer_setup_file and the assosiated run time PrinterSetup
## data to build text files containing various informaion related to the 
## printers we are settting up with this run of PrinterSetup.
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
##       Save PSF printer cups queue details to specified output files
##


# Version 0001
# Requires Printer Setup Version 0025 or later
#

#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

# From the Command Line
file_to_parse="${1}"

# Exported Varibles
psf_parsing_utility="${psf_parsing_utility}"
printer_prefixing="${printer_prefixing}"
printer_name_prefix_delimiter="${printer_name_prefix_delimiter}"
psf_search_keys_conf_file="$psf_search_keys_conf_file"
psf_reserved_options_conf_file="$psf_reserved_options_conf_file"
printer_setup_log="$printer_setup_log"

# Output File Varibles
temp_details_enabled_print_queue_names_file="$temp_details_enabled_print_queue_names_file"
temp_details_enabled_print_queue_descriptions_file="$temp_details_enabled_print_queue_descriptions_file"
temp_details_enabled_print_queue_locations_file="$temp_details_enabled_print_queue_locations_file"
temp_details_enabled_print_queue_addresses_file="$temp_details_enabled_print_queue_addresses_file"


#############################    MORE VARIBLES    #############################

current_PSF_search_key=""
printer_name=""
printer_description=""
printer_location=""
printer_network_address=""
printer_ppd=""
printer_requirments=""
printer_is_published=""
printer_is_raw=""


#############################    FUNCTIONS    #############################
#
# Functions called in this script

function pre_flight_checks {
    
    # Check the psf_parsing_utility has been exported exits and is executable
    if ! [ -s "${psf_parsing_utility}" -a -x "${psf_parsing_utility}" ] ; then 
       echo "    ERROR!: PSFPasingUtility is unable to be located or may not be executable" | tee -ai "$printer_setup_log"
       echo "            $psf_parsing_utility" | tee -ai "$printer_setup_log"
       exit -127
    fi
    
    # Check psf_search_keys_conf has been exported, exists, has file size greater than zero and is executable
    if ! [ -s "${psf_search_keys_conf_file}" -a -x "${psf_search_keys_conf_file}" ] ; then 
       echo "    ERROR!: the psf_search_keys file is unable to be located or may not be executable" | tee -ai "$printer_setup_log"
       echo "            $psf_search_keys_conf_file" | tee -ai "$printer_setup_log"
       exit -127
    fi
    
    # Check log file exists 
    if ! [ -f "$printer_setup_log" ] ; then
        printer_setup_log=/dev/null
    fi
    
    # Check the required enviroment varibles are availible 
    if [ "$temp_details_enabled_print_queue_names_file" == "" ] ||  [ "$temp_details_enabled_print_queue_descriptions_file" == "" ] ||  [ "$temp_details_enabled_print_queue_locations_file" == "" ] ||  [ "$temp_details_enabled_print_queue_addresses_file" == "" ] ; then
        echo "        ERROR!: Required enviroment varibles are not availible." | tee -ai "$printer_setup_log"
        exit -127
    fi
    
    # Check the varibles were supplied - this needs to be fixed - it is currently not working
    if [ "$file_to_parse" == "" ] ; then
        echo "        WARNING!: Invalid arguments specified" | tee -ai "$printer_setup_log"
        echo "                  Usage   : ./append_print_queue_name_to_file.sh \"/absolute/path/to/PSFfile\"" | tee -ai "$printer_setup_log"
        echo "                  Example : ./append_print_queue_name_to_file.sh \"/Library/Tech Scripts/PrinterSetup/Printers/ROOM221\"" | tee -ai "$printer_setup_log"
        exit -127
    fi
    
    # Check the file_to_parse exists
    if ! [ -f "$file_to_parse" ] ; then
        echo "    ERROR!: Printer Setup File is not availible." | tee -ai "$printer_setup_log"
        echo "            $file_to_parse" | tee -ai "$printer_setup_log"
        exit -127
    fi
    
}

function load_printer_setup_data {
        # Loads the printer setup informaion from the passed in PSF into memory.
        
        # Load the psf_search_keys and psf_reserved_options
        source "${psf_search_keys_conf_file}"
        source "${psf_reserved_options_conf_file}"
        
        # Load the printer name
        current_PSF_search_key="${printer_name_search_key}"
        printer_name=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Load the printer description
        current_PSF_search_key="${printer_description_search_key}"
        printer_description=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Load the printer location
        current_PSF_search_key="${printer_location_search_key}"
        printer_location=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Load the printer network address
        current_PSF_search_key="${printer_network_address_search_key}"
        printer_network_address=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Load the printer PPD
        current_PSF_search_key="${printer_ppd_search_key}"
        printer_ppd=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Load the printer requirments (this is not doing anything else yet so it is commented out)
        #current_PSF_search_key="${printer_requirements_search_key}"
        #printer_requirements=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Load the printer publishing status if required
        if [ "$printer_publishing_status" == "" ] ; then
            # Load the publishing status from the PrinterSetupFile
            current_PSF_search_key="${printer_is_published_search_key}"
            printer_is_published=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        else
            # Set the printer publishing status based on the command line flag
            printer_is_published="$printer_publishing_status"
        fi

        # Stop setup if important varibles are not defined in the PSF
        if [ "$printer_name" == "" ] || [ "$printer_network_address" == "" ] ; then
            echo "            ERROR! : Loading setings from printer setup file" | tee -ai "$printer_setup_log"        
        fi
        
        # If no PPD is specifed then use the default PPD
        if [ "$printer_ppd" == "" ] || [ "$printer_ppd" == "GENERIC" ] || [ "$printer_ppd" == "generic" ] ; then
            printer_ppd="$default_printer_ppd"
            printer_is_raw="NO"
        else
            # Check if this should be a raw printer
            if [ "$printer_ppd" == "$printer_is_raw_lower_case_reserved" ] || [ "$printer_ppd" == "$printer_is_raw_upper_case_reserved" ] ; then
                printer_is_raw="YES"
                printer_ppd=""
            else
                # Check if the PPD needs to have a full path added
                if [ "${printer_ppd_folder}" != "" ] && [ -d "${printer_ppd_folder}" ] ; then
                    # Check if the specified ppd is an absolute path (starting with "/") 
                    ppd_path_check=`echo "${printer_ppd}" | grep -e"^/"`
                    if [ "${ppd_path_check}" == "" ] ; then
                        # Add the printer_ppd_folder to the start of the name
                        printer_ppd="${printer_ppd_folder}/${printer_ppd}"
                        printer_is_raw="NO"
                    fi
                fi
            fi
        fi
        
}



function add_prefixes {

    if [ "${printer_prefixing}" == "YES" ] ; then
    
        # Add the printer name prefix and delimiter to the printer name if required
        if [ "${printer_name_prefix}" != "" ] ; then
            printer_name="${printer_name_prefix}${printer_name_prefix_delimiter}${printer_name}"
        fi 
        
        # Add the printer description prefix and delimiter to the printer description if required
        if [ "${printer_description_prefix}" != "" ] && [ "${printer_description}" != "" ] ; then
            printer_description="${printer_description_prefix}${printer_description_prefix_delimiter}${printer_description}"
        fi 
        
        # Add the printer location prefix and delimiter to the printer location if required
        if [ "${printer_location_prefix}" != "" ] && [ "${printer_location}" != "" ] ; then
            printer_location="${printer_location_prefix}${printer_description_prefix_delimiter}${printer_location}"
        fi 
    fi
    	
}



function append_data_to_output_files {
   # Creates the Printer Using the Information Parsed from the Printer Setup File
   
   
   # Write out the queue name to temporary file.
   echo "${printer_name}" >> "${temp_details_enabled_print_queue_names_file}"
   

   # Write out the queue description to temprary file. - this could be blank - but we write out the blank line any 
   # way to allow easy post processing if matching by line is required.
   echo "${printer_description}" >> "${temp_details_enabled_print_queue_descriptions_file}"
   
   
   # Write out the queue location to temprary file. - this could be blank - but we write out the blank line any 
   # way to allow easy post processing if matching by line is required.
   echo "${printer_location}" >> "${temp_details_enabled_print_queue_locations_file}"
   
      
   # Write out the queue name to temporary file.
   echo "${printer_network_address}" >> "${temp_details_enabled_print_queue_addresses_file}"
   
   
 }


#############################      LOGIC      #############################
#
# Locic controlling this Script


pre_flight_checks 
load_printer_setup_data
add_prefixes
append_data_to_output_files

exit 0
