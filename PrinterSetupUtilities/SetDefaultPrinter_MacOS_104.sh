#!/bin/bash

## This script sets the Default Printer
##
##//////////////////////////////////////////////////////////
## 
## Copyright 2006 © Henri Shustak GNU GPL
##

########################################
##
##  What this script is going to do :
##
##       Attempt to Set the Default Printer to
##		 Value passed in to argument 1
##
##       Read export arguments to this script that will be used
##       to setup a printer for Mac OSX 10.4.x
##

# Version 0003
# Requires Printer Setup Version 0014


#############################    Load Varibles    #############################
#
# Varibles
# Load the varibles in from the command line 

# Load General Varibles
file_to_parse="${1}"
psf_search_keys_conf_file="${psf_search_keys_conf_file}"
printer_setup_log="${printer_setup_log}"
psf_parsing_utility="${psf_parsing_utility}"

# Load Additional Options for Default Printer
user_to_set_default_printer_for="${user_to_set_default_printer_for}"
setting_default_user_printer="${setting_default_user_printer}"
setting_default_machine_printer="${setting_default_machine_printer}"
default_printer_has_PSF="${default_printer_has_PSF}"

# Load Prefixing Data
printer_prefixing="${printer_prefixing}"
printer_name_prefix="${printer_name_prefix}"
printer_name_prefix_delimiter="${printer_name_prefix_delimiter}"
printer_description_prefix="${printer_description_prefix}"
printer_description_prefix_delimiter="${printer_description_prefix_delimiter}"
printer_name_prefix="${printer_name_prefix}"
printer_name_prefix_delimiter="${printer_name_prefix_delimiter}"


#############################    MORE VARIBLES    #############################

current_PSF_search_key=""
printer_name=""

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
	if ! [ -f "${printer_setup_log}" ] ; then
		printer_setup_log=/dev/null
	fi
	
	# Check the varibles were supplied - this needs to be fixed - it is currently not working
	if [ "${file_to_parse}" == "" ] ; then
		echo "    WARNING!: Invalid arguments specified" | tee -ai "$printer_setup_log"
		echo "              Usage   : ./SetDefaultPrinter_OSVersion.sh printer_name" | tee -ai "$printer_setup_log"
		echo "              Example : ./CreatePritner_MacOS_104.sh mydefaultprinter" | tee -ai "$printer_setup_log"
		exit -127
	fi
	
	# Check additional options
	if [ "${user_to_set_default_printer_for}" == "" ] || [ "${setting_default_user_printer}" == "" ] || [ "${setting_default_machine_printer}" == "" ] ; then
		echo "    ERROR!: Reuried Varibles are unavailible, check that you are using Printer Setup 0008 or later" | tee -ai "$printer_setup_log"
		setting_default_user_printer="OFF"
		exit -127
		
	fi
}


function load_printer_name {
        # Loads the printer setup informaion from the passed in PSF into memory.
        
        # Load the psf_search_keys
        source "${psf_search_keys_conf_file}"
        
        if [ "${default_printer_has_PSF}" == "NO" ] ; then
            # Attempt to use the name specified in the PSL as the default.
            printer_name="${file_to_parse}"
        else
            # Load the printer name
            current_PSF_search_key="${printer_name_search_key}"
            printer_name=`"${psf_parsing_utility}" "${file_to_parse}" "${current_PSF_search_key}"`

        fi
                
}


function set_default_printer {
   	
   	# Set the Default Printer for the User
   	if [ "${setting_default_user_printer}" == "ON" ] ; then

		# Work out wheather to use sudo or su for setting the users default printer.
		# The line below sets the default.
		use_sudo="NO"
		
		current_system_name=`uname`
		if [ "${current_system_name}" == "Darwin" ] ; then
			# We are running on Dawrin
			current_darwin_version=`uname -a | awk '{ print $3 }' | awk -F "." '{ print $1 }'`
			if [ $current_darwin_version -ge 9 ] ; then
				# We are running on 10.5 or equivilent
				use_sudo="YES"
			fi
		fi
		
		# Actually run the deafult command either with su or sudo.
		if [ "${use_sudo}" == "YES" ] ; then
			# Use sudo to set the default printer
			sudo -H -u $user_to_set_default_printer_for lpoptions -d "${printer_name}" > /dev/null 
			return_status_of_setting_default_printer_for_user=$? 
		else
			# Use su to set the default printer 
			su -f $user_to_set_default_printer_for -c "lpoptions -d \"${printer_name}\"" > /dev/null 
			return_status_of_setting_default_printer_for_user=$? 
		fi
		
		# Report back what happend.
		if [ $return_status_of_setting_default_printer_for_user != 0 ] ; then
			echo "    ERROR! : Setting \"${printer_name}\" as the default printer for the user" |  tee -ai "$printer_setup_log"
		else
			echo "    Default User Printer : ${printer_name}" | tee -ai "$printer_setup_log"
		fi		
    fi
   	
   	# Set the Default Printer for the Machine
   	if [ "${setting_default_machine_printer}" == "ON" ] ; then
		lpoptions -d "${printer_name}" > /dev/null
		if [ $? != 0 ] ; then
			echo "    ERROR! : Setting \"${printer_name}\" as the default printer for the machine" |  tee -ai "$printer_setup_log"
		else
			echo "    Default Machine Printer : ${printer_name}" | tee -ai "$printer_setup_log"
		fi		
    fi
    
         
}



function add_prefixes {

    if [ "${printer_prefixing}" == "YES" ] ; then
    
        # Add the printer name prefix and delimiter to the printer name if required
        if [ "${printer_name_prefix}" != "" ] ; then
            printer_name="${printer_name_prefix}${printer_name_prefix_delimiter}${printer_name}"
        fi 
       
       # Not in use for this script 
       # # Add the printer description prefix and delimiter to the printer description if required
       # if [ "${printer_description_prefix}" != "" ] && [ "${printer_description}" != "" ] ; then
       #     printer_description="${printer_description_prefix}${printer_description_prefix_delimiter}${printer_description}"
       # fi 
       # 
       # # Add the printer location prefix and delimiter to the printer location if required
       # if [ "${printer_location_prefix}" != "" ] && [ "${printer_location}" != "" ] ; then
       #     printer_location="${printer_location_prefix}${printer_description_prefix_delimiter}${printer_location}"
       # fi 
       
    fi
    	
}


#############################      LOGIC      #############################
#
# Locic controlling this Script


pre_flight_checks
load_printer_name
add_prefixes
set_default_printer


exit 0
