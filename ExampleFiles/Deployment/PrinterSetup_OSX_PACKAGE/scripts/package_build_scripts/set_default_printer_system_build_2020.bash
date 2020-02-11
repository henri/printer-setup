#!/bin/bash

#
# (C)2009 Henri Shuastak
# Licence GNU GPL
# http://www.lucidsystems.org
#
# version 1.0

pkgbuild="/usr/bin/pkgbuild"
package_identifier_default="org.lucidsystems.printersetup.printers.pkg"
package_version="0.0.3"

build_dest="${1}"


"${pkgbuild}" --identifier ${package_identifier} --version "${package_version}" "${build_dest}" 

if [ $? != 0 ] ; then
        echo "ERROR! : Building Package"
        exit -1
fi


exit 0

