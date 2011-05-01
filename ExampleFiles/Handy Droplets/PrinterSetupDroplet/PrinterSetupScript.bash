#!/bin/bash

#
# Script is licenced under the GNU GPL 
# ©Copyright 2007 Henri Shustak
# Lucid Information Systems
# http://www.lucidsystems.org
#

# Creates a print queue from a printer setup file
# This script is a quick way of creating a queue from a printer setup file


######################
#     VARIABLES      #
######################
printersetup_directory=""
printersetup_executable="PrinterSetup.sh"
printersetup_executable_absolute_path="${printersetup_directory}""/""${printersetup_executable}"
printersetup_file=${1}
printersetup_file_basename=`basename "${printersetup_file}"`
printersetup_links_directory="${printersetup_directory}""/""PrinterSetupLinks"
exit_status=0
nvram_path="/usr/sbin/nvram"
asset_name=""
setupPrinter=""


######################
#     FUNCTIONS      #
######################

function cleanexit {

    if [ -f "${setupPrinter}" ] ; then
        rm "${setupPrinter}"
    fi 
    
    exit ${exit_status}
}


function pre_flight_check {
    
    # Check we are running as root
    currentUser=`whoami`
    if [ $currentUser != "root" ] ; then
        echo "This script must be run with super user privileges"
        exit_status=-127
        cleanexit
    fi

    # Setup the Asset Name
    if [ "${asset_name}"="" ] ; then
    
        room_number=""
        
        # Check if NVRAM utility is availible - set up a default room number if there is not already one availible
        if [ -f "${nvram_path}" ] ; then 
            room_number=`nvram asset-name | cut -c 12- | awk 'BEGIN { FS = "-" } ; { print $1 }'`
        fi
        
        if [ "${room_number}" == "" ] ; then 
            room_number="PRINTERSETUPCREATEPRINTERTMP"
        fi
        
        asset_name="${room_number}""-""PrinterDroplet2Setup"
        
    fi


    # Check the printer setup directory has been specified
    if [ "${printersetup_directory}" == "" ] ; then 
        echo "ERROR! : No printersetup directory has been specified"
        echo "         Please edit the createprinter.sh file"
        echo "         and specify the printersetup directory"
        exit_status=-126
        cleanexit
    fi
    
    # Check that the printer setup utility exisits.
    if ! [ -f "${printersetup_executable_absolute_path}" ] ; then
        echo "ERROR! : Unable to find the specified printersetup utility"
        exit_status=-125
        cleanexit
    fi
    
    # check that the printer setup file specified to create exists.
    if ! [ -f "${printersetup_file}" ] ; then
        echo "ERROR! : Uable to find the specified printersetup file"
        exit_status=-124
        cleanexit
    fi
    
    # Check that the PrinterSetup Links directory exists.
    if ! [ -d "${printersetup_links_directory}" ] ; then
        echo "ERROR! : Uable to find the specified PrinterSetupLinks directory"
        exit_status=-123
        cleanexit
    fi
    
    
    
}

function prep_printer_setup {


    # Setup the name of the printer setup link file
    setupPrinter="${printersetup_links_directory}""/""PSF-""${asset_name}"
    
    # Remove any link to create which may already exist
    if [ -f "${setupPrinter}" ] ; then
        rm "${setupPrinter}"
    fi 
     
    # Create the link to the printer setup file
    ln -s "${printersetup_file}" "${setupPrinter}"
    if [ $? != 0 ] ; then
        echo "ERROR! : Attempting to create printer setup links"
        echo "         PrinterSetup Fille not processed"
        echo "         PSF : $printersetup_file_basename"
        exit_status=-122
        cleanexit
    fi
    
    

}


function create_printer {

    # Check the link to the PSF exists then run printer setup
    if [ -f ${setupPrinter} ] ; then 
        ${printersetup_executable_absolute_path} -s OFF -a ${room_number}-0000
    fi

}



######################
#       LOGIC        #
######################


pre_flight_check
prep_printer_setup
create_printer


cleanexit
exit 0


