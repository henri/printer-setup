#!/bin/bash

# (C)2013 Henri Shustak
# License GNU GPL v3
# http://www.lucidsystems.org

# Version 0.1

# About : This script will add everyone into the lpoperator group, thus\
#         allowing them to pause, resume, print queues on the system.
#         This is going to esentialy esculate the privildges of the
#         everyone group. You could opt to just add particualr users to
#         the lpoperator group. This significantly increases all user
#         previliges on the system.

# Check we are running as root
currentUser=`whoami`
if [ $currentUser != "root" ] ; then
	echo This script must be run with super user privileges
	exit -127
fi

/usr/sbin/dseditgroup -o edit -a everyone -t group _lpadmin
exit $?

