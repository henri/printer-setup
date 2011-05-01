#!/bin/bash
#
# GNU GPL Copyright Henri Shustak 2007
#
# This script will create the links for any files found within the
# PrinterSetupFiles directory at the root of PrinterSetup
# The room number will be set to PACKAGE, so that these links may be used
# during the package creation process.
#


# This will need to be changed depending upon your where the printer setup 
# folder is located if you move this script out somewhere then set the path
# below
#
# eg : printerSetup_folder="/Volumes/tech2/Printing & Fonts/PrinterSetup"
# If you leave this script in the followig path 'ExampleFiles/PrinterLinkScripts'
# realitive to the PrinterSetup root directory then just leave this option blank.

# Version 0.2

printerSetup_folder=""
room_number=""


function display_usage {

    echo ""
    echo "Usage : This script will do nothing unless options are spcified."
    echo ""
    echo "         -f will create links for files items found or linked to within the \"PrinterSetupFiles\" directory."
    echo "         -l will create links for files items found or linked to within the \"PrinterSetupLists\" directory"
    echo "         -r Is a required option. It is used to set the room number of the links which are created."
    echo ""
    echo "         Example (1) : create links to PrinterSetupFiles : bash /path/to/sh-printersetup_create_links.bash -f -r PACKAGE"
    echo "         Example (2) : create links to PrinterSetupLists : bash /path/to/sh-printersetup_create_links.bash -l -r PACKAGE"
    echo "         Example (3) : create links to both : bash  /path/to/sh-printersetup_create_links.bash -lf -r PACKAGE"
    echo ""
    echo "         The examples above will all generate links with the roomnumber set to \"PACKAGE\""
    echo ""
    echo ""
    
}


function generate_printer_setup_links {
    
    # Build a list of links
    find "${link_source_name}" -type l > "${pre_processing_links}"
    
    # Polulate the pre processing file with links which point to actual files rather than directories.
    # This may introduce duplicates into the system, however printer setup will simply process them twice.
    # The alternive is to only link to actaul files rather than symbolic links. This way provides slightly more flexibility and there is no danger of file system loops.
    exec < "${pre_processing_links}"
    while true ; do
        read current_link_source || break
        current_tmp_link_destination_file_name=`dirname "${current_link_source}"`
        current_tmp_link_destination_path=`ls -l "${current_link_source}" | awk -F "${current_tmp_link_destination_file_name} -> " '{print $2}'`
        if [ -f "${current_tmp_link_destination_path}" ] ; then
            # Add this PSF link to the temporay post processing file
            echo "${current_tmp_link_destination_path}" > "${post_processing_file}"
        fi
    done
    
    
    # Populate the temparoy processing file with any actuall files
    find "${link_source_name}" -type f | grep -v ".DS_Store" >> "${post_processing_file}"
    
    # Move into the PrinterSetupLinks direcotroy
    cd "${PrinterSetupLinks_name}"
    
    # Scan the tempoary processing file and create required links
    exec < "${post_processing_file}"
    while true ; do 
        read current_link_source || break
        current_link_destination_file_name=`basename "${current_link_source}" | tr -cd '[:alnum:]\n' | cut -c -40`
        current_link_destination_realitive_path="./${link_destination_prefix}-${room_number}-${current_link_number}-${current_link_destination_file_name}"
        
        if [ -f "${current_link_destination_realitive_path}" ] ; then
            echo "WARNING! : Link already exists. Link creation skipped for : $current_link_destination_realitive_path"
        else
            ln -s "../${current_link_source}" "${current_link_destination_realitive_path}"
        fi
        
        # incriment the link number
        (( current_link_number ++ ))
        
    done
    
}


# Get Printer Setup Path if it has not been set in the configuration section.
if [ "${printerSetup_folder}" == "" ] ; then
    # Root slash required. No trailing slash required.
    path_from_root="/ExampleFiles/LinkGeneration"
    parent_folder=`dirname "${0}"`
    # Check the script has not been moved to a non-standard location. 
    # If the grep fails, then the script location is in a non-standard
    echo "${parent_folder}" | grep "${path_from_root}" > /dev/null
    script_in_standard_location=$?
    if [ $script_in_standard_location != 0 ] ; then
        echo "ERROR! The script is located in a non-standard location, and the printer setup root has not been updated."
        exit 1
    else
        # We can safly set the printerSetup folder
        printerSetup_folder=`echo "${parent_folder}" | awk -F "${path_from_root}" '{ print $1 }'`
        # better check it actually worked just to be 100% safe.
        if [ "${printerSetup_folder}" == "" ] || ! [ -d "${printerSetup_folder}" ] ; then
            echo "ERROR! Determining the PrinterSetup's root directory."
            exit 1
        fi
    fi
fi 


# Now we know where things should be located lets set some varibles.
PrinterSetupLinks_name="PrinterSetupLinks"
PrinterSetupFiles_name="PrinterSetupFiles"
PrinterLists_name="PrinterLists"
link_source_name=""
link_destination_prefix=""
current_link_source=""
current_link_destination_realitive_path=""
current_link_destination_file_name=""
current_tmp_link_destination_path=""
current_tmp_link_destination_file_name=""
origional_working_directory=`pwd`
current_link_number=101
create_PLF_links="NO"
create_PSF_links="NO"


# Check there are some arguments
if [ $# -lt 1 ] ; then
    display_usage
    exit 2
fi


## Read Command Line Options

NO_ARGS=0
E_OPTERROR=65
while getopts  "flr:" option
do
   	case $option in
        f  ) create_PSF_links="YES";;
        l  ) create_PLF_links="YES";;
        r  ) room_number="${OPTARG}";;
        *  ) echo "" ; echo "ERROR!: Invalid argument." ; display_usage ; exit 3 ;;   # DEFAULT : Do Nothing
    	esac
done
shift $(($OPTIND - 1))


# Validate the Command Line Flags
if [ "${room_number}" == "" ] || ( [ "${create_PSF_links}" != "YES" ] && [ "${create_PLF_links}" != "YES" ] ) ; then

    display_usage
    exit 2
fi


# Specifiy and create the temporary post processing file
post_processing_file=`mktemp /tmp/printersetup_cpl_post_XXXXXXXXX`
if [ $? != 0 ] ; then
    echo "ERROR! : Generating tempoary post processing file."
    exit 1
fi

# Specifiy temporary processing pre list file
pre_processing_links=`mktemp /tmp/printersetup_cpl_pre_XXXXXXXXX`
if [ $? != 0 ] ; then
    echo "ERROR! : Generating tempoary pre processing file."
    exit 1
fi


if [ "${create_PSF_links}" == "YES" ] ; then
    # Generate the PSF Links
    link_source_name="${PrinterSetupFiles_name}"
    link_destination_prefix="PSF"
        
    # Move to printer setup root
    cd "${printerSetup_folder}"
    
    if [ -d "${PrinterSetupLinks_name}" ] && [ -d "${link_source_name}" ] ; then
        # Time to scan the PrinterSetupFiles direcory for files to create links to.
        generate_printer_setup_links
    else
        echo "ERROR! The required PrinterSetup directory structure was not found for processing the PSF's."
    fi
fi


if [ "${create_PLF_links}" == "YES" ] ; then
    # Generate the PSL Links
    link_source_name="${PrinterLists_name}"
    link_destination_prefix="PLF"
    
    # Move to printer setup root
    cd "${printerSetup_folder}"
    
    if [ -d "${PrinterSetupLinks_name}" ] && [ -d "${link_source_name}" ] ; then
        # Time to scan the PrinterSetupLists direcory for files to create links to.
        generate_printer_setup_links
    else
        echo "ERROR! The required PrinterSetup directory structure was not found for processing the PSL's."
    fi
fi


# Return to the origional working directory
cd "${origional_working_directory}"


# clean up temporary files
rm -f "${post_processing_file}"
rm -f "${pre_processing_file}"


exit 0

