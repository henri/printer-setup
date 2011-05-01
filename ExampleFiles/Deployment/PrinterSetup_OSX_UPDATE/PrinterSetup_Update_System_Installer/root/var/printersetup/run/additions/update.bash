#!/bin/bash

## update_configuration.bash
##//////////////////////////////////////////////////////////
## 
## Copyright 2008 © Henri Shustak GNU GPL v2
## Lucid Information Systems
## http://lucidsystems.org
##

########################################
##
##  What this script is going to do :
##
##      This script is going to check with a server for updates to
##      a printer setup configuration specifed as the current_configuration_name
##     
##      This configuraton may include print queue additions,
##      modifications, deletions or driver updates.
##

# Version 1

## Load Variables

# Configuration name
current_configuration_name="${current_configuration_name}"

# Server Settings 
printersetup_update_remote_user="${printersetup_update_remote_user}"
printersetup_update_remote_path="${printersetup_update_remote_path}"
printersetup_update_remote_port="${printersetup_update_remote_port}"
printersetup_update_queue_name_prefix="${printersetup_update_queue_name_prefix}"

# Current Details Required for the update
printer_setup_update_current_configuration_directory="${printer_setup_update_current_configuration_directory}"
printer_setup_update_current_server_key="${printer_setup_update_current_server_key}"
printer_setup_update_current_server_verification="${printer_setup_update_current_server_verification}"
configuration_server_settings_file_name="${printer_setup_update_current_remote_path_file}"

# Saved Configuration Details
printer_setup_update_saved_configurations_directory="${printer_setup_update_saved_configurations_directory}"
printer_setup_update_current_saved_configuration_directory="${printer_setup_update_current_saved_configuration_directory}"





##########    FUNCTIONS   ##########

function check_rsync {

    system_rsync_version=`rsync --version`
    if [ $? != 0 ] ; then
        echo "    ERROR! : Version of rsync is incompatible."
        exit -127
    fi

}

function preflight_check {
 
    # Check we are running as root
    currentUser=`whoami`
    if [ $currentUser != "root" ] ; then
        echo "This script must be run with super user privileges."
        exit -127
    fi
        
    check_rsync    
        
    return 0
    
}





function prep_the_update_download_directory {
    
    # Double check the saved configuration directory is availible
    if ! [ -d "${printer_setup_update_saved_configurations_directory}" ] ; then
        echo "    ERROR! : Unable to find the saved configurations directory."
        exit -127
    fi
    
    # Check if the current configuration direcotry exists 
    if ! [ -d "${printer_setup_update_current_saved_configuration_directory}" ] ; then
        # We better make one for the download
        mkdir "${printer_setup_update_current_saved_configuration_directory}"
        if [ $? != 0 ] ; then
            echo "    ERROR! : Creating Current Saved Configuration Direcotry"
            exit - 127
        fi  
    fi
    
    return 0

}

function pull_down_the_update {

    # Pull down PrinterSetup Configruation From the Server
    rsync -a -e "ssh -p ${printersetup_update_remote_port} -i ${printer_setup_update_current_server_key} -o GlobalKnownHostsFile=${printer_setup_update_current_server_verification}" ${printersetup_update_remote_user}@${current_configuration_name}:${printersetup_update_remote_path}/ ${printer_setup_update_current_saved_configuration_directory}
    if [ $? != 0 ] ; then
        echo "    ERROR! : Downloading update from PrinterSetup update server."
        exit - 127
    fi
    return 0

}


##########    LOGIC   ##########
preflight_check
prep_the_update_download_directory
pull_down_the_update

exit 0


