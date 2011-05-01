#!/bin/bash 

# update_printers.bash
##//////////////////////////////////////////////////////////
## 
## Copyright 2008 © Henri Shustak GNU GPL v3 or later
## Lucid Information Systems
## http://lucidsystems.org
##



########################################
##
##  What this script is going to do :
##
##     Download any updates from the server
##     Configure the Queues from the updates
##     
##     You could just call your update script
##     By using a PrinterSetup pre-hook
##
##     This script is desinged to show you how 
##     a seperate script can call be used to call
##     PrinterSetup.
##

# Version 1


########## CONFIGURATION ############

# The configuration directory realitive to this script 
printersetup_sync_scripts_directory_realitve="./scripts"
printersetup_sync_download_script_name="download.bash"
printersetup_sync_update_printers_queue_name_prefix="PrinterSetupManaged"
printersetup_root_realitive_path="../../.."
printersetup_executable_name="PrinterSetup.sh"


######## INTERNAL VARIBLES ##########
absolute_path=""
configuration_file_absolute_path=""
server_key_file_absolute_path=""
printersetup_executable_absolute_path=""
printersetup_sync_download_script_absolute_path=""

function pre_flight {

    # Check we are running as root
    currentUser=`whoami`
    if [ $currentUser != "root" ] ; then
        echo This script must be run with super user privileges
        exit -127
    fi

    if [ "${printer_setup_log}" == "" ] ; then
        printer_setup_log="/dev/null"
    fi

}


function where_are_we {

    # Some Settings
    current_working_dir=`pwd`
    parent_dir=`dirname "${0}"`
    my_name=`basename "${0}"`
    
    # Set the the absolute path varible
    cd "${parent_dir}"
    partent_dir_absolute_path=`pwd`
    absolute_path="${partent_dir_absolute_path}/${my_name}"
    cd "${current_working_directory}"
    
    # Set some other options - realitive to this directory
    printersetup_sync_download_script_absolute_path="${partent_dir_absolute_path}/${printersetup_sync_scripts_directory_realitve}/${printersetup_sync_download_script_name}"
    printersetup_executable_absolute_path="${partent_dir_absolute_path}/${printersetup_root_realitive_path}/${printersetup_executable_name}"
    
    # Get out of here!
    return 0
    
}




function check_extra_conf_files {

    if ! [ -f "$printersetup_sync_download_script_absolute_path" -a -x "${printersetup_sync_download_script_absolute_path}" ] ; then
        echo " ERROR! : Unable to locate PrinterSetup Sync downlaod script."         
        echo "          $printersetup_sync_download_script_absolute_path" 
        exit -127
    fi
    
    if ! [ -f "$printersetup_executable_absolute_path" -a -x "$printersetup_executable_absolute_path" ] ; then
        echo " ERROR! : Unable to locate PrinterSetup executable." 
        echo "          $printersetup_executable_absolute_path" 
        exit -127
    fi
        
}


function download_updates {

    echo "Downloading PrinterSetup configuration updates..."
    "${printersetup_sync_download_script_absolute_path}"
    return 0
    
}

function run_printersetup {
    
    echo "Running PrinterSetup..." | tee -ai "${printer_setup_log}"
    echo "" | tee -ai "${printer_setup_log}"
    # We are adding the prefix and removing printers which have this prefix and which have been removed.
    "${printersetup_executable_absolute_path}" -x -n "${printersetup_sync_update_printers_queue_name_prefix}"

    return 0

}


############## LOGIC ##############

pre_flight
where_are_we
check_extra_conf_files
echo ""
download_updates
run_printersetup
echo ""

exit 0

