#!/usr/bin/env bash
#
# GNU GPL Copyright Henri Shustak 2011
# 
# Lucid Information Systems
# http://www.lucidsystems.org
#
# Given an output directory take the printer list files
# and build Apple package installers and also generate 
# images (.dmg files) to contain these for distribution.
#
# This script will require PrinterSetup PrinterSetup_v0054 or later.
#
# Version 1.0
# 
# Version History 
#   - 1.0 : initial release.
#   - 1.1 : bug fixes
#
#
# Create installer packges and disk imsages for all the PLF files within the realitive PrinterSetup directory.
# Keep in mind that this script will not work if you have a hirarchy of PLF files.
#
#

### Gather input arguments
path_to_this_script="${0}"
output_directory="${1}"
num_arguments=$#


### Gather input enviroment varibles

# Leave this set to no, unless you want to overwrite old packages (YES/NO)
default_overwrite_existing_packages="NO"

# Leave this set to no, unless you want to overwrite old images (YES/NO)
default_overwrite_existing_images="NO"

# Leave this unless you would like to see errors for skipped packages (YES/NO)
default_report_skipped_packages="NO"

# Leave this unless you would like to be able to have .pkg files within your input directory (YES/NO)
default_allow_pkg_files_within_input_directory="NO"

# Leave this alone unless you would like a warning each time a package is overwritten 
default_display_warning_on_package_overwriting_for_each_pacakge="NO"

# Leave this alone unless you would not like a warning when you are overwritting packages
default_display_warning_on_package_overwirting_for_processing_of_plfs_within_directory="YES"


### internal varibles
parent_folder="`dirname \"${path_to_this_script}\"`"
path_from_root="/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts"
printer_setup_root="`echo \"${parent_folder}\"| awk -F \"${path_from_root}\" '{ print $1 }'`"
path_to_generate_packages_script="${printer_setup_root}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts/generate-packages-for-printer-setup-files-within-a-directory.bash"
path_to_generate_images_script="${printer_setup_root}/ExampleFiles/Handy Scripts/sh-generate-image-for-apple-package.bash"
path_to_plf_directory="${printer_setup_root}/PrinterLists"
input_plf_dir="${path_to_plf_directory}"


### output directories
output_packages_dir="${output_directory}/pacakges"
output_images_dir="${output_directory}/images"


### valadation

# If this is not overridden then leave it alone.
if [ "${overwrite_existing_packages}" == "" ] ; then
    # validate the current setting 
    overwrite_existing_packages="${default_overwrite_existing_packages}"
fi
export overwrite_existing_packages

# Validate overwrite_existing_packages varible
if [ "${overwrite_existing_packages}" != "YES" ] && [ "${overwrite_existing_packages}" != "NO" ] ; then
    echo "     ERROR! : The overwrite_existing_packages variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi

# If this is not overridden then leave it alone.
if [ "${report_skipped_packages}" == "" ] ; then
    # validate the current setting 
    report_skipped_packages="${default_report_skipped_packages}"
fi
export report_skipped_packages

# Validate report_skipped_packages variable
if [ "${report_skipped_packages}" != "YES" ] && [ "${report_skipped_packages}" != "NO" ] ; then
    echo "     ERROR! : The report_skipped_packages variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi

# data input validation
# If this is not overridden then leave it alone.
if [ "${allow_pkg_files_within_input_directory}" == "" ] ; then
    # validate the current setting 
    allow_pkg_files_within_input_directory="${default_allow_pkg_files_within_input_directory}"
fi

# Validate allow_pkg_files_within_input_directory variable
if [ "${allow_pkg_files_within_input_directory}" != "YES" ] && [ "${allow_pkg_files_within_input_directory}" != "NO" ] ; then
    echo "     ERROR! : The allow_pkg_files_within_input_directory variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi

# If this is not overridden then leave it alone.
if [ "${display_warning_on_package_overwriting_for_each_pacakge}" == "" ] ; then
    # validate the current setting 
    display_warning_on_package_overwriting_for_each_pacakge="${default_display_warning_on_package_overwriting_for_each_pacakge}"
fi
export display_warning_on_package_overwriting_for_each_pacakge

# Validate display_warning_on_package_overwriting_for_each_pacakge variable
if [ "${display_warning_on_package_overwriting_for_each_pacakge}" != "YES" ] && [ "${display_warning_on_package_overwriting_for_each_pacakge}" != "NO" ] ; then
    echo "     ERROR! : The display_warning_on_package_overwriting_for_each_pacakge variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi

# If this is not overridden then leave it alone.
if [ "${display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}" == "" ] ; then
    # validate the current setting 
    display_warning_on_package_overwirting_for_processing_of_plfs_within_directory="${default_display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}"
fi
export display_warning_on_package_overwriting_for_each_pacakge

# Validate display_warning_on_package_overwirting_for_processing_of_plfs_within_directory variable
if [ "${display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}" != "YES" ] && [ "${display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}" != "NO" ] ; then
    echo "     ERROR! : The display_warning_on_package_overwirting_for_processing_of_plfs_within_directory variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi

# If this is not overridden then leave it alone.
if [ "${display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}" == "" ] ; then
    # validate the current setting 
    display_warning_on_package_overwirting_for_processing_of_plfs_within_directory="${default_display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}"
fi
export display_warning_on_package_overwriting_for_each_pacakge

# Validate display_warning_on_package_overwirting_for_processing_of_plfs_within_directory variable
if [ "${display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}" != "YES" ] && [ "${display_warning_on_package_overwirting_for_processing_of_plfs_within_directory}" != "NO" ] ; then
    echo "     ERROR! : The display_warning_on_package_overwirting_for_processing_of_plfs_within_directory variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi


# If this is not overridden then leave it alone.
if [ "${overwrite_existing_images}" == "" ] ; then
    # validate the current setting 
    overwrite_existing_images="${default_overwrite_existing_images}"
fi
export overwrite_existing_images

# Validate overwrite_existing_images variable
if [ "${overwrite_existing_images}" != "YES" ] && [ "${overwrite_existing_images}" != "NO" ] ; then
    echo "     ERROR! : The overwrite_existing_images variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi




### Checking the arguments
if [ $num_arguments -ne 1 ] ; then
        echo "    Usage : $0 <output_directory>"
        exit -1
fi

# Create the output directory structure (if required)
if [ -d "${output_directory}" ] ; then
	mkdir -p "${output_packages_dir}" "${output_images_dir}"
	if [ $? != 0 ] ; then
		echo "     ERROR! : Generating output directory structure."
		echo "              ${output_directory}"
		exit -1
	fi
else
	echo "     ERROR! : Unable to locate output directory"
	echo "              ${output_directory}"
	exit -1
fi



### Build some print queue installer packages
"${path_to_generate_packages_script}" "${input_plf_dir}" "${output_packages_dir}"
if [ $? != 0 ] ; then
	echo ""
	echo "     ERROR! : During generation of print queue creation packages :"
	echo "              ${output_directory}"
	echo ""
	exit -1

fi


### Create image files for these recently generated packages (creating printer lists install packages)
"${path_to_generate_images_script}" "${output_packages_create_printers_dir}" "${output_images_dir}"
if [ $? != 0 ] ; then
	echo ""
	echo "     ERROR! : During generation of images which create CUPS print queues :"
	echo "              ${output_directory}"
	echo ""
	exit -1

fi




exit 0




