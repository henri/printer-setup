#!/bin/bash

##//////////////////////////////////////////////////////////
## 
## Copyright 2008 © Henri Shustak GNU GPL v3
## Lucid Information Systems
## http://lucidsystems.org
##

########################################
##
##  What this script is going to do :
##
##      This script is going set the domain based upon the argument 
##      passed in as argument number one.
##

########################################
## 
## Notes : 
##
##      This script is highly experimental. It makes many assumptions. 
##      Although using this script is probably going to save you time,
##      it is of extreme importance that you check that it worked.
##

# Version 1.0

#####################
## Configuration
#####################

in_progress_file_name="domain_configuration_in_progress.lock"



#####################
## Internal Varibles
#####################


domain_name="$1"
domain_name_reverse=`ruby -e "puts \"$domain_name\".split(\".\").reverse.join(\".\")"`

# Create Temporary Directory
tmp_dir=`mktemp -d /tmp/printersetup_domain_configuration.XXXXXXXXXXX`
chmod 700 "${tmp_dir}"

exit_status=0

num_arguments=$#

PrinterSetup_Dynamic_Configuration_Installer_Template_dir=`dirname "${0}" | sed 's/\/scripts$//'`
PrinterSetup_Dynamic_Deployment_dir=`dirname "${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}"`
new_PrinterSetup_Dynamic_Configuration_Installer_dir="${PrinterSetup_Dynamic_Deployment_dir}/PrinterSetup_Dynamic_Configuration_Installer-${domain_name}"


in_progress_file="${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/scripts/${in_progress_file_name}"


##
## Files and directories which this script is going to be changing to bring the example into your domain.
##

original_printersetup_dynamic_configuration_postflight_script="${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/scripts/printersetup_dynamic_configuration_postflight_script.bash"

original_printersetup_dynamic_var_configuration_dir="${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/root/var/printersetup/configurations/printersetup-update-server.yourdomain.com"

original_printersetup_dynamic_launch_daemon="${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/root/Library/LaunchDaemons/com.yourdomain.PrinterSetupDynamic.plist"

original_printersetup_dynamic_etc_configuration_dir="${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/root/etc/printersetup/configurations/printersetup-dynamic.yourdomain.com"
original_printersetup_dynamic_etc_script="${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/root/etc/printersetup/configurations/printersetup-dynamic.yourdomain.com/dynamic_script"



##
## Temporary Staging Locations
##

tmp_printersetup_dynamic_configuration_postflight_script="${tmp_dir}/printersetup_dynamic_configuration_postflight_script.bash"

tmp_printersetup_dynamic_var_configuration_dir="${tmp_dir}/var/printersetup-update-server.${domain_name}"

tmp_printersetup_dynamic_launch_daemon="${tmp_dir}/${domain_name_reverse}.PrinterSetupDynamic.plist"

tmp_printersetup_dynamic_etc_configuration_dir="${tmp_dir}/etc/printersetup-dynamic.${domain_name}"
tmp_printersetup_dynamic_etc_script="${tmp_dir}/etc/printersetup-dynamic.${domain_name}/dynamic_script"



##
## Final Copy Back Locations
##


final_printersetup_dynamic_configuration_postflight_script="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/scripts/printersetup_dynamic_configuration_postflight_script.bash"

final_printersetup_dynamic_var_configuration_dir="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/var/printersetup/configurations/printersetup-update-server.${domain_name}"

final_printersetup_dynamic_launch_daemon="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/Library/LaunchDaemons/${domain_name_reverse}.PrinterSetupDynamic.plist"

final_printersetup_dynamic_etc_configuration_dir="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/etc/printersetup/configurations/printersetup-dynamic.${domain_name}"
final_printersetup_dynamic_etc_script="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/etc/printersetup/configurations/printersetup-dynamic.${domain_name}/dynamic_script"

##
## These ones require removal
##

# Just not needed
to_remove_final_in_progress_file="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/scripts/${in_progress_file_name}"
to_remove_final_domain_configuration_bashscript="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/scripts/domain_configuration.bash"
to_remove_final_domain_configruation_applescript="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/scripts/domain_configuration.app"

# To be updated or changed
to_remove_final_printersetup_dynamic_configuration_postflight_script="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/scripts/printersetup_dynamic_configuration_postflight_script.bash"
to_remove_final_printersetup_dynamic_var_configuration_dir="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/var/printersetup/configurations/printersetup-update-server.yourdomain.com"
to_remove_final_printersetup_dynamic_launch_daemon="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/Library/LaunchDaemons/com.yourdomain.PrinterSetupDynamic.plist"
to_remove_final_printersetup_dynamic_etc_configuration_dir="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/etc/printersetup/configurations/printersetup-dynamic.yourdomain.com"
to_remove_final_printersetup_dynamic_etc_script="${new_PrinterSetup_Dynamic_Configuration_Installer_dir}/root/etc/printersetup/configurations/printersetup-dynamic.yourdomain.com/dynamic_script"




#####################
## Functions
#####################


function clean_exit {

    # Clean the temporary directory
    rm -R "${tmp_dir}"
    
    # If there was a problem remove the partially created domain specific installer
    if [ -d "${new_PrinterSetup_Dynamic_Configuration_Installer_dir}" ] && [ $exit_status != 0 ] ; then
        rm -R "${new_PrinterSetup_Dynamic_Configuration_Installer_dir}"
    fi
    
    # Remove the in progress lock file
    rm -f "${in_progress_file}"
    
    # Exit from this script and report the exit status
    exit $exit_status
}


function preflight_checks {

    # Check that at least one argument was supplied
    if [ $num_arguments != 1 ] ; then
        echo "ERROR! : You must specify a single domain which will be used for configuration as the first argument."
        echo "         Usage : ./domain_configuration.bash your.domain.com"
        exit_status=-127
        clean_exit
    fi


    # Check if the system is running or has been run
    if [ -f "${in_progress_file}" ] || [ -d "${new_PrinterSetup_Dynamic_Configuration_Installer_dir}" ] ; then 
        echo "ERROR! : This script either currently running or has already been run for this domain."
        echo "         No configuration files or directories have been modified."
        exit_status=-126
        clean_exit
    fi
    
    # Check the original files are available 
    # if [ -f "${original_printersetup_dynamic_configuration_postflight_script}" ] && [ -d "${original_printersetup_dynamic_var_configuration_dir}" ] && [ -f "${original_printersetup_dynamic_launch_daemon}" ] && [ -d "${original_printersetup_dynamic_etc_configuration_dir}" ] && [ -f "${original_printersetup_dynamic_etc_script}" ] ; then
    if [ -f "${original_printersetup_dynamic_configuration_postflight_script}" ] && [ -d "${original_printersetup_dynamic_var_configuration_dir}" ] && [ -f "${original_printersetup_dynamic_launch_daemon}" ] && [ -d "${original_printersetup_dynamic_etc_configuration_dir}" ] && [ -f "${original_printersetup_dynamic_etc_script}" ] ; then   
        return 0
    else
        echo "ERROR! : One or more of the original files or directories are not available for modification."
        echo "         No configuration files or directories have been modified." 
        exit_status=-125
        clean_exit   
    fi

 
}

function create_lock_file {
    touch "${in_progress_file}"
    if [ $? != 0 ] ; then
        echo "ERROR! : Generating In Progress Lock File."
        exit_status-121
        clean_exit
    fi
}

function stage_files_into_tmp {


    # Copy Some Files - Will return 0 on success and -1 on a failure.

    cp -r "${original_printersetup_dynamic_configuration_postflight_script}" "${tmp_printersetup_dynamic_configuration_postflight_script}"
    if [ $? != 0 ] ; then
        return -1
    fi

    mkdir "${tmp_dir}/var"
    if [ $? != 0 ] ; then
        echo "ERROR! : Unable to generate the following directory"
        echo "         ${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/var"
        exit_status=-123
        clean_exit
    fi
    
    cp -r "${original_printersetup_dynamic_var_configuration_dir}" "${tmp_printersetup_dynamic_var_configuration_dir}"
    if [ $? != 0 ] ; then
        return -1
    fi
    
    cp -r "${original_printersetup_dynamic_launch_daemon}" "${tmp_printersetup_dynamic_launch_daemon}"
    if [ $? != 0 ] ; then
        return -1
    fi

    mkdir "${tmp_dir}/etc"
    if [ $? != 0 ] ; then
        echo "ERROR! : Unable to generate the following directory"
        echo "         ${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}/etc"
        exit_status=-123
        clean_exit
    fi

    cp -r "${original_printersetup_dynamic_etc_configuration_dir}" "${tmp_printersetup_dynamic_etc_configuration_dir}"
    if [ $? != 0 ] ; then
        return -1
    fi    

    cp -r "${original_printersetup_dynamic_etc_script}" "${tmp_printersetup_dynamic_etc_script}"
    if [ $? != 0 ] ; then
        return -1
    fi    
    
    return 0

}



function modify_tmp_files {

    ##
    ## modify the post flight script
    ##
    perl -pi -e 's/plist_to_load="\/Library\/LaunchDaemons\/com.yourdomain.PrinterSetupDynamic.plist\"/plist_to_load="\/Library\/LaunchDaemons\/'${domain_name_reverse}'.PrinterSetupDynamic.plist\"/' "${tmp_printersetup_dynamic_configuration_postflight_script}"
    if [ $? != 0 ] ; then
        return 1
    fi
    
    osascript -e "tell application \"Finder\" to set label index of item (POSIX file (\"${tmp_printersetup_dynamic_configuration_postflight_script}\")) to 4" > /dev/null 2> /dev/null
    if [ $? != 0 ] ; then
        return 1
    fi



    ##
    ## modify the launch daemon
    ##
    perl -pi -e 's/com.yourdomain.PrinterSetupDynamic/'${domain_name_reverse}'.PrinterSetupDynamic/' "${tmp_printersetup_dynamic_launch_daemon}"
    if [ $? != 0 ] ; then
        return 1
    fi
    
    perl -pi -e 's/printersetup-dynamic.yourdomain.com/printersetup-dynamic.'${domain_name}'/' "${tmp_printersetup_dynamic_launch_daemon}"
    if [ $? != 0 ] ; then
        return 1
    fi
    
    osascript -e "tell application \"Finder\" to set label index of item (POSIX file (\"${tmp_printersetup_dynamic_launch_daemon}\")) to 4" > /dev/null 2> /dev/null
    if [ $? != 0 ] ; then
        return 1
    fi


    ##
    ## modify the dynamic etc script
    ##
    perl -pi -e 's/configuration_name="printersetup-update-server.yourdomain.com"/configuration_name="printersetup-update-server.'${domain_name}'"/' "${tmp_printersetup_dynamic_etc_script}"
    if [ $? != 0 ] ; then
        return 1
    fi
    
    osascript -e "tell application \"Finder\" to set label index of item (POSIX file (\"${tmp_printersetup_dynamic_etc_script}\")) to 4" > /dev/null 2> /dev/null
    if [ $? != 0 ] ; then
        return 1
    fi
    
    return 0

}


function generate_domain_specific_installer {

    # Copy the template to build the new domain specific installer
    cp -r "${PrinterSetup_Dynamic_Configuration_Installer_Template_dir}" "${new_PrinterSetup_Dynamic_Configuration_Installer_dir}"
    if [ $? != 0 ] ; then
        echo "ERROR! : Generating Domain Specific Installer,"
        echo "         Unable to Copy Template Direcotry."
        exit_status=-122
        clean_exit
    fi
    
    # Give this new installer a red label
    osascript -e "tell application \"Finder\" to set label index of item (POSIX file (\"${new_PrinterSetup_Dynamic_Configuration_Installer_dir}\")) to 2" > /dev/null 2> /dev/null
    
    
    # Remove the un-needed files and directories from the new domain specific installer directory
    rm -fR "${to_remove_final_in_progress_file}" "${to_remove_final_domain_configuration_bashscript}" "$to_remove_final_domain_configruation_applescript"
    
    # Remove the files and directories which are to be updated from the new domain specific installer directory (some of these can just be overwritten but it is better to remove them for clarification)
    rm -R "${to_remove_final_printersetup_dynamic_configuration_postflight_script}" "${to_remove_final_printersetup_dynamic_var_configuration_dir}" "${to_remove_final_printersetup_dynamic_launch_daemon}" "${to_remove_final_printersetup_dynamic_etc_script}" "${to_remove_final_printersetup_dynamic_etc_configuration_dir}"
    if [ $? != 0 ] ; then
        echo "ERROR! : Generating Domain Specific Installer,"
        echo "         Unable to remove certain files which need to be deleted or overwritten."
        exit_status=-121
        clean_exit
    fi  
    
    
    # Copy temporary files into place - we could move them but a copy will be fine.
    
    cp -r "${tmp_printersetup_dynamic_configuration_postflight_script}" "${final_printersetup_dynamic_configuration_postflight_script}"
    if [ $? != 0 ] ; then
        return 1
    fi
    
    cp -r "${tmp_printersetup_dynamic_var_configuration_dir}" "${final_printersetup_dynamic_var_configuration_dir}"
    if [ $? != 0 ] ; then
        return 1
    fi
    
    cp -r "${tmp_printersetup_dynamic_launch_daemon}" "${final_printersetup_dynamic_launch_daemon}"
    if [ $? != 0 ] ; then
        return 1
    fi

    cp -r "${tmp_printersetup_dynamic_etc_configuration_dir}" "${final_printersetup_dynamic_etc_configuration_dir}"
    if [ $? != 0 ] ; then
        return 1
    fi

    cp -r "${tmp_printersetup_dynamic_etc_script}" "${final_printersetup_dynamic_etc_script}"
    if [ $? != 0 ] ; then
        return 1
    fi
    
    return 0 
    

}


#####################
## Logic
#####################

preflight_checks
create_lock_file

stage_files_into_tmp
if [ $? != 0 ] ; then
    echo "ERROR! : Copying files to temporary directory."
    exit_status=-124
    clean_exit
fi

modify_tmp_files
if [ $? != 0 ] ; then
    echo "ERROR! : Modifying temporary files and directories."
    exit_status=-123
    clean_exit
fi

generate_domain_specific_installer
if [ $? != 0 ] ; then
    echo "ERROR! : Copying temporary files and/or directories to the new domain specific installer."
    exit_status=-123
    clean_exit
fi

# Open the new directory in the finder.
open "${new_PrinterSetup_Dynamic_Configuration_Installer_dir}"


# It would be good to set the expanded attribute of the /etc/ configurations to true, once apple script supports this command.

clean_exit
exit 0

