#!/usr/bin/env bash
#
# Generate the packages and images
# This script is part of PrinterSetup
#
# It is assumed that this script will be located in the same parent directory as PrinterSetup
# However, this may be altered if you make some minor alterations to ths script or its varibles.
#
# Licence : GNU GPL 3 or later
#
# Version History 
# v1.0 - inital release

exit_value=0

# Options to pass via enviroment varibles
export overwrite_existing_packages="NO"
export overwrite_existing_images="NO"

# Name of PrinterSetup directory - assuming it shares the same parent directory as this script.
# EG : printer_setup_direcory_name="printer-setup"
printer_setup_direcory_name="PrinterSetup_v0049"

# Name of the output directory for packages and images- assuming it shares the same parent directory as this script.
output_directory_name="packages_and_images"

current_directory=`dirname "${0}"`
# Test the directory is okay.
cd "${current_directory}"
if [ $? != 0 ] ; then
	echo ""
	echo " ERROR! : Unable to move \"cd\" to the parent directory of this script."
	echo ""
	exit -1
fi

generating_packages_and_images_script="${current_directory}/${printer_setup_direcory_name}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts/generate_psf_packages_and_images.bash"
output_directory_for_images_and_packages="${current_directory}/${output_directory_name}"
"${generating_packages_and_images_script}" "${output_directory_for_images_and_packages}"

exit_value=$?

if [ $exit_value != 0 ] ; then
	echo ""
	echo " ERROR! : Setup encountered problems."
	echo ""
	exit -1
else
	echo ""
	echo " Setup has completed. Hopefully without any issues."
	echo ""
	exit 0
fi



