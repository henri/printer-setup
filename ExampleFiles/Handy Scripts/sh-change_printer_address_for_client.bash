#!/bin/bash

# This script could erase the wrong info - ie in comments - you have been warned
# (C)2009 Henri Shustak
# License GNU GPL v3
# http://www.lucidsystems.org

# Version 0.1

# Notes : This script could be written better
# Maybe a Apple Script Interface to make it easier to use.
# That will also require a re-write.

# It is reccomended that before you run this script you copy any PSF files into a new directory.
# This is because the entire file will be re-written. Once you have made the modifications.
# Check the modified files are okay. Then if you are happy, replace the original files with
# the modified files.


new_server_address="${1}"

current_directory="`dirname "$0"`"
this_script_name="`basename "$0"`"

tmp_file_name="psf_address_repace_temporary"
tmp_file="${current_directory}/${tmp_file_name}"


# Specify the PrinterSetup Root Directory - eg "/Users/username/Desktop/PrinterSetup_vXXXX"
printer_setup_root_dir=""

# Load Manipulation Settings

# PSF Script
PSF_parse_script="${printer_setup_root_dir}/PrinterSetupUtilities/ParsePSF.sh"

# Load Search Keys
source "${printer_setup_root_dir}/PrinterSetupUtilities/PSF_SearchKeys_MacOS_104.config"

if [ ${printer_setup_root_dir} == "" ] ; then
        echo "Before running this script, copy it into the PSF directory"
        echo "Finally, you will need to edit this script and specify the printer_setup_root_dir varible"
        exit -1
fi

if [ "${new_server_address}" == "" ] ; then
        echo "  This script will replace the current server address with the one you specify. "
        echo "  It will also modify the queue name so that it matches the queue name specified within the PSF."
        echo ""
        echo "  Usage : ${this_script_name} <new_server_address>"
        echo "  eg : ${this_script_name} ldp://printserver"
        echo ""
        
        exit -1
fi



for current_psf in "${current_directory}/"* ; do

        current_psf_name="`basename "$current_psf"`"

        if [ "${current_psf_name}" != "${this_script_name}" ] && [ "${current_psf_name}" != "${tmp_file_name}" ] ; then
        
                # Load Current Queue Name
                current_queue_name=`"${PSF_parse_script}" "${current_psf}" "${printer_name_search_key}"`
                
                # Load The Current Address
                current_queue_address=`"${PSF_parse_script}" "${current_psf}" "${printer_network_address_search_key}"`
                
                # Replace the Address  - Save to tmp file and then move to replace
                new_network_address="${new_server_address}/${current_queue_name}"
                sed "s_${current_queue_address}_${new_network_address}_" "${current_psf}" > "${tmp_file}" && mv  "${tmp_file}" "${current_psf}" 
        
        fi
        
done


rm -f "${tmp_file_name}"

exit 0

