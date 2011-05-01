#!/bin/bash

## run_configuration.bash
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
##      This script is going to perform all 
##      any actions requred for an configuration
##

# Version 1.1

#
## Version History
#
# Version 1.1 - Checks for dynamic lock file before updating. 
# Version 1.0 - Initial Implementation
#


# Grab Input from command line
current_configuration_name="${1}"

## Configuration File Names
configuration_server_verification_file_name="server_verification"
configuration_server_key_file_name="server_key"
configuration_server_settings_file_name="server_settings"
configuration_server_last_updated_file_name="server_last_updated"


# Log Files
printersetup_update_logs_directory="/var/logs/printersetup/"
printersetup_update_log_file="${printersetup_update_logs_directory}/update.log"
printersetup_configure_log_file="${printersetup_update_logs_directory}/configure.log"


# Settings
printer_setup_update_settings_directory="/etc/printersetup"
printer_setup_update_configurations_directory="${printer_setup_update_settings_directory}/configurations"

# Server Settings Varibles
printersetup_update_remote_user=""
printersetup_update_remote_path=""
printersetup_update_remote_port=""
printersetup_update_queue_name_prefix=""

# Server Settings Search Keys
printersetup_update_remote_user_search_key=""
printersetup_update_remote_path_search_key=""
printersetup_update_remote_port_search_key=""
printersetup_update_queue_name_prefix_search_key=""

# Default Server Setting Values
defaut_printersetup_update_remote_user="PrinterSetup"
defaut_printersetup_update_remote_path="/Users/printersetup/Desktop/PrinterSetup"
defaut_printersetup_update_remote_port="22"
defaut_printersetup_update_queue_name_prefix=`echo "$current_configuration_name" | md5`

# Executables and Additions Directories
printer_setup_update_components_directory="/var/printersetup"
printer_setup_update_executables_directory="${printer_setup_update_components_directory}/run"
printer_setup_update_additions_directory="${printer_setup_update_executables_directory}/additions"

# Addition Component Names
printer_setup_addition_update_script="${printer_setup_update_additions_directory}/update.bash"

printer_setup_addition_server_settings_keys_configuration="${printer_setup_update_additions_directory}/update_server_search_keys.config"
printer_setup_addition_server_settings_keys_parseing_script="${printer_setup_update_additions_directory}/parse_update_server_settings.bash"

printer_setup_addition_unload_script="${printer_setup_update_additions_directory}/unload.bash"
printer_setup_addition_load_script="${printer_setup_update_additions_directory}/load.bash"

printer_setup_addition_install_drivers_script="${printer_setup_update_additions_directory}/install_drivers.bash"
printer_setup_addition_configure_queues_script="${printer_setup_update_additions_directory}/configure_queues.bash"


# Saved Configurations Directories
printer_setup_update_saved_configurations_directory="/var/printersetup/configurations"
printer_setup_update_current_saved_configuration_directory="${printer_setup_update_saved_configurations_directory}/${current_configuration_name}"


## Current Details
printer_setup_update_current_configuration_directory="${printer_setup_update_configurations_directory}/${current_configuration_name}"
printer_setup_update_current_server_key="${printer_setup_current_configuration_directory}/${configuration_server_key_file_name}"
printer_setup_update_current_server_verification="${printer_setup_current_configuration_directory}/${configuration_server_verification_file_name}"
configuration_server_settings_file="${printer_setup_current_configuration_directory}/${configuration_server_settings_file_name}"

## Lock Files
printersetup_dynamic_domain_lock_file="/tmp/printersetup_dynamic_${current_configuration_name}.lock"
stop_on_dynamic_lock="YES"

##########    FUNCTIONS   ##########


function check_configuration_direcotry {

    
    # Check the current configuration directory exists
    if ! [ -d "${printer_setup_update_current_configuration_directory}" ] ; then
        echo "ERROR! : Unable to locate PrinterSetup Update Configuration directory with the specified configuration name."
        exit -127
    fi
    
    # Check the Server Key Exists
    if ! [ -f "${printer_setup_update_current_server_key}" ] ; then
        echo "ERROR! : Unable to locate specifed PrinterSetup Update server key."
        exit -127
    fi
    
    # Check the Server Verification Key Exists
    if ! [ -f "${printer_setup_update_current_server_verification}" ] ; then
        echo "ERROR! : Unable to locate specifed PrinterSetup Update server verificaiton file."
        exit -127
    fi
    
    
    # Check the Server Settings File Exits
    if ! [ -f "${configuration_server_settings_file_name}" ] ; then
        echo "ERROR! : Unable to locate specifed PrinterSetup Update remote_path file."
        exit -127
    fi
    
    return 0

}



function check_printersetup_update_directories {

    # Check the Destination Pull down directory exists
    if ! [ -d "${printer_setup_update_saved_configurations_directory}" ] ; then
        echo "ERROR! : Saved configuration directory is not availible."
        exit -127
    fi

    # Check the Printer Setup Update Logs Direcory Exists
    if ! [ -d "${printersetup_update_logs_directory}" ] ; then
        echo "ERROR! : No PrinterSetup Update Logs Directory Exists."
        exit -127
    fi
    
    # Check the Printer Setup Update Directory Exists
    if ! [ -d "${printer_setup_update_settings_directory}" ] ; then
        echo "ERROR! : No Printer Setup Update Directory Specified"
        exit -127
    fi
    
    # Check the Printer Setup Update Configurations Direcotry Exits
    if ! [ -d "${printer_setup_update_configurations_directory}" ] ; then
        echo "ERROR! : Unable to locate PrinterSetup Update Configurations directory."
        exit -127
    fi

    return 0
    
}


function dynamic_lock_file_check {

    if [ -f "${printersetup_dynamic_domain_lock_file}" ] && [ "${stop_on_dynamic_lock}" == "YES" ] ; then
        # We should probably not update if there is a dynamic update taking place because 
        # Firstly, the network is probably in a state of Flux and the dynamic scripts may be making
        # use of the same directory which we could be updating. 
        return -1
    fi
    
    return 0
    
}

function preflight_check {
 
    # Check we are running as root
    currentUser=`whoami`
    if [ $currentUser != "root" ] ; then
        echo "This script must be run with super user privileges."
        exit -127
    fi
    
    # Check the various directories for Printer Setup Update are availible
    check_printersetup_update_directories
    
    # Check a configuration name has been specified.
    if [ "${current_configuration_name}" == "" ] ; then
        echo "ERROR! : PrinterSetup Update configuration was specified."
        exit -127
    fi

    # Check that the configuration directory and required files exist.
    check_configuration_direcotry
    
    # Check for a dynamic lock file
    dynamic_lock_file_check
    if [ $? != 0 ] ; then
        echo "WARNING! : Dynamic lock file present for this configuration. Skipping update"
        echo "           Please try again later or manually remove this lock file."
        echo "           Dynamic Lock File : $printersetup_dynamic_domain_lock_file"
        exit -127
    fi
    
    return 0
    
}



function import_server_settings {

    # Load the Search Keys
    if [ -f ${printer_setup_addition_server_settings_keys_configuration} ] ; then
        source "${printer_setup_addition_server_settings_keys_configuration}"
        if [ $? != 0 ] ; then
            echo "ERROR! : Reading in PrinterSetup Update Server Settings Keys Configuation File"
            exit -127
        fi
    else
        echo "ERROR! : Unable to Loacte in PrinterSetup Update server settings keys configuation file"
        exit -127
    fi
    
    ##
    ## Load the Server Settings Using the Search Keys
    ##
    
    # Load the remote_user varible from the server settings file
    current_search_key="${printersetup_update_remote_user_search_key}"
    printersetup_update_remote_user=`"${printer_setup_addition_server_settings_keys_parseing_script}" "${configuration_server_settings_file}" "${current_PSF_search_key}"`
    if [ $? != 0 ] || [ "${printersetup_update_remote_user}" == "" ] ; then
        # If an error occorued then set the default
        printersetup_update_remote_user="defaut_printersetup_update_remote_user"
    fi
    
    # Load the remote_path varible from the server settings file
    current_search_key="${printersetup_update_remote_path_search_key}"
    printersetup_update_remote_path=`"${printer_setup_addition_server_settings_keys_parseing_script}" "${configuration_server_settings_file}" "${current_PSF_search_key}"`
    if [ $? != 0 ] || [ "${printersetup_update_remote_path}" == "" ] ; then
        # If an error occorued then set the default
        printersetup_update_remote_path="defaut_printersetup_update_remote_path"
    fi

    # Load the remote_path varible from the server settings file
    current_search_key="${printersetup_update_remote_port_search_key}"
    printersetup_update_remote_port=`"${printer_setup_addition_server_settings_keys_parseing_script}" "${configuration_server_settings_file}" "${current_PSF_search_key}"`
    if [ $? != 0 ] || [ "${printersetup_update_remote_port}" == "" ] ; then
        # If an error occorued then set the default
        printersetup_update_remote_port="defaut_printersetup_update_remote_port"
    fi

    # Load the remote_path varible from the server settings file
    current_search_key="${printersetup_update_queue_name_prefix_search_key}"
    printersetup_update_queue_name_prefix=`"${printer_setup_addition_server_settings_keys_parseing_script}" "${configuration_server_settings_file}" "${current_PSF_search_key}"`
    if [ $? != 0 ] || [ "${printersetup_update_queue_name_prefix}" == "" ] ; then
        # If an error occorued then set the default
        printersetup_update_queue_name_prefix="defaut_printersetup_update_queue_name_prefix"
    fi

    
    return 0
    
}



function export_varibles {

    # Export Various Settings
    
    export current_configuration_name

    export configuration_server_verification_file_name
    export configuration_server_key_file_name
    export configuration_server_settings_file_name
    export configuration_server_last_updated_file_name
    
    export printersetup_update_logs_directory
    export printersetup_update_log_file
    export printersetup_configure_log_file

    export printer_setup_update_settings_directory
    export printer_setup_update_configurations_directory
    export printersetup_update_remote_user
    export printersetup_update_remote_path
    export printersetup_update_remote_port
    export printersetup_update_remote_prefix    
    
    export printer_setup_update_components_directory
    export printer_setup_update_executables_directory
    export printer_setup_update_additions_directory

    export printer_setup_addition_update_script
    export printer_setup_addition_server_settings_keys_configuration
    export printer_setup_addition_server_settings_keys_parseing_script
    export printer_setup_addition_unload_script
    export printer_setup_addition_load_script
    export printer_setup_addition_install_drivers_script
    export printer_setup_addition_configure_queues_script
    
    export printer_setup_update_saved_configurations_directory
    export printer_setup_update_current_saved_configuration_directory

    export printer_setup_update_current_configuration_directory
    export printer_setup_update_current_server_key
    export printer_setup_update_current_server_verification
    export configuration_server_settings_file
    
    export printersetup_dynamic_domain_lock_file
    export stop_on_dynamic_lock
    
    return 0

}

function update_configuration {

    # Call the update printer setup update script and pass the configuration name to this script
    "${printer_setup_update_update}"
    
    return 0

}



##########    LOGIC   ##########

preflight_check
import_server_settings
export_varibles
update_configuration
if [ $? != 0 ] ; then
    echo "WARNING! : Unable to retrive update from the PrinterSetup Update server."
fi






exit 0




