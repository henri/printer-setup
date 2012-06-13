#!/bin/bash

#
# (C)2009 Henri Shuastak
# Licence GNU GPL
# http://www.lucidsystems.org
#
# version 3.0

packagemaker="/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker"
package_identifier="org.lucidsystems.printersetup.defaultprinter.pkg"

num_arguments=$#

build_file="${1}"
build_dest="${2}"

passed_in_package_version="${3}"
passed_in_package_identifier="${4}"

# build the package using the appropriate arguments as supplied. Different versions / uses of printer setup may supply different numbers of arguments. 
if [ "${passed_in_package_identifier}" != "" ] && [ "${passed_in_package_version}" != "" ] && [ $num_arguments -eq 4 ] ; then
	# override the package version and the default package identifier specified within this script
	package_identifier="${passed_in_package_identifier}"
	package_version="${passed_in_package_version}"
	"${packagemaker}" -i ${package_identifier} -d "${build_file}" -o "${build_dest}" -n "${package_version}"
	package_maker_result=$?
elif  [ "${passed_in_package_version}" != "" ] && [ $num_arguments -eq 3 ] ; then
	# override the package version
	package_identifier="${package_identifier_default}"
	package_version="${passed_in_package_version}"
	"${packagemaker}" -i ${package_identifier} -d "${build_file}" -o "${build_dest}" -n "${package_version}"
	package_maker_result=$?
elif [ $num_arguments -eq 2 ] ; then
	package_identifier="${package_identifier_default}"
	"${packagemaker}" -i ${package_identifier} -d "${build_file}" -o "${build_dest}" 
	package_maker_result=$?
elif [ $num_arguments -le 1 ] || [ $num_arguments -ge 5 ] ; then 
	echo "     USAGE : set_default_printer_system_build.bash <build_file> <build_dest> [package_version]"
	echo "             or"
	echo "             set_default_printer_system_build.bash <build_file> <build_dest> [<package_version> <package_identifier>]"
	exit -2
fi

if [ $package_maker_result != 0 ] ; then
        echo "    ERROR! : Building Package"
        exit -1
fi

exit 0

