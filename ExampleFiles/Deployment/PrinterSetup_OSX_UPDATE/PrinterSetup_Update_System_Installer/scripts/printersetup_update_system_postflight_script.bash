#!/bin/bash

## printersetup_update_system_postflight_script.bash
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
##      This script will lock the permissions on the files
##      which have been installed so that only root
##      and members of the wheel group have access.      
##
##

# Version 1


# Check we are running as root
currentUser=`whoami`
if [ $currentUser != "root" ] ; then
    echo "This script must be run with super user privileges."
    exit -127
fi


chmod 700 /var/printersetup
chown root:wheel /var/printersetup

chmod 700 /var/logs
chown root:wheel /var/logs

chmod 700 /etc/printersetup
chown root:wheel /etc/printersetup


exit 0

