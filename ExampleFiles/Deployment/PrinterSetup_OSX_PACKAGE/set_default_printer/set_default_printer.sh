#!/bin/bash

# (C)2007 Henri Shustak
# GNU GPL
# Lucid Information Systems
# http://www.lucidsystems.org

# This is the script which is run when you install the related package.
# It is designed to set the default printer.

# Version 0.2

# Version history
# 0.1  - testubg
# 0.2  - initial release

## This is helpful for if you modify this script and need help debugging.
#echo $0 >> /tmp.txt
#ls -l >> /tmp.txt
#echo "" >> /tmp.txt




# setup some enviroment varibles (this aspect may all be moved into printer setup with a flag in the future).
export printer_setup_folder=`dirname "${0}"`

export printer_setup_utilities_folder="${printer_setup_folder}/PrinterSetupUtilities"
export psf_search_keys_conf_file="${printer_setup_utilities_folder}""/PSF_SearchKeys_MacOS_104.config"
export printer_setup_log="/dev/null"
export psf_parsing_utility="${printer_setup_utilities_folder}/ParsePSF.sh"
export user_to_set_default_printer_for="none"
export setting_default_user_printer="OFF"
export setting_default_machine_printer="ON"
export default_printer_has_PSF="YES"
export printer_prefixing="NO"
# export printer_name_prefix="${printer_name_prefix}"
# export printer_name_prefix_delimiter="${printer_name_prefix_delimiter}"
# export printer_description_prefix="${printer_description_prefix}"
# export printer_description_prefix_delimiter="${printer_description_prefix_delimiter}"
# export printer_name_prefix="${printer_name_prefix}"
# export printer_name_prefix_delimiter="${printer_name_prefix_delimiter}"

# Change into the scripts root directory (PrinterSetup root).
cd "${printer_setup_folder}"

# Find the PSF which will be used to set to setup the default printer (realitive to PrinterSetup root).
default_printer_setup_dir="ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/set_default_printer/PSF_default_printer_directory"
default_printer_setup_file=`for psf in "${default_printer_setup_dir}"/* ; do echo $psf ; break ; done`

# printer setup script path and name (realitive to PrinterSetup root)
set_default_printer_script="${printer_setup_utilities_folder}/SetDefaultPrinter_MacOS_104.sh"

# Set the default printer
"${set_default_printer_script}" "${default_printer_setup_file}"


exit 0

