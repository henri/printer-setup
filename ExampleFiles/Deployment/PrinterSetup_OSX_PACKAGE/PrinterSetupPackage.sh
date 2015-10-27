#!/bin/bash

# (C)2007 Henri Shustak
# GNU GPL
# Lucid Information Systems
# http://www.lucidsystems.org

# This script is the script which is run when you build a package.
# Simply change this as required for your needs.

# Version 0.9

## This is helpful for if you modify this script and need help debugging.
#echo $0 >> /tmp.txt
#ls -l >> /tmp.txt
#echo "" >> /tmp.txt


# Change into the Scripts Root Directory
printersetup_root=`dirname "${0}"`
cd "${printersetup_root}"


########
########   Configurartion
########

# Set the prefix.
# If this is set then some additional options will be added. Do not put any spaces in this prefix.
# Adding a prefix will also set the "-x" option. This will remove disabled queues with the same queue name prefix.
package_queue_name_prefix=""

# Remove any printers with this prefix (only enable for debugging : un-comment the lines below to remove printers with prefix)
# printer_setup_remove_prefix_printers_script="./ExampleFiles/Handy Scripts/sh-remove-printers-with-name-prefix.bash"
# sudo bash "$printer_setup_remove_prefix_printers_script" "$package_queue_name_prefix"

# options passed to printer setup
printer_setup_options="-a OSXPACKAGE -p NO"

# printer setup script path and name (from root of printer setup directory)
printer_setup_script="./PrinterSetup.sh"

# path to the helper packages and additional packages direcotrys (no trailing slash)
helper_packages_directory="./ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/helper_packages"
additional_packags_directory="./ExampleFiles/Deployment/PrinterSetup_OSX_PACKAGE/additional_packages"


########
########   Internal Varibles
########

# Darwin version numbers
darwin_major_version=`uname -v | awk '{print $4}' | awk -F "." '{print $1}'`
darwin_minor_version=`uname -v | awk '{print $4}' | awk -F "." '{print $2}'`

# Path to InstallPKG
installpkg_location="${helper_packages_directory}/InstallPKG.pkg"

# Path to the InstallPKG receipit
if [ ${darwin_major_version} -ge 10 ] ; then
    # running 10.6 or later
    installpkg_receipt="/var/db/receipts/org.lucidsystems.installpkg.plist"
else
    # running 10.5 or earlier
    installpkg_receipt="/Library/Receipts/InstallPKG.pkg/"
fi

installpkg_default_osx_install_path="/usr/local/bin/installpkg"

# Path to Uninstall InstallPKG script
uninstall_installpkg_location="${helper_packages_directory}/InstallPKG-Uninstall.bash"

# Is the InstallPKG installed currenlty
installpkg_installed="NO"

# Was InstallPKG installed before we started
installpkg_previously_insalled="NO"



########
########   Deal with any prefixs which have been added
########

if [ "${package_queue_name_prefix}" != "" ] ; then

    # Add the queue name prefix and the remove queues with this prefix option
    printer_setup_options="${printer_setup_options} -x -n ${package_queue_name_prefix}"

fi


########
########   Preflight Check
########


# Check we are running as root
currentUser=`whoami`
if [ $currentUser != "root" ] ; then
    echo This script must be run with super user privileges.
    logger -s -t PrinterSetupOSXPackage -p user.error "ERROR! : Insificient priviliges."
    exit -1
fi

########
########   Install any additional packages
########

# Check to see if there are any additional packages which we should be installing.

additional_packages=`ls "${additional_packags_directory}/" | grep pkg`
if [ "${additional_packages}" != "" ] ; then
    # There are some additional packags to install, lets get to it.
    
    # Check to see if InstallPKG is already installed
    if [ -f "${installpkg_default_osx_install_path}" ] ; then
        installpkg_installed="YES"
        installpkg_previously_insalled="YES"
    else
        # Install the InstallPKG tool if it is availible
        # InstallPKG is a wrapper to the Apple installer command. It is used to install the other packckages.
        if [ -d "${installpkg_location}" ] ; then
            # Instll InstallPKG onto the root directory
            logger -s -t PrinterSetupOSXPackage -p user.info "Installing package helper : InstallPKG"
            installer -pkg "${installpkg_location}" -target /
            if [ $? != 0 ] ; then
                logger -s -t PrinterSetupOSXPackage -p user.error "ERROR! during install of helper package : InstallPKG"
                exit -1
            fi
            installpkg_installed="YES"
        else
            logger -s -t PrinterSetupOSXPackage -p user.warn "WARNING! There are additional packages waiting to be installed. However there is no InstallPKG availible to deploy them."
        fi
    fi

    # Use InstallPKG to install the additional packages
    if [ "${installpkg_installed}" == "YES" ] ; then
        logger -s -t PrinterSetupOSXPackage -p user.info "Installing additional packages..."
        installpkg ${additional_packags_directory}/*
        if [ $? != 0 ] ; then
            # Version 0.0.5 of InstallPGK will not report errors during the installation. Hopefully a newer version will, lets get ready for that now.
            logger -s -t PrinterSetupOSXPackage -p user.error "ERROR! : during additional packages installation."
        fi
    fi
    
    # Uninsitall InstallPKG if the uninstall script is availible and it was not installed before we started.
    if [ -f "${uninstall_installpkg_location}" ] && [ "${installpkg_previously_insalled}" == "NO" ] ; then
        logger -s -t PrinterSetupOSXPackage -p user.info "Un-installing package helper : InstallPKG"
        bash "${uninstall_installpkg_location}"
        if [ $? !=0 ] ; then
            logger -s -t PrinterSetupOSXPackage -p user.error "ERROR! during un-install of helper package : InstallPKG"
        fi
    fi
fi    



########
########   Run Printer Setup - with these options
########

# Run PrinterSeutp
sudo bash "${printer_setup_script}" ${printer_setup_options}


exit 0

