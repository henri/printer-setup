#!/bin/bash

# GNU GPL Copyright Henri Shustak 2011
# 
# Lucid Information Systems
# http://www.lucidsystems.org
#
# Given an input directory provided as argument number 1 containing only PSF files process 
# all these generate packages within the output directory provided as argument number 2
#
# This script will require PrinterSetup PrinterSetup_v0053 or later.
#
#
# Version 1.0
# 
# Version History 
#   - 1.0 : initial release

# Configuration 

# Leave this set to no, unless you want to overwrite old packages (YES/NO)
default_overwrite_existing_packages="NO"

# Leave this unless you would like to see errors for skipped packages (YES/NO)
default_report_skipped_packages="NO"

# Leave this unless you would like to be able to have .pkg files within your input directory (YES/NO)
default_allow_pkg_files_within_input_directory="NO"

# Leave this alone unless you would like a warning each time a package is overwritten 
default_display_warning_on_package_overwriting_for_each_pacakge="NO"

# Leave this alone unless you would not like a warning when you are overwritting packages
default_display_warning_on_package_overwirting_for_processing_of_psfs_within_directory="YES"


# Note : There are various reasons for not using 'shift' in order to process multiple files passed in from the command line.


# Gather input arguments
path_to_this_script="${0}"
input_psf_dir="${1}"
output_dir="${2}"
num_arguments=$#


# internal varibles
current_psf=""
current_psf_name=""
exit_value=0
packages_successfully_generated=0
pacakges_skipped=0
input_files_processed=0
processing_errors=0
parent_folder="`dirname \"${path_to_this_script}\"`"
path_from_root="/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts"
printer_setup_root="`echo \"${parent_folder}\"| awk -F \"${path_from_root}\" '{ print $1 }'`"
path_to_build_script="${printer_setup_root}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts/generate-package-for-printer-setup-file.bash"

# functions(s)

function make_package_for_current_psf {
	echo -n "building package for ${current_psf_name}..."
	"${path_to_build_script}" "${current_psf}" "${output_dir}"
	build_pacakge_return=$?
	if [ ${build_pacakge_return} != 0 ] ; then
		if [ ${build_pacakge_return} == 2 ] ; then
			# package already exits and we are not overwriting
			echo "already exits - skipped package creation"
			return 2
		else
			echo "failed"
			return 1
		fi
	fi
	echo "done"
	return 0
}


# Checking the arguments
if [ $num_arguments -ne 2 ] ; then
        echo "    Usage : $0 <path_to_directory_only_containing_printer_setup_file> <output_directory_for_packages>"
        exit -1
fi


# Checking the output directory
if ! [ -d "${output_dir}" ] ; then 
	echo "ERROR! : Unable to locate the specified output directory : $output_dir"
	exit -1
fi

# Checking the input directory
if ! [ -d "${input_psf_dir}" ] ; then 
	echo "ERROR! : Unable to locate the specified input directory : $input_psf_dir"
	exit -1
fi

# Check the printer_setup_root directory exists.
if ! [ -d "${printer_setup_root}" ] ; then 
	echo "    ERROR! : Unable to locate the PrinterSetup root directory at the following path :"
	echo "             ${printer_setup_root}"
       exit -1
fi

# correct any trailing slashes in the output directory
output_dir="`dirname \"${output_dir}\"`/`basename \"${output_dir}\"`"


# Validation
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

# Validate report_skipped_packages variable
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

# Validate report_skipped_packages variable
if [ "${display_warning_on_package_overwriting_for_each_pacakge}" != "YES" ] && [ "${display_warning_on_package_overwriting_for_each_pacakge}" != "NO" ] ; then
    echo "     ERROR! : The display_warning_on_package_overwriting_for_each_pacakge variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi

# If this is not overridden then leave it alone.
if [ "${display_warning_on_package_overwirting_for_processing_of_psfs_within_directory}" == "" ] ; then
    # validate the current setting 
    display_warning_on_package_overwirting_for_processing_of_psfs_within_directory="${default_display_warning_on_package_overwirting_for_processing_of_psfs_within_directory}"
fi
export display_warning_on_package_overwriting_for_each_pacakge

# Validate report_skipped_packages variable
if [ "${display_warning_on_package_overwirting_for_processing_of_psfs_within_directory}" != "YES" ] && [ "${display_warning_on_package_overwirting_for_processing_of_psfs_within_directory}" != "NO" ] ; then
    echo "     ERROR! : The display_warning_on_package_overwirting_for_processing_of_psfs_within_directory variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi

# Report that files will be overwritten
if [ "${overwrite_existing_packages}" == "YES" ] && [ "${display_warning_on_package_overwirting_for_processing_of_psfs_within_directory}" == "YES" ]; then
	echo ""
    echo "     NOTE! : Overwriting of existing packages found within the output directory is enabled."
	echo ""
    sleep 3
fi


# check input directory for any .pkg files. If.pkg files are found then exit as this may not be the correct input directory.
if [ "${allow_pkg_files_within_input_directory}" == "NO" ] ; then
	number_of_packages_within_the_input_directory=`ls -l "${input_psf_dir}/"*.pkg 2>> /dev/null | wc -l | awk '{print $1}'`
	if [ $number_of_packages_within_the_input_directory -gt 0 ] ; then
		echo "    ERROR! : Package files (.pkg) were detected within the output directory."
		echo "             Please check that the output directory is listed as the second argument"
		echo "             and that there are no .pkg files within this directory."
	fi
fi



# process the input directory

for item in "${input_psf_dir}/"*; do
                
	current_psf="$item"
        current_psf_name=`basename "$current_psf"`	
	
        if [ -s "${current_psf}" ]; then

        	((input_files_processed++))

			#output_package_path="${output_dir}/${current_psf_name}.pkg"
			

        	# process the psf
        	make_package_for_current_psf
                    
		# Check that worked
        	exit_value=$?
        	if [ $exit_value == 0 ]; then
			((packages_successfully_generated++))
		else
			if [ $exit_value != 2 ]; then
				((processing_errors++))				
			else
				((pacakges_skipped ++))
			fi
		fi
        fi        
done

# Print a summary 
echo ""
echo ""
echo "Summary : "
echo "======================================================== "
echo "Number of processed input files                    : $input_files_processed"
echo "Number of packages generated successfully          : $packages_successfully_generated"
echo "Number of packages skilled                         : $pacakges_skipped"
echo "Number of processing errors                        : $processing_errors"
echo ""
echo ""

exit 0 

 






