#!/bin/bash
#
# GNU GPL Copyright Henri Shustak 2011
# 
# Lucid Information Systems
# http://www.lucidsystems.org
#
# Generates an apple package installer for the printer setup file passed in as argument number one.
# The apple package is generated within the directory passed in as argument number two.
#
# This script is based of the PrinterSetupGenerateOSXPackageForEachPSF v0.1e script.
# It is possible that a future version of the Apple Script could be updated to make use of this script.
#
# This script will require PrinterSetup PrinterSetup_v0041 or later.
#
#
# Version 1.5
# 
# Version History 
#   - 1.0 : initial release
#   - 1.1 : added ability to use an environment variable to overwrite packages from external script.
#   - 1.2 : added features to facilitate processing a directory via a wrapper script.
#   - 1.3 : added features to facilitate building of the default queue setting packages.
#   - 1.4 : bug fixes relating to overwirtting varible settings.
#   - 1.5 : added support for package identifier and version to be based upon build time and the name of the PSF
#   - 1.6 : resolved bug relating to paths not being switched back for ralitive builds.
#   - 1.7 2020 build script enabled

# Notes : Perhaps a using an option flag is a better approach for enabling overwriting of packages?

# Configuration

# Leave this set to no, unless you want to overwrite old packages (YES/NO)
default_overwrite_existing_packages="NO"

# Leave this set to yes, unless you want no report that a package was skipped (YES/NO)
default_report_skipped_packages="YES"

# Leave this set to no, unless you want to report that a package was overwritten (YES/NO)
default_display_warning_on_package_overwriting_for_each_pacakge="NO"

# Leave this set to no, unless you want to build a package to set the defualt printer on a system rather than create the queue (YES/NO)
default_build_default_printer_installers_not_printer_creation_installers="NO"

# Leave this set to no, unless you want to build a package with the identifer set to the name of the PSF or PLF (YES/NO)
default_use_psf_or_plf_as_package_identifier="NO"


# Gather input arguments
path_to_this_script="${0}"
input_printer_setup_file="${1}"
output_directory="${2}"
num_arguments=$#

# internal varibles
num_packages_skipped=0
packages_created=0
printer_setup_files_processed=0
package_creation_errors=0
parent_folder="`dirname \"${path_to_this_script}\"`"
path_from_root="/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts"
printer_setup_root="`echo \"${parent_folder}\"| awk -F \"${path_from_root}\" '{ print $1 }'`"
room_number="OSXPACKAGE"
buildscript_create_package="${printer_setup_root}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts/printer_setup_build_2020.bash"
buildscript_default_package="${printer_setup_root}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts/set_default_printer_system_build_2020.bash"
package_maker_document_create_pacakge="${printer_setup_root}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/PrinterSetup.pmdoc"
package_maker_document_default_pacakge="${printer_setup_root}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/set_default_printer/set_default_printer.pmdoc"
PrinterSetupLinks_Path="${printer_setup_root}/PrinterSetupLinks"
setupPrinter_link_name="PSF-${room_number}-PrinterDroplet4Package-ForEachPSF"
setupPrinter="${PrinterSetupLinks_Path}/${setupPrinter_link_name}"
PrinterSetupLinks_Default_PSF_Directory_Path="${printer_setup_root}/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/set_default_printer/PSF_default_printer_directory"
default_PSF="${PrinterSetupLinks_Default_PSF_Directory_Path}/PSF-${room_number}-PrinterDroplet4Package-ForEachPSF-DefaultSystemQueue"
printer_setup_script="${printer_setup_root}/PrinterSetup.sh"
printersetup_root_path_detction_string_for_printer_setup_files="/PrinterSetupFiles/"
printersetup_printer_setup_files_realiitive_link_path="../PrinterSetupFiles/"
build_version_based_upon_build_time=`date "+%s"`
initial_path="`pwd`"

# Function(s)

function remove_tmporary_link {
	# Remove the temporarily created link created by this script (or the one which may exist prior to this script being run)
	if [ -h "${setupPrinter}" ] ; then 
		rm "${setupPrinter}"
		if [ $? != 0 ] ; then
			echo "    ERROR! Removing the temporary link created for package creation."
			exit -1
		fi
	fi
}


function remove_default_psf {
	# Remove the temporarily created link created by this script (or the one which may exist prior to this script being run)
	if [ -e "${default_PSF}" ] ; then 
		rm "${default_PSF}"
		if [ $? != 0 ] ; then
			echo "    ERROR! Removing the PSF file, used for building a package which will set the default print queue."
			exit -1
		fi
	fi
}


function check_if_output_pakage_already_exists_within_output_directory {

	# Check if package already exists within the output directory
	if [ -e "${output_package}" ] ; then
		if [ "${overwrite_existing_packages}" == "NO" ] ; then
			# The existing package will not be overwritten
			if [ "${report_skipped_packages}" == "YES" ] ; then
				echo "    WARNING : Install package already exists in output directory."
					echo "    Package creation for \"${psf_name}.pkg\" has been skipped."
			fi
			exit 2
		else
			# Remove the existing package from the output directory
			sleep 1
			rm -rf "${output_package}"
			if [ $? != 0 ] ; then
				echo "     ERROR! : Removing existing package : \"${output_package}\""
				echo "              Package generation for this PSF has been skipped."
				exit -1
			fi
		fi
	fi

}


# Validation
# If this is not overridden then leave it alone.
if [ "${overwrite_existing_packages}" == "" ] ; then
    # validate the current setting 
    overwrite_existing_packages="${default_overwrite_existing_packages}"
fi

# Validate overwrite_existing_packages variable
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


# Validate report_skipped_packages variable
if [ "${report_skipped_packages}" != "YES" ] && [ "${report_skipped_packages}" != "NO" ] ; then
    echo "     ERROR! : The report_skipped_packages variable is not valid. It must be set to \"YES\" or \"NO\"."
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

# Validate report_skipped_packages variable
if [ "${display_warning_on_package_overwriting_for_each_pacakge}" != "YES" ] && [ "${display_warning_on_package_overwriting_for_each_pacakge}" != "NO" ] ; then
    echo "     ERROR! : The display_warning_on_package_overwriting_for_each_pacakge variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi


# If this is not overridden then leave it alone.
if [ "${build_default_printer_installers_not_printer_creation_installers}" == "" ] ; then
    # validate the current setting 
    build_default_printer_installers_not_printer_creation_installers="${default_build_default_printer_installers_not_printer_creation_installers}"
fi

# Validate build_default_printer_installers_not_printer_creation_installers variable
if [ "${build_default_printer_installers_not_printer_creation_installers}" != "YES" ] && [ "${build_default_printer_installers_not_printer_creation_installers}" != "NO" ] ; then
    echo "     ERROR! : The build_default_printer_installers_not_printer_creation_installers variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi


# If this is not overridden then leave it alone
if [ "${use_psf_or_plf_as_package_identifier}" == "" ] ; then
    # validate the current setting 
    use_psf_or_plf_as_package_identifier="${default_use_psf_or_plf_as_package_identifier}"
fi

# Valadate that there is a build version based upon time specified if we are using the psf or plf as the package identifer during the build.
if [ "${use_psf_or_plf_as_package_identifier}" == "YES" ] ; then
	if [ "$build_version_based_upon_build_time" != "" ] ; then
		if [ "`echo "${build_version_based_upon_build_time}" | tr -d '[:digit:]'`" ] ; then
			echo "    ERROR! : Build version based upon time is not set correctly."
			exit -1
		fi
	else
		echo "    ERROR! : Build version based upon time is not set correctly."
		exit -1
	fi
fi

# Report that files will be overwritten
if [ "${overwrite_existing_packages}" == "YES" ] && [ "${display_warning_on_package_overwirting_for_each_pacakge}" == "YES" ]; then
    echo "     NOTE! : Overwriting of existing packages found within the output directory is enabled."
    sleep 3
fi


# Checking the arguments
if [ $num_arguments -ne 2 ] ; then
        echo "    Usage : $0 <path_to_printer_setup_file> <output_directory_for_package>" #  [path_to_printer_setup_file]
        exit -1
fi

# Checking the input file
if ! [ -e "${input_printer_setup_file}" ] ; then 
	echo "ERROR! : Unable to locate input printer-setup-file : $input_printer_setup_file"
	exit -1
fi

# Checking the output directory
if ! [ -d "${output_directory}" ] ; then 
	echo "ERROR! : Unable to locate output directory : $output_directory"
	exit -1
fi


# Check the printer_setup_root directory exists.
if ! [ -d "${printer_setup_root}" ] ; then 
	echo "    ERROR! : Unable to locate the PrinterSetup root directory at the following path :"
	echo "             ${printer_setup_root}"
       exit -1
fi

# correct any trailing slashes in the output directory
output_directory="`dirname \"${output_directory}\"`/`basename \"${output_directory}\"`"

if [ "${build_default_printer_installers_not_printer_creation_installers}" == "NO" ] ; then

	# Do something useful like make a printer queue setup package. 

	package_maker_document="${package_maker_document_create_pacakge}"
	buildscript="${buildscript_create_package}"

	psf_name="`basename \"${input_printer_setup_file}\"`"
	output_package="${output_directory}/${psf_name}.pkg"

	check_if_output_pakage_already_exists_within_output_directory
	
	# Delete any link which may already exit. The sync commands may improve reliability
	# Note : There is a function specified below which this could be migrated to at some point in the future
	sync
	sleep 1
	rm -f "${setupPrinter}"
	if [ $? != 0 ] ; then
		echo "    ERROR!: Unable to remove the existing PSF package link :"
		echo "            ${setupPrinter}"
		exit -1
	fi
	sync


	# Calculate the relative link to the printer setup file
	printer_setup_realitive_link_from_printersetupfiles_directory="`echo \"${input_printer_setup_file}\" | awk -F \"${printersetup_root_path_detction_string_for_printer_setup_files}\" '{print $2 }'`"
	printer_setup_realitive_link="${printersetup_printer_setup_files_realiitive_link_path}${printer_setup_realitive_link_from_printersetupfiles_directory}"


	# Prepare to create the relative link to the printer setup file
	cd "${PrinterSetupLinks_Path}"
	if [ $? != 0 ] ; then
		echo "    ERROR!: Preparing for creation of the PSF package link."
		exit 2
	fi

	# Create the relative link to the printer setup file
	ln -s "${printer_setup_realitive_link}" "./${setupPrinter_link_name}"
	if [ $? != 0 ] ; then
		echo "    ERROR!: Unable to create the relative PSF package link."
		exit -1
	fi
	
	# Change back to initial direcotry
	cd "${initial_path}"
	if [ $? != 0 ] ; then
		echo "    ERROR!: Unable to switch back to initial path within script ${0}."
		exit -1
	fi

	# Create the package
	
	if [ "${use_psf_or_plf_as_package_identifier}" == "NO" ] ; then
		# use the build script to determin the build version and package identifer

		# Pre-2020-Build
		#"${buildscript}" "${package_maker_document}" "${output_package}"
		# Post 2020 Build
		"${buildscript}" "${output_package}"
		build_status=$?
	else
		# calculate package identifer based upon PSF name
		
		# specify prefix and suffex for the package identifier
		package_identifier_prefix="org.lucidsystems.printersetup.psf"
		package_identifier_suffix="pkg"
		# remove or replace various characters from the psf name for use in the package identifier
		stripped_psf_name=`echo "${psf_name}" | tr " " "_" | tr "-" "_"`
		# construct a package identifier
		package_identifier="${package_identifier_prefix}.${stripped_psf_name}.${package_identifier_suffix}"
		
		#build the package
		# Pre-2020-Build
		#"${buildscript}" "${package_maker_document}" "${output_package}" "${build_version_based_upon_build_time}" "${package_identifier}"
		"${buildscript}" "${output_package}" "${build_version_based_upon_build_time}" "${package_identifier}"
		build_status=$?
	fi

	if [ ${build_status} != 0 ] ; then
		remove_tmporary_link
		echo "    ERROR! Building Package. Package building canceled."
		exit -1
	else
		remove_tmporary_link
	fi

else

	# Do something useful like make a default printer queue setup package. 

	package_maker_document="${package_maker_document_default_pacakge}"
	buildscript="${buildscript_default_package}"

	psf_name="`basename \"${input_printer_setup_file}\"`"
	output_package="${output_directory}/${psf_name}_default.pkg"

	check_if_output_pakage_already_exists_within_output_directory

	# Delete any default PSF which may already exit. The sync commands may improve reliability
	# Note : There is a function specified below which this could be migrated to at some point in the future
	sync
	sleep 1
	rm -f "${default_PSF}"
	if [ $? != 0 ] ; then
		echo "    ERROR!: Unable to remove the existing default PSF used for building a default package :"
		echo "            ${default_PSF}"
		exit -1
	fi
	sync

	# Copy the default PSF to the appropriate directory
	cp "${input_printer_setup_file}" "${default_PSF}"
	if [ $? != 0 ] ; then
		echo "    ERROR!: Unable to copy the PSF to the appriate directory in preperation for bidling a package which will set this as the default print queue."
		echo "            ${input_printer_setup_file}"
		exit -1
	fi
	

	# Create the package
	if [ "${use_psf_or_plf_as_package_identifier}" == "NO" ] ; then
		# use the build script to determin the build version and package identifer
		# Pre 2020 
		#"${buildscript}" "${package_maker_document}" "${output_package}"
		# Post 2020
		"${buildscript}" "${output_package}"
		build_status=$?
	else
		# calculate package identifer based upon PSF name
		
		# specify prefix and suffex for the package identifier
		package_identifier_prefix="org.lucidsystems.printersetup.psf"
		package_identifier_suffix="defaultprinter.pkg"
		# remove or replace various characters from the psf name for use in the package identifier
		stripped_psf_name=`echo "${psf_name}" | tr " " "_" | tr "-" "_"`
		# construct a package identifier
		package_identifier="${package_identifier_prefix}.${stripped_psf_name}.${package_identifier_suffix}"
		
		#build the package
		# Pre 2020 
		#"${buildscript}" "${package_maker_document}" "${output_package}" "${build_version_based_upon_build_time}" "${package_identifier}"
		# Post 2020
		"${buildscript}" "${output_package}" "${build_version_based_upon_build_time}" "${package_identifier}"
		build_status=$?
	fi


	if [ ${build_status} != 0 ] ; then
		remove_default_psf
		echo "    ERROR! Building Default Package. Package building canceled."
		exit -1
	else
		remove_default_psf
	fi
	
fi



exit 0 
 






