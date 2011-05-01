#!/bin/bash

##########################################################################
##							      		                                ##
## 	This script converts PSF files into a SimplePrint CSV file.         ##
##  It may need modification depending upon your requirments            ##
##                                                                      ##
##	(C) Copyright Henri Shustak 2007						            ##
##	This Script is Released under the GNU GPL License		            ##
##  Lucid Information Systems                                           ## 
## 	http://www.lucidsystms.org                                          ##
## 	                                    								##
##  v0004																##
##																		##
##									                                    ##
##########################################################################

# Version History

# v0003 : added basic support for raw printers, whether this works or not 
#         simple print will be okay creating raw queues requires testing.
# v0002 : changes to keep up with modifications to the simple print CSV file format
# v0001 : basic implementation


# Other Settings Which May need Configuration 

INPUTDIRECTORY="${1}"                                   # This may need to be changed for your settings
OUTPUTFILE="${2}"                                       # This may need to be changed for your settings

# The base directory for the Printer PPD and requirments - no trailing slash is required
base_ppd_directory=""
base_requirments_directory=""

file_name=""                                            # This is set to the printer name
printer_name=""                                         # read from csv file (first field)
printer_description=""                                  # read from csv file (second field)
printer_location=""                                     # read from csv file
printer_network_address=""                              # read from csv file
printer_ppd=""                                          # This will use generic PPD unless a PPD is specified within the csv file
default_printer_ppd="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/English.lproj/Generic.ppd"


function clean_exit {

    if [ -f "${tmp_output}" ] ; then
        rm "${tmp_output}"
    fi

    exit $exit_status

}


function add_printer_to_simple_print_cvs_file {

    # This function generates the SimplePrint CVS file.

    # the printer network address and location changed in the latest beta release, these changes are reflected below.
    echo "${selection_one},${selection_two},${printer_name},${printer_description},${printer_location},${printer_network_address},${printer_ppd},${printer_requirements}" >> "${OUTPUTFILE}"
    return $?
    
}



# Preflight Check
function pre_flight_check {

    if [ "$num_argumnets" -lt "1" ] ; then
        echo "ERROR ! : No argument provided. This script will now exit."
        echo "          Usage : sh-convert-psf-to-simpleprint-csv.bash /path/to/input_directory/ /path/to/outputfile.csv"
        exit_status=-127
        clean_exit
    fi

    # Check that the input csv file exists
    if ! [ -d "${INPUTDIRECTORY}" ] ; then 
        echo "ERROR ! : The input directory could not be found."
        echo "          Usage : sh-convert-psf-to-simpleprint-csv.bash /path/to/input_directory/ /path/to/outputfile.csv"
        exit_status=-127
        clean_exit
    fi
    
    # Check the output directory exists
    if [ -f "${OUTPUTFILE}" ] ; then 
        echo "ERROR ! : The output file already exists."
        echo "          Usage : sh-convert-psf-to-simpleprint-csv.bash /path/to/input_directory/ /path/to/outputfile.csv"
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


function generate_output_file {

    touch "${OUTPUTFILE}"
    echo "Selection One,Slection Two,Name,Model,Location,driver,Address,Requirements" > "${OUTPUTFILE}"

}



# Other Varibles
tmp_output=/tmp/convert_psf_simpleprint_cvs_`date|md5`
exit_status=0
INPUTFILE="${tmp_output}"
export printer_setup_log=/dev/null



# Locate the PSF_SearchKeys - This loads the current search keys
path_from_root="/ExampleFiles/ImportExport/SimplePrint/sh-convert-psf-to-simpleprint-csv.bash"
printer_setup_directory=`echo "${0}" | awk -F "${path_from_root}" '{ print $1 }'`
psf_search_keys_conf_file="${printer_setup_directory}/PrinterSetupUtilities/PSF_SearchKeys_MacOS_104.config"
psf_reserved_options_conf_file="${printer_setup_directory}/PrinterSetupUtilities/PSF_Reserved_Options.config"
psf_parsing_utility="${printer_setup_directory}/PrinterSetupUtilities/ParsePSF.sh"


# load the search keys and reserved psf options
source "${psf_search_keys_conf_file}"
source "${psf_reserved_options_conf_file}"


# Run Preflight Check
num_argumnets=$#
pre_flight_check


# Generate Input File
generate_input_file


# Create the Output File
generate_output_file

# Load any appropriate data into the output CVS file.

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
        
        # Extract selection one and selection two
        selection_one=`echo ${a1} | awk -F "${INPUTDIRECTORY}" '{ print $2}' | awk -F "/" '{ print $1 }'`
        selection_two=`echo ${a1} | awk -F "${INPUTDIRECTORY}" '{ print $2}' | awk -F "/" '{ print $2 }'`
    
        # Printer Name
        current_PSF_search_key="${printer_name_search_key}"
        printer_name=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`

        # Printer Description
        current_PSF_search_key="${printer_description_search_key}"
        printer_description=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`

        # Printer Location
        current_PSF_search_key="${printer_location_search_key}"
        printer_location=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`

        # Printer Network Addrss
        current_PSF_search_key="${printer_network_address_search_key}"
        printer_network_address=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Printer PPD
        current_PSF_search_key="${printer_ppd_search_key}"
        printer_ppd=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`        
        if [ "${printer_ppd}" == "" ] ; then
            printer_ppd="${default_printer_ppd}"
        else
            if [ "${printer_ppd}" == "${printer_is_raw_lower_case_reserved}" ] || [ "${printer_ppd}" == "${printer_is_raw_upper_case_reserved}" ] ; then 
                    # Set it to nothing
                    printer_ppd=""
            else
                if [ "${base_ppd_directory}" != "" ] ; then
                    printer_ppd="${base_ppd_directory}/${printer_ppd}"
                fi
            fi
        fi        
                
        # Printer Requirements
        current_PSF_search_key="${printer_requirements_search_key}"
        printer_requirements=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        if [ "${printer_requirements}" != "" ] && [ "${base_requirments_directory}" != "" ] ; then 
            printer_requirements="${base_requirments_directory}/${printer_requirements}"
        fi
        
        # Add line to the SimplePrint CVS file
        add_printer_to_simple_print_cvs_file
        if [ $? == 0 ] ; then 
            (( sucess++ ))
        fi		
        
        # increment run
        (( run++ ))		
    fi
done
    
    
# Final reporting of the PSF generation

parseed=$run
    
echo ""   
echo "Parsed $parseed PrinterSetupFiles"
echo "Sucessfully added $sucess Printers to the SimplePrint CSV File."
echo ""



clean_exit
exit 0


