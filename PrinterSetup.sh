#!/bin/bash

##Set the Printers Up on this machine
##//////////////////////////////////////////////////////////
## 
## Copyright 2006 - 2011 (C) Henri Shustak 
## Licenced under the GNU GPL v3 or later
## Lucid Information Systems
## http://lucidsystems.org
##

########################################
##
##  What this script is going to do :
##
##       This by default will process files in the 
##       PrinterSetupLinnks directory with file names 
##       whcih have the following prefixes and
##       matching room number stored in NVRAM "asset-name"
##       the following:
##
##              PLF-ROOMNUMBER
##         	    PSF-ROOMNUMBER
##    	        PSS-ROOMNUMBER
##	            PLS-ROOMNUMBER
##       
##       There are example setup files in the directory :
##       "ExampleFiles" accompanying this system.
##
##       Refer to these examples when building your own.
##

# Version 00024

# HISTORY
#
#
# Version 0024 : temp PPD directory creation if needed now with varible change
# Version 0023 : added additional logging for removal of print queues.
# Version 0022 : added an slightly improved feed back when there is no nvram specified.
# Version 0021 : added in export of the paper size search keys - consider adding 
#                in paper size options.
# Version 0020 : Altered the names of the default pre and post printer setup hooks.
#                Changed the variable names for the pre and post hooks in this script.
# Version 0019 : Minor improvement for LINUX print creation support.
# Version 0018 : added an option supporting the removal of print queues
#                if they exisit on the system and are not enabled by this
#                PrinterSetup instance and configuration.
# Version 0017 : added the ability to temporarly store details of the printers
#                which we are configuring.
# Version 0016 : added the ability to add a cups print queue name, location and 
#                description options from the command line.
# Version 0015 : added command line flags to enable or disable printer sharing
# Version 0014 : added the ability to specify the default printer within the PSL 
#                without an assosiated PSF.
# Version 0013 : added ability to overide certian settings from the command line
# Version 0012 : added a handy radmind clean up script, and minor bug fixs
# Version 0011 : added a handy dropplet which will setup printers from PSF files
# Version 0010 : system can be haulted, by the pre printer setup hook
# Version 0009 : support for post printer setup scripts
# Version 0008 : support for setting default user printer added
# Version 0007 : fixed minor issue related to PLS file processing
# Version 0006 : fixed minor issue related to the PPD folder setup
# Version 0005 : fixed bug related to PPD folder setup
# Version 0004 : impliemnt an initial hoook script, added an export 
#                for the asset-name NVRAM variable, added PPD folder option
# Version 0003 : implimented default printer system for PSF's
# Version 0002 : vastly improved the sytem to support PSS, PSF, PLF, PLS
# Version 0001 : initial implementation : Only Implemented PSS, not PSF
#
#




#############################   RETURN CODES  ##############################
#
# Status Indicators for Printer Setup Hook Return Values
PRINTERSETUP_CONTINUE=0
PRINTERSETUP_STOP=55




##########################   INTERNAL VARIBLES    ##########################
#
# Varibles

assetName=""
room_name=""
current_printer_list_file=""
use_temp_ppds="NO"



#############################  CONFIGURATION  #############################
#
# Setup of options for this script
#echo $0

#Full Path to PrinterSetup Folder (Absolute Path No Trailing Slash)
printer_setup_folder=`dirname "${0}"`


# Full Path to PrinterSetup Folders (Quoted, No Escape, No Trailing Slash)
printer_setup_links_folder="${printer_setup_folder}/PrinterSetupLinks"
printer_list_folder="${printer_setup_folder}/PrinterLists"
printer_list_scripts_folder="${printer_setup_folder}/PrinterListScripts"
printer_setup_utilities_folder="${printer_setup_folder}/PrinterSetupUtilities"
printer_setup_utilities_temporary_directory_scripts_folder="${printer_setup_utilities_folder}/temporary_directory_scripts"
printer_setup_utilities_queue_managment_directory_scripts_folder="${printer_setup_utilities_folder}/queue_managment"
printer_setup_files_folder="${printer_setup_folder}/PrinterSetupFiles"
printer_setup_scripts_folder="${printer_setup_folder}/PrinterSetupScripts"
printer_ppd_folder="${printer_setup_folder}/PPDs"


# Full Path to Printer Creation Script

# Different Operating Systems have different ways to create printers this deals with LINUX and Mac OS X
# This area needs a bit of work - it is very messy at present... the default PPD location should be passed to
# these scripts to minimize the repetition of code.
# For now just override this setting as required.

system_kind=`uname -s`
if [ "${system_kind}" == "Darwin" ] ; then
    create_printer_script="${printer_setup_utilities_folder}/CreatePrinter_MacOS_104.sh"
else
    create_printer_script="${printer_setup_utilities_folder}/CreatePrinter_Debian_31.sh"
fi

# Full Path to Printer Setup File Parsing Utility
psf_parsing_utility="${printer_setup_utilities_folder}/ParsePSF.sh"
# Full Path to Printer Setup File Key Search Terms
psf_search_keys_conf_file="${printer_setup_utilities_folder}""/PSF_SearchKeys_MacOS_104.config"
# Full path to Default Printer Script
set_default_printer_script="${printer_setup_utilities_folder}""/SetDefaultPrinter_MacOS_104.sh"
# Full path to the Printer Setup Reserved Settings
psf_reserved_options_conf_file="${printer_setup_utilities_folder}""/PSF_Reserved_Options.config"
# Full path to the Printer Setup Temp Utilities - requred if tempoary data storing is enabled
temp_psf_dump_details_script="${printer_setup_utilities_temporary_directory_scripts_folder}/generate_temp_printersetup_details_files.sh"
temp_append_psf_details_to_file_script="${printer_setup_utilities_temporary_directory_scripts_folder}/append_PSF_details_to_file.sh"
temp_generate_all_system_queue_names_script="${printer_setup_utilities_temporary_directory_scripts_folder}/generate_temp_all_system_queue_names_MacOS_105.sh"
# Full path to the PrinterSetup Queue Managment Utilities - required for smart queue managment.
printer_setup_queuemanagment_remove_disabled_queues_with_prefix_script="${printer_setup_utilities_queue_managment_directory_scripts_folder}/remove_disabled_queues_with_prefix.sh"


# PrinterSetup ( pre and post hooks )
printer_setup_pre_hook="${printer_setup_scripts_folder}/sh-printer-setup-pre.hook"
printer_setup_post_hook="${printer_setup_scripts_folder}/sh-printer-setup-post.hook"


# Settings for default printer
default_printer_is_set="NO"
default_printer_PSF_path=""
default_printer_has_PSF="YES"
default_printer_PSL_name=""

# Not Used : 
#printer_setup_files_folder=""
#printer_serup_scripts_folder=""

# This is the user which is executed if setting default printer for user is "ON".
# This now gets set later on - once the options have been read from the commmand line.
# It was causing some issues being set here......moved down below command options reading section.
# Hence this is being set to nothing at this point in PrinterSetup.
user_to_set_default_printer_for=""

# We are going to set the default printer for user is : (ON/OFF) 
setting_default_user_printer="ON"
# We are going to set the default printer for the machine : (ON/OFF) 
setting_default_machine_printer="ON"

# System Status is : (ON/OFF) 
# The system status determins wether this script will do anything
system_status="ON"


# If you do not want a log, just set this to /dev/null
printer_setup_log="${printer_setup_folder}/printer_setup.log"


# Default Vaule for Printer Setup Hook Return Value 
printer_setup_pre_hook_exit_status=CONTINUE


# Should we generate lists with details on the printers which are being configured.
temporarly_store_details_of_queues_to_be_configured="NO"


# Some other varibles to go with this.
tmp_printersetup_directory=""
temp_details_directory=""
temp_details_directory_name="details"

temp_details_enabled_print_queue_names_file_name="enabled_queues_names.txt"
temp_details_enabled_print_queue_descriptions_file_name="enabled_queues_descriptions.txt"
temp_details_enabled_print_queue_locations_file_name="enabled_queues_locations.txt"
temp_details_enabled_print_queue_addresses_file_name="enabled_queues_address.txt"

temp_details_enabled_unique_print_queue_names_file_name="enabled_unique_queues_names.txt"
temp_details_enabled_unique_print_queue_descriptions_file_name="enabled_unique_queues_descriptions.txt"
temp_details_enabled_unique_print_queue_locations_file_name="enabled_unique_queues_locations.txt"
temp_details_enabled_unique_print_queue_addresses_file_name="enabled_unique_queues_address.txt"

temp_all_system_queue_names_file_name="all_system_queue_names.txt"
temp_all_system_queue_names_with_prefix_file_name="all_system_queue_names_with_prefix.txt"
temp_all_system_queue_names_with_prefixt_but_not_enabled_file_name="all_system_queue_names_with_prefix_but_not_enabled.txt"

temp_details_symbolic_links_directory=""
temp_details_symbolic_links_directory_name="active_psf_links"
printerPSF_for_temp_link=""
temp_link_printerPSF=""
temp_errors_while_runnnig_temp_scripts="NO"

temp_ppd_dir_name="PPDs"



# Printer Prefix System
printer_prefixing="YES"

# Printer Name Prefix Varibles
printer_name_prefix=""
printer_name_prefix_delimiter="-"

# Printer Location Prefix Varibles
printer_location_prefix=""
printer_location_prefix_delimiter="-"

# Printer Description Prefix Varibles
printer_description_prefix=""
printer_description_prefix_delimiter="-"

# Printer Removal Flags
# This option specifies wheather we shold be removing any queues which are disabled and which 
# have queue names which begin with the same name as the specified prefix.
remove_disabled_queues_with_prefix_which_matches_start_of_queue_name="NO"



################  CHECK CONFIGURATION FILES ARE AVAILABLE  #################
#
# Check The PSF Search Keys Config File
if ! [ -f "${psf_search_keys_conf_file}" ] ; then
    echo "ERROR! : PSF Search Keys Configuration file was unable to be located."
    echo "         Expected File Location : $psf_search_keys_conf_file"
    echo "         printer setup will now exit."
    exit -1
fi
#
# Check the PSF Reserved Options File
if ! [ -f "${psf_reserved_options_conf_file}" ] ; then
    echo "ERROR! : PSF Reserved Settings configuration file was unable to be located."
    echo "         Expected File Location : $psf_search_keys_conf_file"
    echo "         printer setup will now exit."
    exit -1
fi


###################  LOAD SETTINGS USED IN THIS SCRIPT  ####################
#
# Load the PSF Reserved Options File
source "${psf_reserved_options_conf_file}" 



##########################  COMMAND LINE OPTIONS  ##########################
#
# Overirde settings passed via the command line
    args_to_shift=0
    NO_ARGS=0
    E_OPTERROR=65
    while getopts ":txd:l:n:p:a:s:" option
    do
        case $option in
            s   ) system_script_status="$OPTARG";;
            a   ) assetName="$OPTARG";;
            p   ) printer_publishing_status="$OPTARG";;
            n   ) printer_name_prefix="$OPTARG";;
            l   ) printer_location_prefix="$OPTARG";;
            d   ) printer_description_prefix="$OPTARG";;
            t   ) temporarly_store_details_of_queues_to_be_configured="YES";;
            x   ) remove_disabled_queues_with_prefix_which_matches_start_of_queue_name="YES";;
            #  Note that option 's' and 'a' options must have an associated argument,
            #  otherwise it falls through to the default.
            *   ) ;;   # DEFAULT : Do Nothing
        esac
    done
    shift $(($OPTIND - 1))
    #   Decrements the argument pointer so it points to next argument.
    #   $1 now references the first non option item supplied on the command line
    #   if one exists.
    
    # Validate The system_script_status
    if [ "${system_script_status}" != "ON" ] && [ "${system_script_status}" != "OFF" ] && [ "${system_script_status}" != "" ]; then
        echo "ERROR! : system_scritp_status must be set to \"ON\" or \"OFF\""
        echo "         printer setup will now exit"
        exit -1
    fi
    
    # Validate the printer_publishing_status
    if [ "${printer_publishing_status}" != "YES" ] && [ "${printer_publishing_status}" != "NO" ] && [ "${printer_publishing_status}" != "" ]; then
        echo "ERROR! : printer_publishing_status must be set to \"$printer_is_published_reserved\" or \"$printer_is_not_published_reserved\""
        echo "         printer setup will now exit"
        exit -1
    fi
    
    # Validate the printer_name_prefix
    if [ "${printer_name_prefix}" != "" ] ; then 
        printer_name_prefix_check=`echo "${printer_name_prefix}" | awk '{ print $2 }'`
        if [ "${printer_name_prefix_check}" != "" ]; then
            echo "ERROR! : printer_name_prefix must be a single string with out any spaces or tabs"
            echo "         printer setup will now exit"
            exit -1
        fi
    else
        # If no prefix was specified then disable printer_prefixing
        printer_prefixing="NO"
    fi
    
    # Validate the print queue remmove command if specified.
    if [ "${remove_disabled_queues_with_prefix_which_matches_start_of_queue_name}" == "YES" ] ; then
        if [ "${printer_prefixing}" != "YES" ] || [ "${printer_name_prefix}" == "" ] || [ "${printer_name_prefix_delimiter}" == "" ] ; then
            echo "ERROR! : Printer prefixing not enabled."
            echo "         In order to use the \"-x\" option printer prefixing"
            echo "         must be enabled and a prefix queue name must be specified."
            echo "         The printer name prefix may be enabled using the \"-n\" option."
            exit -1
        else
            # We are going to be deleting queues so tempoary storge of printer details will be required - lets turn it on
            temporarly_store_details_of_queues_to_be_configured="YES"
        fi
    fi
    
    
    # Ensure the assetName is in Captials - is this needed - further testing required. 
    # This should be built into an asset name retrieval module.
    if [ "${assetName}" != "" ] ; then
        assetName=`echo "${assetName}" | tr "[:lower:]" "[:upper:]"`
    fi

    # This is the user which is executed if setting default printer for user is "ON" - this is above, but we can load 
    # it correctly now there are no other options have been removed from the command line.
    user_to_set_default_printer_for="${1}"


########  ADDITIONAL CONFIGURATION ( post command line options ) ##########
#
# System Script Status is : (ON/OFF)
# The system script status determins wether the scripting subcomponent is enabled
# This Setting can now be overidden by with command line options
if [ "${system_script_status}" == "" ] ; then 
    system_script_status="ON"
fi




#############################    FUNCTIONS    #############################
#
# Functions called in this script

function export_global_varibles {

        # This may be removed at some stage and passed using a differnet meathod
        # Once we switch to python.


		PATH="/bin:/sbin:/usr/bin:/usr/sbin"
		export PATH 
		export printer_setup_folder
		export printer_setup_links_folder
        export create_printer_script
        export printer_list_folder
        export psf_parsing_utility
        export psf_search_keys_conf_file
        export psf_reserved_options_conf_file
		export printer_setup_files_folder
		export printer_setup_scripts_folder
		export printer_ppd_folder
		export roomNumber
		export assetName
		export user_to_set_default_printer_for
		export setting_default_user_printer
		export setting_default_machine_printer
		export PRINTERSETUP_CONTINUE
		export PRINTERSETUP_STOP
		export default_printer_has_PSF
		export printer_publishing_status
		export printer_prefixing
		export printer_name_prefix
		export printer_name_prefix_delimiter
		export printer_location_prefix
        export printer_location_prefix_delimiter
        export printer_description_prefix
        export printer_description_prefix_delimiter
        export remove_disabled_queues_with_prefix_which_matches_start_of_queue_name

        
}


function open_log {
        
        # export the printer_setup_log varible so that printer
        # setup scripts can log thier success or failure of 
        # printer setup.
        
        # Check Log File is Pointing Somwhere
        if [ "$printer_setup_log" == "" ] ; then
            printer_setup_log="/dev/null"
        fi
        
        # Touch the Log file and check it exists and is accessable
        touch "${printer_setup_log}"
        if [ $? != 0 ] || ! [ -f "${printer_setup_log}" ] ; then 
            printer_setup_log="/dev/null"
        fi
                
        # Export the log file path to other PrinterSetup subsystem components - this only happens here.     
        export printer_setup_log
        
    
        # being log initilisation
        echo "#############################" >> "$printer_setup_log"
        echo `date` >> "$printer_setup_log"
        echo "" >> "$printer_setup_log"
        
}

function close_log {
    
        # Closes the Log File
        echo "" >> "$printer_setup_log"
        echo "" >> "$printer_setup_log"
        
}



function set_default_printer {

		if [ "${user_to_set_default_printer_for}" == "" ] ; then
			setting_default_user_printer="OFF"
			user_to_set_default_printer_for="DISABLED"
			echo "    WARNING!: Unable to set a default user printer, no user specified." | tee -ai "$printer_setup_log"
		fi
		# If the default printer has been set - and there is a PSF File
		if [ "${default_printer_is_set}" == "YES" ] && [ "${default_printer_PSF_path}" != "" ] && [ "${default_printer_has_PSF}" == "YES" ] ; then
			"${set_default_printer_script}" "${default_printer_PSF_path}"
		fi
		
		# If the default printer has been set - and there is no PSF file availible
		if [ "${default_printer_is_set}" == "YES" ] && [ "${default_printer_PSL_name}" != "" ] && [ "${default_printer_has_PSF}" == "NO" ] ; then
			"${set_default_printer_script}" "${default_printer_PSL_name}"
		fi

}

function calculate_room_number {

		# Calculates the room number we are in from NVRAM
	
		# Retrive the Asset Name
		if [ "${assetName}" == "" ] ; then
    		  assetName=`nvram asset-name 2> /dev/null | cut -c 12-`
	        fi
	    	
		if [ "$assetName" == "" ]; then 
			echo 'NVRAM "asset-name" is not specified'
			echo 'You may specify an asset-name using the "-a" flag.'
			echo '  example situation : configure all  PSF, and PSL files which match "TEST" as the asset-name.'
			echo '  example command   : ./PrinterSetup.sh -a TEST'
			sleep 2
			exit 0
		fi
		
		# Calculate RoomNumber
		roomNumber=`echo "$assetName" | awk 'BEGIN { FS = "-" } ; { print $1 }'`

}




function setup_temp_printersetup_directory {
    # Create a Temporary Directory for Printer Setup
    tmp_printersetup_directory=`mktemp -d /tmp/printersetup.XXXXXXXXXXX`
    if [ $? != 0 ] ; then
        echo "Error : Creating Temporary PrinterSetup Directory" | tee -ai "$printer_setup_log"
        return -1
    fi
    # Ensure we are the only users with access to this directory
    chmod 700 "${tmp_printersetup_directory}"
    if [ $? != 0 ] ; then
        echo "Error : Setting Permissions of Temporary PrinterSetup Directory" | tee -ai "$printer_setup_log"
        rm -rf "${tmp_printersetup_directory}"
        return -2
    fi
    return 0
    
}



function setup_required_temporary_directory_structure {
   
    # Create the required temporary directory structure for the current PrinterSetup configruation
     setup_temp_printersetup_directory
    if [ $? != 0 ] ; then
        return -1
    fi

    # Establish Tempoary Direcotrie Varibles
    temp_details_directory="${tmp_printersetup_directory}/${temp_details_directory_name}"
    temp_details_symbolic_links_directory="${temp_details_directory}/${temp_details_symbolic_links_directory_name}"
    
    temp_details_enabled_print_queue_names_file="${temp_details_directory}/${temp_details_enabled_print_queue_names_file_name}"
    temp_details_enabled_print_queue_descriptions_file="${temp_details_directory}/${temp_details_enabled_print_queue_descriptions_file_name}"
    temp_details_enabled_print_queue_locations_file="${temp_details_directory}/${temp_details_enabled_print_queue_locations_file_name}"
    temp_details_enabled_print_queue_addresses_file="${temp_details_directory}/${temp_details_enabled_print_queue_addresses_file_name}"
    
    temp_details_enabled_unique_print_queue_names_file="${temp_details_directory}/${temp_details_enabled_unique_print_queue_names_file_name}"
    temp_details_enabled_unique_print_queue_descriptions_file="${temp_details_directory}/${temp_details_enabled_unique_print_queue_descriptions_file_name}"
    temp_details_enabled_unique_print_queue_locations_file="${temp_details_directory}/${temp_details_enabled_unique_print_queue_locations_file_name}"
    temp_details_enabled_unique_print_queue_addresses_file="${temp_details_directory}/${temp_details_enabled_unique_print_queue_addresses_file_name}"

    temp_all_system_queue_names_file="${temp_details_directory}/${temp_all_system_queue_names_file_name}"
    temp_all_system_queue_names_with_prefix_file="${temp_details_directory}/${temp_all_system_queue_names_with_prefix_file_name}"
    temp_all_system_queue_names_with_prefixt_but_not_enabled_file="${temp_details_directory}/${temp_all_system_queue_names_with_prefixt_but_not_enabled_file_name}"
    
	temp_ppds_dir="${tmp_printersetup_directory}/${temp_ppd_dir_name}"
	
    # This is exported here because this will not exit until it is configured. Makes more sense.
    export temp_details_symbolic_links_directory

    export temp_details_enabled_print_queue_names_file
    export temp_details_enabled_print_queue_descriptions_file
    export temp_details_enabled_print_queue_locations_file
    export temp_details_enabled_print_queue_addresses_file

    export temp_details_enabled_unique_print_queue_names_file
    export temp_details_enabled_unique_print_queue_descriptions_file
    export temp_details_enabled_unique_print_queue_locations_file
    export temp_details_enabled_unique_print_queue_addresses_file
    
    export temp_all_system_queue_names_file
    export temp_all_system_queue_names_with_prefix_file
    export temp_all_system_queue_names_with_prefixt_but_not_enabled_file
    
    export temporarly_store_details_of_queues_to_be_configured
    export tmp_printersetup_directory
    export temp_details_directory
    export temp_details_symbolic_links_directory
    export printer_setup_utilities_temporary_directory_scripts_folder
    export temp_psf_dump_details_script
    export temp_append_psf_details_to_file_script
    
    export temp_ppds_dir
    
    # Genrate the Required Directory Structure Within the Temporary Directory
    mkdir "${temp_details_directory}"
    if [ $? != 0 ] ; then
        return -2
    fi
    mkdir "${temp_details_symbolic_links_directory}"
    if [ $? != 0 ] ; then
        return -3
    fi
    
    # Use temp PPD folder (can be useful for debugging PPD 
    # pre-hook script changes)
    if [ "${use_temp_ppds}" == "YES" ] ; then
        # Copy those PPDs 
        mkdir "${temp_ppds_dir}"
        if [ $? != 0 ] ; then
            return -4
        fi
        cp -r "${printer_ppd_folder}/" "${temp_ppds_dir}"
        if [ $? != 0 ] ; then
            return -5
        else
            printer_ppd_folder="${temp_ppds_dir}"
            export printer_ppd_folder
        fi
    fi
}



function create_temporary_symbolic_link_to_PSF_links {
    # Populate the temporary symbolic link directory with the current
    # PSF we are setting up. Fail silently something goes wrong with creating the link.
    temporary_psf_dest_link_name=`basename "${printerPSF_for_temp_link}"`
    
    # Check Absolute Paths or Realitve Path
    test_temp_link_printerPSF_for_absolute_path=`echo "${temp_link_printerPSF}" | grep -e "^/"`
    if [ "${test_temp_link_printerPSF_for_absolute_path}" == "" ] ; then
        # We need to use the absolute path rather than the realitve path when generating links in the tempoary directory.
        
        # Store the current working directory
        temp_store_current_working_directory=`pwd`

        # Calculate the requred varibles
        temp_link_printerPSF_dest_link_dirname=`dirname "${temp_link_printerPSF}"`
        temp_link_printerPSF_dest_link_basename=`basename "${temp_link_printerPSF}"`

        # Move into this directory and find the full path to this directory
        cd "${temp_link_printerPSF_dest_link_dirname}"
        temp_link_printerPSF_dest_link_dirname_pwd=`pwd`
        
        # Move back to where we were
        cd "${temp_store_current_working_directory}"
        
        # Set the absolute path to the PSF link
        temp_link_printerPSF="${temp_link_printerPSF_dest_link_dirname_pwd}/${temp_link_printerPSF_dest_link_basename}"
        
    fi
    
    # Lets create the link
    ln -s "${temp_link_printerPSF}" "${temp_details_symbolic_links_directory}/${temporary_psf_dest_link_name}" 2> /dev/null
    if [ $? != 0 ] ; then
        echo "    WARNING : Temporary link generatation failed." | tee -ai "$printer_setup_log"
        return -1 
    fi
    
    return 0
    
}


function delete_temporarly_saved_printer_details {
    rm -rf "${tmp_printersetup_directory}"
}




function ExecutePSS {
            
        # Not Currently in Use - To Be removed
        
        SEARCHDIR="$printer_setup_links_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PSS"  |  wc -l | awk '{ print $1 }'`
        
        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
                    
            for item in "${SEARCHDIR}/"PPS*; do
                
                item_name=`basename "$item"`
            
                if [ -s "${item}" -a -x "${item}" ]; then
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info Executing ${item}... 1>&2
            
            
                    # run the item and pass all parameters to the script
                    "${item}" $*
                    
                    # Check that worked
                    exit_value=$?
                    if [ $exit_value -ne 0 ]; then
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info ${item} failed! 1>&2
                    echo "     ERROR! : While Executing PSS : ${item_name}" | tee -ai "$printer_setup_log"
                    #exit $exit_value
                    fi
                fi        
            done
        fi
    
}


function ExecutePSSRoom {
        
        # PPS Room Relys Upon the "roomNumber" varible being set
        # This is then used to find printer setup scripts with the
        # corrisponding room number. Thus allowing alias to be made to
        # scripts that are for more than one room, and multiple printer
        # scripts for rooms which have multiple printers.
        
        # Having the files seperated in this way means RADmind can easily be
        # Used to deploy the using files to the machine.
        
        # Note that it is reccomended that you create the script with out the
        # PPS prefix, and instead create an alas to this script which is prfixed
        # with the format example below : 
        # 
        # Format Example : 
        #                  Actual PSS : sh-printersetup-JC101-HP.pss
        #                  Link       : PSS-JC101-HP.pss 
        #                               
        #           The .pss extension is commonaly used by
        #                  sony playstation games. 
        #     Therfore this may not be such a great idea extension
        #         to have choosen, if you have a better idea
        #       then please impliment this, and send the changes
        #                       back up stream.
        
        
        
        SEARCHDIR="$printer_setup_links_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PSS-" | wc -l | awk '{ print $1 }'`

        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
            
            echo "Executing Room Printer Setup Scripts..." | tee -ai "$printer_setup_log"
            
            for item in "${SEARCHDIR}/"PSS-${roomNumber}-*; do
            
                item_name=`basename "$item"`
                                            
                if [ -s "${item}" -a -x "${item}" ]; then
                
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info Executing ${item}... 1>&2
            
                    # run the item and pass all parameters to the script
                    # 
                    echo "     Running PSS : ${item_name}..." | tee -ai "$printer_setup_log"
                    "${item}" $*
                    
                    # Check that worked
                    exit_value=$?
                    if [ $exit_value -ne 0 ]; then
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info ${item} failed! 1>&2
                    echo "     ERROR! : While Executing PSS : ${item_name}" | tee -ai "$printer_setup_log"
                    #exit $exit_value
                    fi
                else
                    echo "     WARNING! : PSS is not executable and has been skipped" | tee -ai "$printer_setup_log"
                    echo "                PSS File Path : ${item}"
                fi
            done
        fi
    
}



function ProcessPSF {
            
        # Not Currently in Use - To Be removed 
    
        # Sets up a printer using information in a printer setup file
        # Parsing of information is performed by an external utility.
        
        SEARCHDIR="$printer_setup_links_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PSF" | wc -l | awk '{ print $1 }'`
                
        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
        
            echo "Processing Printer Setup Files..." | tee -ai "$printer_setup_log"
        
            for item in "${SEARCHDIR}/"PSF*; do            
                if [ -s "${item}" ]; then
                    item_name=`basename "$item"`
                    
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info Processing ${item}... 1>&2
                    
                    # Process the Printer Setup File
                    "${create_printer_script}" "${item}"
                    
                    # Check that Printer Setup Worked               
                    exit_value=$?
                    if [ $exit_value != 0 ]; then
                        echo -n "    " ; logger -s -t SetupPrinters -p user.info ${item} failed! 1>&2
                        echo "     ERROR! : While Executing PSF : ${item_name}" | tee -ai "$printer_setup_log"
                        #exit $exit_value
                    fi
                fi
            done
        fi
    
}


function ProcessPSFRoom {
        
        # PPS Room Relys Upon the "roomNumber" varible being set
        # This is then used to find printer setup scripts with the
        # corrisponding room number. Thus allowing alias to be made to
        # scripts that are for more than one room, and multiple printer
        # scripts for rooms which have multiple printers.
        
        # Having the files seperated in this way means RADmind can easily be
        # Used to deploy the using files to the machine.
        
        # Note that it is reccomended that you create the script with out the
        # PPS prefix, and instead create an alas to this script which is prfixed
        # with the format example below : 
        # 
        # Format Example : 
        #                  Actual PSF : sh-printersetup-JC101-HP.psf
        #                  Link       : PSF-JC101-HP.psf 
        #                                       
        
       	SEARCHDIR="$printer_setup_links_folder"
		SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PSF-" | wc -l | awk '{ print $1 }'`
                
        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
        
            echo "Processing Printer Setup Room Files..." | tee -ai "$printer_setup_log"
        
            for item in "${SEARCHDIR}/"PSF-${roomNumber}-*; do            
                if [ -s "${item}" ]; then
                    item_name=`basename "$item"`
                    
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info Processing ${item}... 1>&2
                    
                    # Process the Printer Setup File
                    "${create_printer_script}" "${item}"
                    
                    # Consider temporarily storing the printer details.
                    if [ "${temporarly_store_details_of_queues_to_be_configured}" == "YES" ] ; then 
				        # We should perform some dereferencing - but that is for another day - or maybe for someone else.
				        # Instead we will just go with the link by setting printerPSF to the item varible.
				        printerPSF_for_temp_link="${item}"
				        temp_link_printerPSF="${item}"
				        create_temporary_symbolic_link_to_PSF_links
				    fi 
                    
                    # Check that Printer Setup Worked               
                    exit_value=$?
                    if [ $exit_value != 0 ]; then
                        echo -n "    " ; logger -s -t SetupPrinters -p user.info ${item} failed! 1>&2
                        echo "     ERROR! : While Executing PSF : ${item_name}" | tee -ai "$printer_setup_log"
                        #exit $exit_value
                    fi
                fi
            done
        fi
}


function ProcessCurrentPLF {
            
      	# Parse the current PLF (Printer List File) for any printers to be setup.
      	# Setup any printers which are found in the file.
      	# 
      	# A printer script will overide a printer setup file
       	# if both a PSS and a PSF exit with the same name.
       	#
       	# A printer name must not start with a period (.) or a hash (#)
       	#
       	# The name of a PSS or PSF in a PrinterList file will
       	# need to exactly match the file in the file system, or
       	# a link in the file system in the PrinterSetupFiles folder or the
       	# PrinterSetupScripts folder. If no match is found then no setup
       	# will occor for this printer even though it is listed in the PrinterList
               
      	PARSE_FILE="$current_printer_list_file"
		             
        # Check the parse file exists, contains some information and is readable
        if [ -s "${PARSE_FILE}" -a -r "${PARSE_FILE}" ] ; then
     
     		# Initilise Pasing Varibles
			run=0
			current_line=start
			line_check=""
			found_eof=0
			
			# Load the File
			exec < "${PARSE_FILE}"
			
			echo -n "    " ; logger -s -t SetupPrinters -p user.info ProcessingPrinterList ${PARSE_FILE}... 1>&2
			
			# Search throught the file 
			while [ ${found_eof} == 0 ] ; do
               
               	# Read the Line
               	read -r current_line 
               	if [ $? -ne 0 ] ; then
               		# End of the file has been found
               		found_eof=1
               	else
               		# Check the line is not starting with a period or a hash.
					line_check=`echo "${current_line}" | grep -v --regexp="^\." | grep -v --regexp="^#"`
					
					if [ "$line_check" != "" ] ; then 
					
						line_check=`echo "${current_line}" | grep -v --regexp="^\." | grep -v --regexp="^#"`
					
						printer_to_setup=`echo "${current_line}" | awk 'BEGIN { FS = "\t" } ; { print $1 }'`
						printer_is_default=`echo "${current_line}" | awk 'BEGIN { FS = "\t" } ; { print $2 }'`
		
						# Check that there is a matching printer setup file or printer setup script
						
						# Set the path to the possible locations of setup script or setup file
						printerPSS="${printer_setup_scripts_folder}/${printer_to_setup}"
						printerPSF="${printer_setup_files_folder}/${printer_to_setup}"
						
						# Check if ether of these exist
						if [ -f "${printerPSS}" -a -x "${printerPSS}" ] || [ -f "${printerPSF}" -a -r "${printerPSF}" ] ; then
						
							# Check first for the Printer Setup Script for the printer
							if [ -s "${printerPSS}" -a -x "${printerPSS}" ] ; then
								
								# run the item and pass all parameters to the script
								echo "      Executing PSS : ${printerPSS}..." | tee -ai "$printer_setup_log"
								"${printerPSS}" $*
								
								#Check that worked
								exit_value=$?
								if [ $exit_value != 0 ]; then
									echo -n "    " ; logger -s -t SetupPrinters -p user.info ${printerPSS} failed! 1>&2
									echo "     ERROR! : While Executing PSS : ${printer_to_setup}" | tee -ai "$printer_setup_log"              	
								fi
								
							else
							
								# IF the Printer Setup Script is not found then check the for the printer setup file exists
								if [ -s "${printerPSF}" -a -r "${printerPSF}" ] ; then
									
									
									# Process the printers assoiated Printer Setup File
									echo "      Processing PSF : ${printerPSF}..." | tee -ai "$printer_setup_log"
									"${create_printer_script}" "${printerPSF}"
									
									
									# Consider temporarily storing the printer details.
								    if [ "${temporarly_store_details_of_queues_to_be_configured}" == "YES" ] ; then 
								        temp_link_printerPSF="${printerPSF}"
                                        printerPSF_for_temp_link_basename=`basename "${printerPSF}"`
                                        printerPSF_for_temp_link_dirname=`dirname "${printerPSF}"`
								        printerPSF_for_temp_link="${printerPSF_for_temp_link_dirname}/PSF-${printerPSF_for_temp_link_basename}-EXTRACTED-FROM-PLF"
									    create_temporary_symbolic_link_to_PSF_links
								    fi 
										
										
									# Check Defaut Printer is has not been set
									if [ "${default_printer_is_set}" == "NO" ] ; then
										# Checking weather this printer should be the defualt printer
										if [ "${printer_is_default}" == "*" ] ; then
											# Load the printer name
   											default_printer_PSF_path="${printerPSF}"
											default_printer_is_set="YES"
										fi
									fi
									
								fi
							fi
						else
							echo "      WARNING!: Unable to access assosiated PPS or PSP for printer : ${printer_to_setup}" | tee -ai "$printer_setup_log"
							echo "                Check PSS exists and is executable or check PSF exists and is readbale." | tee -ai "$printer_setup_log"
                            # Check Defaut Printer is has not been set
                            if [ "${default_printer_is_set}" == "NO" ] ; then
                                # Checking weather this printer should be the defualt printer
                                if [ "${printer_is_default}" == "*" ] ; then
                                    # Load the printer name
                                    default_printer_PSF_path=""
                                    default_printer_is_set="YES"
                                    default_printer_has_PSF="NO"
                                    default_printer_PSL_name="$printer_to_setup"
                                    echo "                Printer is specified as default, will attempt to set this printer as the default" | tee -ai "$printer_setup_log" 
                                fi
                            fi
                            
                            
						fi	
					fi
				fi
            done
        fi
}

function ProcessPLF {
        
       	# Processes PLF (Printer List Files) in the priner list folder
       	#  
       	# Note : PrinterList names may not start with a period.
        
        SEARCHDIR="$printer_setup_links_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PLF" | wc -l | awk '{ print $1 }'`
        
        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
            echo "Processing Printer List Files..." | tee -ai "$printer_setup_log"
            for item in "${SEARCHDIR}/"PLF*; do          
            item_name=`basename "$item"`  
                if [ -s "${item}" -a -r "${item}" ]; then
                    
					echo "    Processing PLF : ${item_name}..." | tee -ai "$printer_setup_log"
					
					# Set the Current PLF
					current_printer_list_file="${item}"
                    # Process the Printer Setup File
                    ProcessCurrentPLF
                    # Reset th Current PLF (just to be safe)
                    current_printer_list_file=""
                    
                else
					echo "      WARNING!: Unable to access PLF : ${item_name}" | tee -ai "$printer_setup_log"
					echo "                Check PLF exists and is readable." | tee -ai "$printer_setup_log"
				fi	
            done
        fi
}


function ProcessPLFRoom {
        
       	# Processes PLF (Printer List Files) in the priner list folder
       	#  
       	# Note : PrinterList names may not start with a period.
       	#
       	# Format Example : 
        #                  Actual PLF : HelpDesk.plf
        #                  Link       : PLF-HELPDESK-001.pls 
        #
                
        SEARCHDIR="$printer_setup_links_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PLF-" | wc -l | awk '{ print $1 }'`
                
        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
            echo "Processing Printer List Room Files..." | tee -ai "$printer_setup_log"
            for item in "${SEARCHDIR}/"PLF-${roomNumber}-*; do
            item_name=`basename "$item"`
  	          if [ -f "${item}" -a -r "${item}" ]; then
                    
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info ProcessingPrinterList ${item}... 1>&2
					echo "    Running PLF : ${item_name}..." | tee -ai "$printer_setup_log"
					
					# Set the Current PLF
					current_printer_list_file="${item}"
                    # Process the Printer Setup File
                    ProcessCurrentPLF
                    # Reset th Current PLF (just to be safe)
                    current_printer_list_file=""
                else
					echo "      WARNING!: Unable to access PLF : ${item_name}" | tee -ai "$printer_setup_log"
					echo "                Check PLF exists and is readable." | tee -ai "$printer_setup_log"
				fi	
            done
        fi
}


function ExecutePLS {
        
       	# Executes PLS (Printer List Scripts) in the printer setup links folder
       	# Printer list scripts can create links to and build printer list files
       	# They can also build PLF, or PSS.
       	# 
       	# Note : PrinterListScripts names may not start with a period.
       	#
       	# Format Example : 
        #                  Actual PLF : sh-setup-helpdesk-printer-staff.sh
        #                  Link       : PLS-HELPDEK-STAFF
        #
                
        SEARCHDIR="$printer_setup_links_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PLS" | wc -l | awk '{ print $1 }'`
                
        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
            echo "Executing Printer List Scritps..." | tee -ai "$printer_setup_log"
            for item in "${SEARCHDIR}/"PLS*; do
              item_name=`basename "$item"`
  	          if [ -s "${item}" -a -x "${item}" ]; then
                    
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info ExecutingPrinterListScritp ${item}... 1>&2
					echo "    Running PLS : ${item_name}..." | tee -ai "$printer_setup_log"
					
					# Execute Printer List Script and pass all arguments to this script
                   "${item}" $*
                   	
                   	# Check that worked
                   	exit_value=$?
                    if [ $exit_value -ne 0 ]; then	
						echo -n "    " ; logger -s -t SetupPrinters -p user.info ${item} failed! 1>&2
						echo "     ERROR! : While Executing PLS : ${item_name}" | tee -ai "$printer_setup_log"
						#exit $exit_value
                    fi
                else
					echo "      WARNING!: Unable to access PLS : ${item_name}" | tee -ai "$printer_setup_log"
					echo "                Check PSL exists and is readable." | tee -ai "$printer_setup_log"
				fi	
            done
        fi
}


function ExecutePLSRoom {
        
       	# Executes PLS (Printer List Scripts) in the printer setup links folder for a this Room
       	# Printer list scripts can create links to and build printer list files
       	# They can also build PLF, or PSS.
       	# 
       	# Note : PrinterListScripts names may not start with a period.
       	#
       	# Format Example : 
        #                  Actual PLF : sh-setup-helpdesk-printer-staff.sh
        #                  Link       : PLS-HELPDEK-STAFF
        #
                
        SEARCHDIR="$printer_setup_links_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | grep --regexp="^PLS-" | wc -l | awk '{ print $1 }'`
                
		if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
            echo "Executing Printer List Scritps..." | tee -ai "$printer_setup_log"
            for item in "${SEARCHDIR}/"PLS-${roomNumber}-*; do
           
              item_name=`basename "$item"`
              
  	          if [ -s "${item}" -a -x "${item}" ]; then
                    
                    echo -n "    " ; logger -s -t SetupPrinters -p user.info ExecutingPrinterListScritp ${item}... 1>&2
					echo "    Running PLS : ${item_name}..." | tee -ai "$printer_setup_log"
					
					# Execute Printer List Script and pass all arguments to this script
                   "${item}" $*
                   	
                   	# Check that worked
                   	exit_value=$?
                    if [ $exit_value -ne 0 ]; then	
						echo -n "    " ; logger -s -t SetupPrinters -p user.info ${item} failed! 1>&2
						echo "     ERROR! : While Executing PLS : ${item_name}" | tee -ai "$printer_setup_log"
						#exit $exit_value
                    fi
                else
					echo "      WARNING!: Unable to access PLS : ${item_name}" | tee -ai "$printer_setup_log"
					echo "                Check PSL exists and is readable." | tee -ai "$printer_setup_log"
				fi	
            done
        fi
}

function report_prefixing {

        if [ "${printer_name_prefix}" != "" ] ; then
            echo "Printer Name Prefix : $printer_name_prefix" | tee -ai "$printer_setup_log"
        fi
        
        if [ "${printer_location_prefix}" != "" ] ; then
            echo "Printer Location Prefix : $printer_location_prefix" | tee -ai "$printer_setup_log"
        fi
        
        if [ "${printer_description_prefix}" != "" ] ; then
            echo "Printer Description Prefix : $printer_description_prefix" | tee -ai "$printer_setup_log"
        fi
 
}

#############################      LOGIC      #############################
#
# Locic controlling this Script

if [ "${system_status}" == "ON" ] ; then 
    
    # Check we are running as root
    currentUser=`whoami`
    if [ $currentUser != "root" ] ; then
        echo This script must be run with super user privileges
        exit -127
    fi
    
    # Intitalise Log File
    open_log
    
    # Deal with Temporary Directory Setup if Required
    if [ "${temporarly_store_details_of_queues_to_be_configured}" == "YES" ] ; then
        setup_required_temporary_directory_structure
        if [ $? != 0 ] ; then
            echo "ERROR : During Setup of Temporary Directories"
            exit -127
        fi   
    fi
    
    # Caclulate the room number
    calculate_room_number
    
    # Export the global varibles
    export_global_varibles
    
    report_prefixing
    
    if [ "${system_script_status}" == "ON" ] ; then
    	
    	# Execute Pre Printer Link Setup Hook
    	if [ -s "${printer_setup_pre_hook}" -a -x "${printer_setup_pre_hook}" ] ; then
    		"${printer_setup_pre_hook}"
    		printer_setup_pre_hook_exit_status=$?
    		
    		# Check for call to halt printer setup
    		if [ ${printer_setup_pre_hook_exit_status} == $PRINTERSETUP_STOP ] ; then
    			# Printers will not be changed, just clean up.
				echo "Printer Setup Stopped by pre-setup hook." | tee -ai "$printer_setup_log"
				echo "Printers have not been modified." | tee -ai "$printer_setup_log"
    			system_status=off
    			close_log
    			exit 0
    		fi
    	fi
    	
    	# Execute Printer List Scripts
		ExecutePLSRoom
	
	    # Execute Printer Room Setup Scripts
    	ExecutePSSRoom
    fi
    
    # Process Printer Room Setup Files
    ProcessPSFRoom
    
    # Process Printer Setup Lists
    ProcessPLFRoom
    
    # Set the Default Printer
    set_default_printer
    
    
    # Temporary Storage and Queue Removal
    if [ "${temporarly_store_details_of_queues_to_be_configured}" = "YES" ] ; then
    
        echo "Generating Tempoary Files..." | tee -ai "$printer_setup_log"
    
        # Create temporary files with details of enabled printers - includes unique file generation
        echo "    Generating Enabled PSF Tempoary Detail Files..." | tee -ai "$printer_setup_log"
        if [ -f "${temp_psf_dump_details_script}" -a -x "${temp_psf_dump_details_script}" ] ; then
            "${temp_psf_dump_details_script}"
            if [ $? != 0 ] ; then
                temp_errors_while_runnnig_temp_scripts="NO"
            fi
        fi
        
        # Create Tempory files containing the list of system queue names and also the prefixed queue names
        if [ -f "${temp_generate_all_system_queue_names_script}" -a -x "${temp_generate_all_system_queue_names_script}" ] ; then
            echo "    Generating System Queues Tempoary Name Files..." | tee -ai "$printer_setup_log"
            "${temp_generate_all_system_queue_names_script}"
            if [ $? != 0 ] ; then
                temp_errors_while_runnnig_temp_scripts="YES"
            fi
            
        fi
        
        # Check to see if we should be removing unused printers with names matching the prefix provided
        if [ ${remove_disabled_queues_with_prefix_which_matches_start_of_queue_name} == "YES" ] ; then
            if [ "${printer_setup_queuemanagment_remove_disabled_queues_with_prefix_script}" == "" ] || [ "${printer_prefixing}" != "YES" ] || [ "${printer_name_prefix}" == "" ] || [ "${printer_name_prefix_delimiter}" == "" ] ; then
                echo "    ERROR! : Required varibles for deletion of queues were not availible." | tee -ai "$printer_setup_log"
                echo "             Skipping queue deletion." | tee -ai "$printer_setup_log"
            else
                if [ "${temp_errors_while_runnnig_temp_scripts}" == "NO" ] ; then
                    # Delete the appropriate disabled queues if the script is availible and executable.
                    if [ -f "${printer_setup_queuemanagment_remove_disabled_queues_with_prefix_script}" -a -x "${printer_setup_queuemanagment_remove_disabled_queues_with_prefix_script}" ] ; then
                        echo "    Removing unused queues with name starting with supplied queue name prefix..." | tee -ai "$printer_setup_log"
                        "${printer_setup_queuemanagment_remove_disabled_queues_with_prefix_script}"
						if [ $? == 0 ] ; then
							echo "    Unused queues succesfully removed." >> "$printer_setup_log"
						else
							echo "    ERROR! : Problems were encountered during unused queue removal." | tee -ai "$printer_setup_log"
						fi
                    else
                        echo "    ERROR! : Unable to find the script to remove unused queues." | tee -ai "$printer_setup_log"
                        echo "             Skipping queue deletion." | tee -ai "$printer_setup_log"
                    fi
                else
                     echo "    ERROR! : One or more of the tempoary details scripts exited with errors." | tee -ai "$printer_setup_log"
                     echo "             Skipping queue deletion." | tee -ai "$printer_setup_log"
                fi
            fi
        fi

        
    fi
    
    # System Script Status
    if [ "${system_script_status}" == "ON" ] ; then
    	
    	# Execute Printer Post Link Setup Hook
    	if [ -s "${printer_setup_post_hook}" -a -x "${printer_setup_post_hook}" ] ; then
    		"${printer_setup_post_hook}"
    	fi
    fi
    
    exit 0
        
    # Consider the deletion any infomation which was temporarly stored regarding 
    # the printers which we have tried (and perhpas succeeded) to setup.
    if [ "${temporarly_store_details_of_queues_to_be_configured}" = "YES" ] ; then
        echo "    Cleaning up Temporary Directory..." | tee -ai "$printer_setup_log"
        delete_temporarly_saved_printer_details
    fi
    
    
    # Close the Log File
    echo "Printer Setup Complete." | tee -ai "$printer_setup_log"
    close_log
    
fi


exit 0


