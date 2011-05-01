#!/bin/bash

#
# Script is licenced under the GNU GPL 
# ©Copyright 2007 Henri Shustak
# Lucid Information Systems
# http://www.lucidsystems.org
#

# Version 0.5
# This version supports newer version of cups whcih do not have the /etc/printcap file.

# Note this script works on Mac OS X. It may not work on other *NIX platforms

# v0.5 : minor improvements to the error reporting system
# v0.4 : just a tidy up of a few issues - nothing major
# v0.3 : fixing some issues
# v0.2 : improving support for older versions of CUPS
# v0.1 : basic implementation - no support for printer setup prefixes in this version

##
## SETTINGS
##



OUTPUTDIRECTORY="${1}"                                  # This may need to be changed for your settings

file_name=""                                            # This is set to the printer name
printer_name=""                                         # read from cups
printer_description=""                                  # read from cups
printer_location=""                                     # read from cups
printer_network_address=""                              # read from cups
printer_published=""                                    # read from cups
printer_ppd=""                                          # This will use generic PPD unless a PPD is specified within the csv file
default_printer_ppd=""


# Driver Settings - Currently only support for LINUX and Darwin.

# Strings to search for when dealing with generic printer drivers
cups_reports_generic_postscript_linux="Generic PostScript Printer Foomatic/Postscript (recommended)"
cups_reports_generic_postscript_darwin="Generic PostScript Printer"
cups_generic_postscript=""


# Set the string to search for when dealing with generic drivers on different system it also deals with different names for md5
system_kind=`uname -s`
if [ "${system_kind}" == "Darwin" ] ; then
    cups_generic_postscript="$cups_reports_generic_postscript_darwin"
    MD5_COMMAND="md5"
else
    cups_generic_postscript="$cups_reports_generic_postscript_linux"
    MD5_COMMAND="md5sum"
fi



##
## FUNCTIONS & LOGIC COMBINED INTO A MASSIVE MESS OF BASH
##




function clean_exit {

    if [ -f "${tmp_output}" ] ; then
       rm "${tmp_output}"
    fi
    

    exit $exit_status

}




function generate_printer_setup_file {

    # This function simply generates the PSF.
    # You will most likly want to modify the section below this 
    # function, where the input file is parsed.
    
    printersetupfile="$OUTPUTDIRECTORY""/""$printer_name"
    
    if [ -f "${printersetupfile}" ] ; then
        echo "    ERROR! : printer setup file already exisits"
        echo "               $printer_name not created"
        echo ""
        return -1
    else
        touch "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo "# This is a Printer Setup : Printer Configuration File" >> "${printersetupfile}"
        echo "# Copyright 2006 Henri Shustak GNU GPLv2" >> "${printersetupfile}"
        echo "#" >> "${printersetupfile}"
        echo "#" >> "${printersetupfile}"
        echo "# Printer Setup File v0001" >> "${printersetupfile}"
        echo "# it is important that there are tabs inserted after the colon." >> "${printersetupfile}"
        echo "# This version of the parsing system has an issue which means that" >> "${printersetupfile}"
        echo "# you can only have a few tabs. The port to python should resolve this" >> "${printersetupfile}"
        echo "# issue. Also note that currently comments can only be at the start of a line" >> "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo "# Printer Setup Notes : Printer Name is only valid if it contains no spaces" >> "${printersetupfile}"
        echo "# Use the Printer Description to a description with spaces" >> "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo -e "Printer Name :\t\t\t${printer_name}" >> "${printersetupfile}"
        echo -e "Printer Description :\t\t${printer_description}"  >> "${printersetupfile}"
        echo -e "Printer Location :\t\t${printer_location}"  >> "${printersetupfile}"
        echo -e "Printer Network Address :\t${printer_network_address}" >> "${printersetupfile}"
        echo -e "Printer PPD :\t\t\t${printer_ppd}" >> "${printersetupfile}"
        if [ "$printer_published" != "" ] ; then
            echo -e "Printer Published :\t\t${printer_published}" >> "${printersetupfile}"
        fi           
        echo "" >> "${printersetupfile}"
    fi
    
    return 0

}





# Preflight Check
function pre_flight_check {

    if [ "$num_argumnets" -lt "1" ] ; then
        echo "    ERROR ! : No argument provided. This script will now exit."
        echo "              Usage : sh-convert-psi-to-psf.bash /path/to/outputdirectory"
        echo "              Note : there is no trailing slash on the output directory"
        exit_status=-127
        clean_exit
    fi

    # Check the output directory exists
    if ! [ -d "${OUTPUTDIRECTORY}" ] ; then 
        echo "    ERROR ! : The output directory could not be found."
        echo "              Note there should be no trailing slash on the output directory."
        echo "              Usage : sh-convert-psi-to-psf.bash /path/to/inputdirectory /path/to/outputdirectory"
        echo "              Directory Specified : $OUTPUTDIRECTORY"
        echo ""
        exit_status=-127
        clean_exit
    fi
    
        

}

function generate_input_file {
    
    # Create a list of printers
    lpstat -a | sed '/^\tRejecting Jobs$/d' | sed '/^\t$/d' | awk '{print $1}' > "${tmp_output}"
    if [ $? != 0 ] ; then
        exit_status=-129
        clean_exit    
    fi
    
}


# Other Varibles
tmp_output=/tmp/convert_cups_to_printersetup_`date|${MD5_COMMAND}`
exit_status=0
INPUTFILE="${tmp_output}"
export printer_setup_log=/dev/null

# Find the Absolute Path to the output directory
OUTPUTDIRECTORY_path_absolute_check=`echo "${OUTPUTDIRECTORY}" | grep -e "^/"`
if [ "${OUTPUTDIRECTORY_path_absolute_check}" == "" ] ; then
    OUTPUTDIRECTORY="${PWD}/${OUTPUTDIRECTORY}"
fi

# Find the Absolute Path to this file and the root of the printer-setup directory.
execution_path="${0}"
execution_path_absolute_check=`echo "${execution_path}" | grep -e "^/"`
if [ "${execution_path_absolute_check}" == "" ] ; then
    execution_path="${PWD}/${execution_path}"
fi

# Path to this file from the PrinterSetup directory root
path_from_root="/ExampleFiles/ImportExport/CUPS/sh-generate-psf-files-from-cups.bash"
printer_setup_directory=`echo "${execution_path}" | awk -F "${path_from_root}" '{ print $1 }'`


## Debugging
#echo OUTPUTDIRECTORY : $OUTPUTDIRECTORY
#echo printer_setup_directory: $printer_setup_directory
#echo execution_path : $execution_path
#exit 0

# Locate the PSF_SearchKeys - This loads the current search keys
psf_search_keys_conf_file="${printer_setup_directory}/PrinterSetupUtilities/PSI_SearchKeys_MacOS_104.config"
psf_reserved_options_conf_file="${printer_setup_directory}/PrinterSetupUtilities/PSF_Reserved_Options.config"
psi_parsing_utility="${printer_setup_directory}/PrinterSetupUtilities/ParsePSI.sh"



# load the search keys and reserved psf settings
source "${psf_search_keys_conf_file}"
if [ $? != 0 ] ; then
    echo "ERROR! : Reading Printer Setup Search Keys Configuration File"
    echo "         Ensure that this script is still within the original PrinterSetup location,"
    echo "         unless you have modified this script to deal with the new search path."
    echo "         File Referenced : ${psf_search_keys_conf_file}"
    exit_status=-127
    clean_exit
fi

source "${psf_reserved_options_conf_file}"
if [ $? != 0 ] ; then
    echo "ERROR! : Reading Printer Setup Reserved Options Configuration File"
    echo "         Ensure that this script is still within the original PrinterSetup location,"
    echo "         unless you have modified this script to deal with the new search path."
    echo "         File Referenced : ${psf_search_keys_conf_file}"
    exit_status=-127
    clean_exit
fi




# Run Preflight Check
num_argumnets=$#
pre_flight_check


# Generate Input File
generate_input_file



# Loop to parse the input file

error_count=0
warning_count=0
run=0
success=0
psf_files_generated=0
exec < "${INPUTFILE}"
a1=start
while [ "$a1" != "" ] ; do
    read a1 
    if [ "$a1" != "" ] ; then
        # Configure Varibles
        # This is probably the section you will want to modify
    
        warning_set="NO"
        
        # Printer Setup File
        printer_name="${a1}"
        
        # Tell the world we are processing some queues
        echo "Processing CUPS Queue : ${printer_name}"
        
        
        
        # Printer Network Adderss
        printer_network_address=`lpstat -v ${printer_name} | awk -F "device for ${printer_name}: " '{ print $2 }'`
        if [ "${printer_network_address}" == "" ] ; then
            printer_network_address=`grep --line-regexp --after-context=10 -e "<Printer ${printer_name}>" /etc/cups/printers.conf | grep -e "^DeviceURI" | head -n 1 | awk -F "DeviceURI " '{ print $2 }'`
        fi
        
        
        
        # Printer Description
        printer_description=`lpoptions -p ${printer_name} | awk -F " printer-info='" '{ print $2 }' | awk -F "' printer-is-accepting-jobs=" '{ print $1 }'`
        if [ "${printer_description}" == "" ] ; then
            printer_description=`lpoptions -p ${printer_name} | awk -F " printer-info=" '{ print $2 }' | awk -F " printer-is-accepting-jobs=" '{ print $1 }'`
        fi
        if [ "${printer_description}" == "" ] ; then
            printer_description=`grep --line-regexp --after-context=4 -e "<Printer ${printer_name}>" /etc/cups/printers.conf | grep -e "^Info" | head -n 1 | awk -F "Info " '{ print $2 }'`
        fi



        # Printer Location
        printer_location=`lpoptions -p ${printer_name} | awk -F " printer-location='" '{ print $2 }' | awk -F "' printer-make-and-model=" '{ print $1 }'`
        if [ "${printer_location}" == "" ] ; then
            printer_location=`lpoptions -p ${printer_name} | awk -F " printer-location=" '{ print $2 }' | awk -F " printer-make-and-model=" '{ print $1 }'`
        fi
        if [ "${printer_location}" == "" ] ; then
            printer_location=`grep --line-regexp --after-context=4 -e "<Printer ${printer_name}>" /etc/cups/printers.conf | grep -e "^Location" | head -n 1 | awk -F "Location " '{print $2}'`
        fi



        # Printer is Shared
        printer_published=`lpoptions -p ${printer_name} | awk -F " printer-is-shared=" '{ print $2 }' | cut -c 1-1`
        if [ "${printer_published}" != 0 ] ; then
            # Write out the information that this printer is published.
            printer_published="YES"
        else
            # Do not write out any published information. 
            # This could be changed to "NO" if you would like to see the line in the out put PrinterSetupFile.
            printer_published=""
        fi
        
        

        # Printer PPD
        printer_ppd="lpoptions -l -p ${printer_name} 2>&1"
        if [ "${printer_ppd}" != "lpoptions: Destination has no PPD file!" ] ; then
            # Note : the above line needs to be fixed because the error message changes depending on the queue
            
            printer_ppd=`lpoptions -p ${printer_name} | awk -F " printer-make-and-model='" '{ print $2 }' | awk -F "' printer-state=" '{ print $1 }'`
            if [ "${printer_ppd}" == "" ] ; then
                printer_ppd=`lpoptions -p ${printer_name} | awk -F " printer-make-and-model=" '{ print $2 }' | awk -F " printer-state=" '{ print $1 }'`
            fi 
            
            # Deal with the incomming PPD data
            if [ "${printer_ppd}" == "${cups_generic_postscript}" ] ; then
                printer_ppd="${default_printer_ppd}"
            else
                if [ "${printer_ppd}" != "${printer_is_raw_upper_case_reserved}" ] ; then
                    
                    if [ "${printer_ppd}" != "Local Raw Printer" ] ; then
                        
                        # This is not a RAW queue so work out the PPD file name by looking in the CUPS PPD file for the PC File Name which is listed
                        
                        # Check the PPD exits
                        
                        if [ -f "/etc/cups/ppd/${printer_name}.ppd" ] ; then
                        
                            # This is going to do some conversion of the file from different line endings so we can grep it and than then search for the PPD name.
                            printer_ppd=`cat "/etc/cups/ppd/${printer_name}.ppd" | tr '\r' '\n' 2> /dev/null | tr -d '\r' 2> /dev/null | grep -w "*PCFileName: " | awk -F "PCFileName: \"" '{ print $2 }' | awk -F "\"" '{ print $1 }'`
                        
                            if [ "${printer_ppd}" == "" ] ; then
                        
                                echo "    WARNING! : Retrieving PPD PCFile name for queue : ${printer_name}"
                                echo "             Check the PPD file contains the appropriate information"
                                echo "             EG : *PCFileName: \"PPDNAME.PPD\""
                                echo ""
                            
                                warning_set="YES"
                        
                            fi
                        

                        
                        else
                    
                            echo "    WARNING! : Unable to find the PPD file for queue : ${printer_name}"
                            echo "             /etc/cups/ppd/${printer_name}.ppd"
                            echo ""
                            warning_set="YES"
                        
                        fi
                    else
                        # Set the PPD to be a raw queue in the new PSF
                        printer_ppd="${printer_is_raw_upper_case_reserved}"          
                    fi
                fi
            fi 
        else
            # On some old versions of CUPS we need to check for this as lpoptions will not provide any helpful PPD information
            # when the queue is set to raw
            printer_ppd=""
        fi
                
                
                
        # Generate the Printer Setup File
        generate_printer_setup_file
        if [ $? == 0 ] ; then 
            if [ "${warning_set}" == "NO" ] ; then
                (( success++ ))
            else
                (( warning_count ++ ))
            fi
            (( psf_files_generated++ ))
        else
            (( error_count ++ ))
        fi
        
        # increment run
        (( run++ ))		
    
    fi
done


# Final reporting of the PSF generation

parseed=$run
    
echo ""
echo "Summary"
echo "============================================="
echo "Parsed $parseed print queues from  the CUPS installation on this system"
if [ $warning_count -gt 0 ] ; then 
    echo "Generated $warning_count printer setup files with warnings."
fi
if [ $error_count -gt 0 ] ; then 
    echo "There were $error_count errors while creating printer setup files."
fi
if [ $success -gt 0 ] ; then 
    if [ $warning_count -gt 0 ] || [ $error_count -gt 0 ] ; then
        echo "Successfully generated $success printer setup files without warnings or errors."
    else
        echo "Successfully generated $success printer setup files."
    fi
fi
if [ $warning_count -gt 0 ] || [ $error_count -gt 0 ] ; then
    if [ $psf_files_generated -gt 0 ] ; then
        echo "A total of $psf_files_generated printer setup files were generated."
    else
        echo "No printer setup files were generated."
    fi
fi
echo ""


clean_exit
exit 0



