#!/bin/bash

## This script sets up a printer you need to pass into this script
## the absolute path of the ParsePSF utility and the 
## absolute path of the PSP setup file. The result of sccuessfull
## printer creation will be passed back.
##
##//////////////////////////////////////////////////////////
## 
## Copyright 2006 © Henri Shustak GNU GPL
##

########################################
##
##  What this script is going to do :
##
##       Read export arguments to this script that will be used
##       to setup a printer for Debian 3.1.x
##

# Version 00014
# Requires Printer Setup Version 0044 or later


#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

file_to_parse=$1
psf_search_keys_conf_file="$psf_search_keys_conf_file"
psf_reserved_options_conf_file="$psf_reserved_options_conf_file"
printer_setup_log="$printer_setup_log"
psf_parsing_utility="${psf_parsing_utility}"
printer_ppd_folder="${printer_ppd_folder}"
printer_publishing_status="${printer_publishing_status}"
printer_prefixing="${printer_prefixing}"
printer_name_prefix="${printer_name_prefix}"
printer_name_prefix_delimiter="${printer_name_prefix_delimiter}"
printer_description_prefix="${printer_description_prefix}"
printer_description_prefix_delimiter="${printer_description_prefix_delimiter}"
printer_name_prefix="${printer_name_prefix}"
printer_name_prefix_delimiter="${printer_name_prefix_delimiter}"


# Options for Default Printer
user_to_set_default_printer_for="${user_to_set_default_printer_for}"
setting_default_printer_for_user="${setting_default_printer_for_user}"
setting_default_printer_for_machine="${setting_default_printer_for_machine}"


#############################    MORE VARIBLES    #############################

current_PSF_search_key=""

printer_name=""
printer_description=""
printer_location=""
printer_network_address=""
printer_ppd=""
printer_paper_size=""
printer_requirments=""
printer_is_published=""
printer_is_raw=""

# Possible locations for the generic ppd. 
# Add additional search paths below as required.

# Note :  Paths with a lower array entry number in "default_printer_ppd_loc" have a higher priority.
#         For example default_printer_ppd_loc[1] will be selected if availible over default_printer_ppd_loc[5].

# Generic PPD Search Paths (maybe this should be a seperate file which is loaded?)
default_printer_ppd_loc[0]="/usr/share/ppd/Generic/Generic-PostScript_Printer-Postscript.ppd.gz"
default_printer_ppd_loc[1]="/usr/share/ppd/cups-included/postscript.ppd"
default_printer_ppd_loc[2]="/usr/share/ppd/foomatic-rip/linuxprinting.org-gs-builtin/Generic/Generic-PostScript_Printer-Postscript.ppd.gz"
default_printer_ppd_loc[3]="/usr/share/ppd/cupsfilters/Generic-PDF_Printer-PDF.ppd"

# Scan the search paths listed above looking for one which exits. 
default_ppd_array_num=0
found_printer_default_ppd="NO"
while [ "${default_printer_ppd_loc[$default_ppd_array_num]}" != "" ] ; do
    default_printer_ppd="${default_printer_ppd_loc[$default_ppd_array_num]}"
    if [ -f "${default_printer_ppd}" ] ; then
        found_printer_default_ppd="YES"
        break
    fi
    ((default_ppd_array_num++))
done





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

# Check the varibles were supplied - this needs to be fixed - it is currently not working
if [ "$file_to_parse" == "" ] ; then
    echo "    WARNING!: Invalid arguments specified" | tee -ai "$printer_setup_log"
    echo "              Usage   : ./CreatePritner_OSVersion.sh \"/absolute/path/to/PSFfile.conf\"" | tee -ai "$printer_setup_log"
    echo "              Example : ./CreatePritner_Debian_31.sh \"/Library/Tech Scripts/PrinterSetup/Printers/ROOM221.conf\"" | tee -ai "$printer_setup_log"
    exit -127
fi

# Check the file_to_parse exists
if ! [ -f "$file_to_parse" ] ; then
    echo "    ERROR!: Printer Setup File is not available." | tee -ai "$printer_setup_log"
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
        
        # Load the printer paper sizes
        current_PSF_search_key="${printer_paper_size_search_key}"
        printer_paper_size=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`
        
        # Stop setup if important varibles are not defined in the PSF
        if [ "$printer_name" == "" ] || [ "$printer_network_address" == "" ] ; then
            echo "            ERROR! : Loading setings from  printer setup file" | tee -ai "$printer_setup_log"        
        fi
        
        # If no PPD is specifed then use the default PPD
        if [ "$printer_ppd" == "" ] || [ "$printer_ppd" == "GENERIC" ] || [ "$printer_ppd" == "generic" ] ; then
            printer_ppd="$default_printer_ppd"
            if [ "${found_printer_default_ppd}" == "NO" ] ; then
                echo "            ERROR! : Unable to locate the generic PPD. Add the path to your"
                echo "                     generic PPD to the CreatePrinter script, located in the PrinterSetupUtilities directory."
            fi
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



function create_printer {
   # Creates the Printer Using the Information Parsed from the Printer Setup File
  
    # Reset the printer creation retrun value check
    printer_creation_check=0
    
    if [ "${printer_network_address}" != "" ] && [ "${printer_name}" != "" ] && [ "$printer_is_raw" != "" ]; then 
    	# There is enough information to setup the printer
    	
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
            printer_description="${printer_location_prefix}${printer_description_prefix_delimiter}${printer_location}"
        fi 
        
        
    	
    	# Report that the printer setup is occoring
    	echo "        Creating Printer : ${printer_name}" | tee -ai "$printer_setup_log"
    
    
    
    
    	# Start the printer setup
		if [ "${printer_location}" == "" ] && [ "${printer_description}" == "" ]; then
			# Only base options are specified
			if [ "$printer_is_raw" == "NO" ]; then
			    # Spcifiy the PPD
    			lpadmin -p "${printer_name}" -E -v ${printer_network_address} -P "${printer_ppd}"
	       		printer_creation_check=$?
            else
                lpadmin -p "${printer_name}" -E -v ${printer_network_address}
                printer_creation_check=$?
            fi
            
		
		elif [ "${printer_location}" != "" ] && [ "${printer_description}" != "" ] ; then
			# Both printer locationa dn printer description are options are specified
            if [ "$printer_is_raw" == "NO" ]; then
                # Spcifiy the PPD
                lpadmin -p "${printer_name}" -E -v ${printer_network_address} -P "${printer_ppd}" -L "${printer_location}" -D "${printer_description}"
                printer_creation_check=$?
            else
                lpadmin -p "${printer_name}" -E -v ${printer_network_address} -L "${printer_location}" -D "${printer_description}"
                printer_creation_check=$?
            fi
            
		
		elif [ "${printer_location}" != "" ] ; then 
			# Just the printer location is specified
            if [ "$printer_is_raw" == "NO" ]; then
                # Spcifiy the PPD
                lpadmin -p "${printer_name}" -E -v ${printer_network_address} -P "${printer_ppd}" -L "${printer_location}"
                printer_creation_check=$?
            else
                lpadmin -p "${printer_name}" -E -v ${printer_network_address} -L "${printer_location}"
                printer_creation_check=$?
            fi
            
		
		elif [ "${printer_description}" != "" ] ; then
			# Just the printer description is specified
            if [ "$printer_is_raw" == "NO" ]; then
                # Spcifiy the PPD
                lpadmin -p "${printer_name}" -E -v ${printer_network_address} -P "${printer_ppd}" -D "${printer_description}"
                printer_creation_check=$?
            else
                lpadmin -p "${printer_name}" -E -v ${printer_network_address} -D "${printer_description}"
                printer_creation_check=$?
            fi
		fi
		

		if [ $printer_creation_check == 0 ] ; then
            # The printer was created successfully, so we continue to set the publishing status of the printer
            if [ "$printer_is_published" == "yes" ] || [ "$printer_is_published" == "YES" ] ; then
                lpadmin -p "${printer_name}" -o printer-is-shared=yes
                printer_publishing_check=$?
            else
                lpadmin -p "${printer_name}" -o printer-is-shared=no
                printer_publishing_check=$?
            fi    
            if [ $printer_publishing_check != 0 ] ; then
                echo "            ERROR! : Configuring Printer Sharing : $printer_name" | tee -ai "$printer_setup_log"
            fi
		else
            echo "            ERROR! : Creating Printer : $printer_name" | tee -ai "$printer_setup_log"
        fi   
        
             
        # So far no problems with setting the paper size so set the check to 0 (everything is fine).
        printer_paper_size_check=0
        if [ $printer_creation_check == 0 ] ; then
                # The printer was created successfully, so we continue to set the paper size of the printer
                # We only need the first paper size so - lets strip to that.
                printer_paper_size=`echo $printer_paper_size | awk '{print $1}'` 
                if [ "$printer_paper_size" != "" ] ; then
                        # paper size has been defined so we should actually set the size.
                        lpadmin -p "${printer_name}" -o media=$printer_paper_size
                        printer_paper_size_check=$?
                fi
                if [ $printer_paper_size_check != 0 ] ; then
                        echo "            ERROR! : Configuring Printer Paper Size : $printer_name" | tee -ai "$printer_setup_log"
                fi
        fi
                
    fi
}


#############################      LOGIC      #############################
#
# Locic controlling this Script


pre_flight_checks 
load_printer_setup_data
add_prefixes
create_printer


exit 0
