#!/bin/bash

## printersetupupdateconfiguration_postflight_script.bash
##//////////////////////////////////////////////////////////
## 
## Copyright 2008 © Henri Shustak GNU GPL v2
## Lucid Information Systems
## http://lucidsystems.org
##

########################################
##
##  What this script is going to do :
##
##      This script is going to load in to LaunchD 
##      The specified .plist 
##

# Version 1.1

# You should set this so that it is set up with your PrintSetup Update Servers address or your domain.
plist_to_load="/Library/LaunchDaemons/com.yourdomain.PrinterSetupUpdate"


# Check we are running as root
currentUser=`whoami`
if [ $currentUser != "root" ] ; then
    echo "This script must be run with super user privileges."
    exit -127
fi


# Check Permission and Ownership of the .plist file which will initiate the system.
chmod 755 ${plist_to_load}
chown root:wheel ${plist_to_load}

# Check if it is already loaded
plist_to_load_name=`basename "${plist_to_load}" | sed 's/.plist$//'`
loaded_result=`launchctl list | grep "${plist_to_load_name}"`
if [ "${loaded_result}" != "" ] ; then
    # Unload the current instance as it is already loaded
    launchctl unload "${plist_to_load}"
fi

# Load the .plist file into LaunchD so it is active
launchctl load "${plist_to_load}"


exit 0

