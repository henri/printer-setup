#!/bin/bash

#
# (C)2009 Henri Shuastak
# Licence GNU GPL
# http://www.lucidsystems.org
#

packagemaker="/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker"
package_identifier="org.lucidsystems.printersetup.printers.pkg"

build_file="${1}"
build_dest="${2}"


"${packagemaker}" -i ${package_identifier} -d "${build_file}" -o "${build_dest}" 

if [ $? != 0 ] ; then
        echo "ERROR! : Building Package"
        exit -1
fi


exit 0

