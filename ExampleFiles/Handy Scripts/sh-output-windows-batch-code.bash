#!/bin/bash
#
# GNU GPL Copyright Henri Shustak 2008
# 
# Lucid Information Systems
# http://www.lucidsystems.org
#
# Output windows batch file to setup the print queue for the specified 
# PrinterSetup File.
#


#
# NOTE : This script will not preserve any PPD's. In fact the 
#        only data preserved from the printer setup file will be
#        the printer setup queue name and the printer setup address.
#        
#        Therefore, it is esential that you test the output of this
#        script thoroughly.
#
#        If you are having problems then you will most likely need
#        to tweek this script to meet your needs. 
# 
#        Also keep in mind the resulting batch files will 
#        probably only work in some situations. 
#        
#        If you are a windows developer and are able to offer the
#        PrinterSetup project any assistance then please contact
#        Lucid Information Systems via the contact information 
#        availible following URL : http://www.lucidsystems.org/contact
#
#        To create a batch file redirect the output to your desired .bat
#        output file. 
#        
#        There is also a helpful droplet bundeld with PrinterSetup to
#        ease the creation of a single batch file from multiple PSF's.
#

######################################
##     Exmaple input and output    ##
######################################

###
### Example Input PSF File (Path to the file passed in as argument one) 
###

# Printer Name :			    QueueName
# Printer Network Address :	    http://printserver:631/printers/QueueName


###
### Example Output to the Terminal : 
###

# rundll32 printui.dll,PrintUIEntry /b "QueueName" /x /n "part of the n switch" /if /f %windir%\inf\ntprint.inf /r "http://printservername:631/printers/QueueName" /m "MS Publisher Imagesetter"



###########################
#####  CONFIGURATION  ##### 
###########################

input_printersetupfile="${1}"
windows_printer_model="MS Publisher Imagesetter"




###############################
#####  Internal Varibles  ##### 
###############################

# Printer Details Required for Batch File
printer_name=""
printer_network_address=""

# Search Keys
printer_name_search_key=""
printer_network_address_search_key=""

# Locate the PSF_SearchKeys
path_from_root="/ExampleFiles/Handy Scripts/sh-output-windows-batch-code.bash"
printer_setup_directory=`echo "${0}" | awk -F "${path_from_root}" '{ print $1 }'`
psf_search_keys_conf_file="${printer_setup_directory}/PrinterSetupUtilities/PSF_SearchKeys_MacOS_104.config"
psf_parsing_utility="${printer_setup_directory}/PrinterSetupUtilities/ParsePSF.sh"


# Load the search keys
if [ -f "${psf_search_keys_conf_file}" ] ; then
    source "${psf_search_keys_conf_file}"
else
    echo "ERROR! : Unable to locate the PSF Search Keys File"
    ehco "         \"$psf_search_keys_conf_file\""
    exit -2
fi

# Check the PSF pasing utility is availible
if ! [ -f "${psf_parsing_utility}" ] ; then
    echo "ERROR! : Unable to locate the PSF Pasting Utility"
    echo "         \"$psf_parsing_utility\""
    exit -3

fi

num_arguments=$#
file_to_parse="${1}"



#######################
#####  FUNCTIONS  #####
####################### 

function pre_flight_check {

    if ! [ $num_arguments -eq 1 ] ; then
        echo "ERROR! : Invalid number of input arguments specified"
        echo "         Usage : sh-output-windows-batch-file.bash \"/path/to/printer/setup/file\""
        exit -1
    fi

}


function return_batch_script {

    echo ""
    echo "rundll32 printui.dll,PrintUIEntry /b \"${printer_name}\" /x /n \"part of the n switch\" /if /f %windir%\inf\ntprint.inf /r \"${printer_network_address}\" /m \"MS Publisher Imagesetter\""
    echo ""


}



function load_data_from_printer_setup_file {


    # Check the file to parse exists
    if ! [ -f "${file_to_parse}" ] ; then
        echo "ERROR! : Unable to locate the input PSF"
        echo "         \"$file_to_parse\""
        echo ""
        echo "         Usage : sh-output-windows-batch-file.bash \"/path/to/printer/setup/file\""
        echo ""
        exit -4
    fi

    # Printer Name
    current_PSF_search_key="${printer_name_search_key}"
    printer_name=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
    
    # Printer Network Addrss
    current_PSF_search_key="${printer_network_address_search_key}"
    printer_network_address=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`


}






###################
#####  LOGIC  #####
################### 


pre_flight_check
load_data_from_printer_setup_file
return_batch_script



exit 0