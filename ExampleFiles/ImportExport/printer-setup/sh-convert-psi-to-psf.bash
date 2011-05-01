#!/bin/bash

##########################################################################
##							      		                                ##
## 	This script converts a printer-setup PSI files to a PrinterSetup   	## 
##	PSF files. It may need modification depending upon your requirments ##
##                                                                      ##
##	(C) Copyright Henri Shustak 2007						            ##
##	This Script is Released under the GNU GPL License		            ##
##  Lucid Information Systems                                           ## 
## 	http://www.lucidsystms.org                                          ##
## 	                                    								##
##  v0003																##
##																		##
##									                                    ##
##########################################################################

## Version History

# v0003 : added basic support for RAW queues
# v0002 : minor updates to deal with modifications of the format
# v0001 : basic implementation


INPUTDIRECTORY="${1}"                                   # This may need to be changed for your settings
OUTPUTDIRECTORY="${2}"                                  # This may need to be changed for your settings


file_name=""                                            # This is set to the printer name
printer_name=""                                         # read from csv file (first field)
printer_description=""                                  # read from csv file (second field)
printer_location=""                                     # read from csv file
printer_network_address=""                              # read from csv file
printer_published=""                                    # this should be set to yes or no if you would like it written to the PSF file.
printer_ppd=""                                          # This will use generic PPD unless a PPD is specified within the csv file
default_printer_ppd=""



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
        echo "WARNING! : printer setup file already exisits"
        echo "           $printer_name not created"
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
        echo "ERROR ! : No argument provided. This script will now exit."
        echo "          Usage : sh-convert-psi-to-psf.bash /path/to/inputdirectory /path/to/outputdirectory"
        exit_status=-127
        clean_exit
    fi

    # Check that the input directory exits
    if ! [ -d "${INPUTDIRECTORY}" ] ; then 
        echo "ERROR ! : The input PSI directory could not be found."
        echo "          Usage : sh-convert-psi-to-psf.bash /path/to/inputdirectory /path/to/outputdirectory"
        exit_status=-127
        clean_exit
    fi
    
    # Check the output directory exists
    if ! [ -d "${OUTPUTDIRECTORY}" ] ; then 
        echo "ERROR ! : The output directory could not be found."
        echo "          Usage : sh-convert-psi-to-psf.bash /path/to/inputdirectory /path/to/outputdirectory"
        exit_status=-127
        clean_exit
    fi

}


function generate_input_file {

    find ${INPUTDIRECTORY}* -maxdepth 1 -mindepth 1 | grep -v ".DS_Store" > "${tmp_output}"
    if [ $? != 0 ] ; then
        exit_status=-129
        clean_exit    
    fi
    
}


# Other Varibles
tmp_output=/tmp/convert_psi_printer-setup_`date|md5`
exit_status=0
INPUTFILE="${tmp_output}"
export printer_setup_log=/dev/null



# Locate the PSF_SearchKeys - This loads the current search keys
path_from_root="/ExampleFiles/ImportExport/printer-setup/sh-convert-psi-to-psf.bash"
printer_setup_directory=`echo "${0}" | awk -F "${path_from_root}" '{ print $1 }'`
psf_search_keys_conf_file="${printer_setup_directory}/PrinterSetupUtilities/PSI_SearchKeys_MacOS_104.config"
psf_reserved_options_conf_file="${printer_setup_directory}/PrinterSetupUtilities/PSF_Reserved_Options.config"
psi_parsing_utility="${printer_setup_directory}/PrinterSetupUtilities/ParsePSI.sh"



# load the search keys and reserved psf settings
source "${psf_search_keys_conf_file}"
source "${psf_reserved_options_conf_file}"


# Run Preflight Check
num_argumnets=$#
pre_flight_check


# Generate Input File
generate_input_file

# Loop to parse the input file

run=0
sucess=0
exec < "${INPUTFILE}"
a1=start
while [ "$a1" != "" ] ; do
    read a1 
    if [ "$a1" != "" ] ; then
        # Configure Varibles
        # This is probably the section you will want to modify
        
        # Printer Setup File
        file_to_parse="${a1}"
        
        if ! [ -d $file_to_parse ] ; then 
    
            # Printer Name
            current_PSI_search_key="${printer_name_search_key}"
            printer_name=`"${psi_parsing_utility}" "${file_to_parse}" "${current_PSI_search_key}"`
            
            # Printer Description
            current_PSI_search_key="${printer_description_search_key}"
            printer_description=`"${psi_parsing_utility}" "${file_to_parse}" "${current_PSI_search_key}"`
    
            # Printer Location
            current_PSI_search_key="${printer_location_search_key}"
            printer_location=`"${psi_parsing_utility}" "${file_to_parse}" "${current_PSI_search_key}"`
    
            # Printer Network Addrss
            current_PSI_search_key="${printer_network_address_search_key}"
            printer_network_address=`"${psi_parsing_utility}" "${file_to_parse}" "${current_PSI_search_key}"`
            
            # Printer PPD
            current_PSI_search_key="${printer_ppd_search_key}"
            printer_ppd=`"${psi_parsing_utility}" "${file_to_parse}" "${current_PSI_search_key}"`        
            if [ "${printer_ppd}" == ":generic" ] ; then
                printer_ppd="${default_printer_ppd}"
            else
                if [ "${printer_ppd}" == "" ] ; then
                    printer_ppd="${printer_is_raw_upper_case_reserved}"
                else
                    if [ "${base_ppd_directory}" != "" ] ; then
                        printer_ppd="${base_ppd_directory}/${printer_ppd}"
                    fi
                fi
            fi        
                    
            # Printer Requirements
            current_PSI_search_key="${printer_requirements_search_key}"
            printer_requirements=`"${psi_parsing_utility}" "${file_to_parse}" "${current_PSI_search_key}"`
            if [ "${printer_requirements}" != "" ] && [ "${base_requirments_directory}" != "" ] ; then 
                printer_requirements="${base_requirments_directory}/${printer_requirements}"
            fi
            
            # Generate the Printer Setup File
            generate_printer_setup_file
            if [ $? == 0 ] ; then 
                (( sucess++ ))
            fi		
            
            # increment run
            (( run++ ))		
        fi
    fi
done
    
    
# Final reporting of the PSF generation

parseed=$run
    
echo ""   
echo "Parsed $parseed lines from input file"
echo "Sucessfully Generated $sucess printer setup files."
echo ""



clean_exit
exit 0


