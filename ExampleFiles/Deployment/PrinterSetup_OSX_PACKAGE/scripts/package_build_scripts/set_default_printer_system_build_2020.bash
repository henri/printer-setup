#!/bin/bash

#
# (C)2009 Henri Shuastak
# Licence GNU GPL
# http://www.lucidsystems.org
#
# version 1.1

# version notes
# This is the new printe_setup_build_script_which will use pkgbuild rather than package maker.
# Requires PrinterSetup v0061 or later

pkgbuild="/usr/bin/pkgbuild"
package_identifier_default="org.lucidsystems.printersetup.default.printers.pkg"
package_version="0.0.3"

num_arguments=$#

build_dest="${1}"

passed_in_package_version="${2}"
passed_in_package_identifier="${3}"

path_to_this_script="${0}"
parent_folder="`dirname \"${path_to_this_script}\"`"
empty_root="${parent_folder}/empty-root"
path_from_root="/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/scripts/package_build_scripts"
printer_setup_root="`echo \"${parent_folder}\"| awk -F \"${path_from_root}\" '{ print $1 }'`"
postinstall_script_path_from_printersetup_root="/ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/set_default_printer/set_default_printer.sh"
postinstall_script_src="${printer_setup_root}${postinstall_script_path_from_printersetup_root}"
postinstall_script_dest="${printer_setup_root}/postinstall"


function setup_empty_root_dir {
	if [ -d "${parent_folder}" ] ; then 
		if ! [ -e "${empty_root}" ] ; then
			mkdir "${empty_root}"
			if [ $? != 0 ] ; then
				echo "ERROR! : Unable to generate empty-root directory!"
				exit -1
			fi
		else
			echo "WARNING! : Empty root directory already exists."
		fi
		number_of_files_within_empty_root=`ls -a -1 "${empty_root}" | wc -l | awk '{print $1}'`
		if [ ${number_of_files_within_empty_root} != 2 ] ; then 
			echo ""
			echo "ERROR! empty root directory is not empty : "
			echo "${empty_root}"
			echo ""
			exit -1
		fi
	else 
		echo "ERROR! : Unable to generate directory empty-root. Parent folder not found!"
		exit -1
	fi
}

function cleanup_empty_root_dir {
	if [ -d "${empty_root}" ] ; then 
		rmdir "${empty_root}"
		if [ $? != 0 ] ; then
			echo "***************************************************"
			echo "ERROR! : Unable to cleanup empty-root directory!"
			echo "         ${empty_root}"
			echo "***************************************************"
		fi
	else
		echo "WARNING! : Unable to locate empty-root for cleanup."
	fi
}

function setup_postinstall_script {
	if [ -e "${postinstall_script_src}" ] ; then
		cp "${postinstall_script_src}" "${postinstall_script_dest}"
		if [ $? == 0 ] ; then
			chmod 755 "${postinstall_script_dest}"
				if ! [ $? == 0 ] ; then
					echo "ERROR! : Unable to make postinstall script executable for package creation!"
					cleanup_empty_root_dir
					exit -1
				fi
		else
			echo "ERROR! : Unable to copy postinstall script to PrinterSetup root for package creation!"
			cleanup_empty_root_dir
			exit -1
		fi
	else
		echo "ERROR! : Unable to locate postinstall script!"
		cleanup_empty_root_dir
		exit -1
	fi
}

function cleanup_postinstall_script {
	if [ -e "${postinstall_script_dest}" ] ; then
		rm "${postinstall_script_dest}"
		if [ $? != 0 ] ; then
			echo "***************************************************"
			echo "ERROR! : Unable to clean up the postinstall script!"
			echo "***************************************************"
			cleanup_empty_root_dir
			exit -1
		fi
	fi
}

setup_empty_root_dir
setup_postinstall_script

if [ "${passed_in_package_identifier}" != "" ] && [ "${passed_in_package_version}" != "" ] && [ $num_arguments -eq 3 ] ; then
	# override the package version and the default package identifier specified within this script
	package_identifier="${passed_in_package_identifier}"
	package_version="${passed_in_package_version}"
	"${pkgbuild}" --root "${empty_root}" --scripts "${printer_setup_root}" --identifier "${package_identifier}" --version "${package_version}" "${build_dest}"
	pkgbuild_result=$?
elif  [ "${passed_in_package_version}" != "" ] && [ $num_arguments -eq 2 ] ; then
	# override the package version
	package_identifier="${package_identifier_default}"
	package_version="${passed_in_package_version}"
	"${pkgbuild}" --root "${empty_root}" --scripts "${printer_setup_root}" --identifier "${package_identifier}" --version "${package_version}" "${build_dest}"
	pkgbuild_result=$?
elif [ $num_arguments -eq 1 ] ; then
	package_identifier="${package_identifier_default}"
	"${pkgbuild}" --root "${empty_root}" --scripts "${printer_setup_root}" --identifier "${package_identifier}" --version "${package_version}" "${build_dest}" 
	pkgbuild_result=$?
elif [ $num_arguments -le 1 ] || [ $num_arguments -ge 5 ] ; then 
	echo "     USAGE : printer_setup_build_2020.bash <build_dest> [package_version]"
	echo "             or"
	echo "             printer_setup_build_2020.bash <build_dest> [<package_version> <package_identifier>]"
	cleanup_postinstall_script
	exit -2
fi


if [ $pkgbuild_result != 0 ] ; then
        echo "    ERROR! : Building Package"
		cleanup_empty_root_dir
		cleanup_postinstall_script
        exit -1
fi

cleanup_empty_root_dir
cleanup_postinstall_script

exit 0

