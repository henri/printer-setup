#!/bin/bash

## upload.bash
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

########## CONFIGURATION ############

# The configuration directory realitive to this script 
printersetup_sync_configuration_directory_realitve="../configurations"

# Various Configuration Files
printersetup_sync_configuration_file="${printersetup_sync_configuration_directory_realitve}/configuration.conf"
printersetup_sync_server_verification_file="${printersetup_sync_configuration_directory_realitve}/server_verification"
printersetup_sync_upload_exclude="${printersetup_sync_configuration_directory_realitve}/excludes_upload.txt"




######## INTERNAL VARIBLES ##########

absolute_path=""
configuration_file_absolute_path=""
server_key_file_absolute_path=""
server_verification_file_absolute_path=""


############ FUNCTIONS ##############


function pre_flight {

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
    configuration_file_absolute_path="${partent_dir_absolute_path}/${printersetup_sync_configuration_file}"
    server_verification_file_absolute_path="${partent_dir_absolute_path}/${printersetup_sync_server_verification_file}"
    printersetup_sync_upload_exclude_absolute_path="${partent_dir_absolute_path}/${printersetup_sync_upload_exclude}"
    
    # Get out of here!
    return 0
    
}



function check_extra_conf_files {

    if ! [ -f "$server_verification_file_absolute_path" ] ; then
        echo " ERROR! : Unable to locate server verification file"
        echo "          $server_verification_file_absolute_path"
        exit -127
    fi
    
    
    if ! [ -f "$printersetup_sync_upload_exclude_absolute_path" ] ; then
        echo " ERROR! : Unable to locate downlaod excludes file"
        echo "          $printersetup_sync_upload_exclude_absolute_path"
        exit -127
    fi
    
    

}



function load_configuration {

    # Read the configuration file
    if [ -f "${configuration_file_absolute_path}" -a -r "${configuration_file_absolute_path}" ] ; then
        source "${configuration_file_absolute_path}"
    else
        echo "ERROR! : Locating PrinterSetup Sync configuration file while trying to downalod." | tee -ai "${printer_setup_log}"
        echo "         $configuration_file_absolute_path" | tee -ai "${printer_setup_log}"
        exit -127
    fi
    
    return 0
    
}



function upload_printersetup {

    # Upload the printe setup configuration from the server
    
    # -a :          for archive
    # -z :          for compression
    # -E :          Extended Attributes
    # --delete :    remove files which are removed on the server (mirror)
    # -e :          use transport (in this case SSH)
    
    rsync -az -E --delete --exclude-from="${printersetup_sync_upload_exclude_absolute_path}" -e "ssh -p ${printersetup_sync_remote_port} -o GlobalKnownHostsFile=${server_verification_file_absolute_path}" ${printersetup_sync_local_path}/ ${printersetup_sync_remote_user}@${printersetup_sync_server}:${printersetup_sync_remote_path}/
    
    
    if [ $? != 0 ] ; then
        echo "    ERROR! : Uploading Updates from the PrinterSetup sync server."
        exit -127
    fi
    
    return 0

}





############## LOGIC ##############


where_are_we
load_configuration
upload_printersetup



exit 0



