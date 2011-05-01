#!/bin/bash
#
# GNU GPL Copyright Henri Shustak 2008
#
# This script will create the links for a specific PSL or PLF found in the
# PrinterSetupFiles or PrinterSetupLists directory at the root of PrinterSetup
#
# You must use the -s option to specify the source file. Then you may pass in a rooom
# number and also as many other arguments as you like. 
#
# Any additional arguments passed will be added to the end of the link file name.
#
# If only one argument is provided and there is no numerical numbers within this
# argument after the room number then the number 030 will be appended to the end. 
#
# The room number is delimited by a hypehn ("-").
#
# The room number will be capitalized until this system is altered.
#
# If no arguments are provided then the origional PSF or PSF name will be used as the
# room number and any hyphens in there ("-") will result in being used as extra bits
# past the room number. 
#
# Also if the first argument contains a numeric numer 0-9 but is not in the room number
# Then this number will be used to instead of the 030 number which would normally be added.
#
# The ROOMNUMBER will be set to the first argument provided, any subsequent arguments
# will also be appended spaces (" ") will be replaced by hyphens ("-"). Multiple 
# spaces will be condensed down to one hyphen.
#
# A hyphen will be created after the key word PSL or PLF and also after the room number.
#
#


# This will need to be changed depending upon your where the printer setup 
# folder is located if you move this script out somewhere then set the path
# below
#
# eg : printerSetup_folder="/Volumes/tech2/Printing & Fonts/PrinterSetup"
# If you leave this script in the followig path 'ExampleFiles/PrinterLinkScripts'
# realitive to the PrinterSetup root directory then just leave this option blank.

# Version 0.2

# Version History 
# 0.2 Added a capitalization function and enabled this function
# 0.1 Initial implementation


printerSetup_folder=""
room_number=""


function display_usage {

    echo ""
    echo "Usage : This script will do nothing unless options are spcified."
    echo ""
    echo "         -s is a required option. It is used to set source of the link which will be generated."
    echo ""
    echo "         Example (1) : create links to a specific PrinterSetupFiles : "
    echo "                       bash /path/to/sh-enable-specific.bash -s ~/Desktop/PrinterSetup/PrinterSetupFiles/AdminOffice-Staff ADMINOFFICE"
    echo "                        This will create a PSF link with the following name : PLF-ADMINOFFICE-030"
    echo ""
    echo "         Example (2) : create links to a specific PrinterSetupList : "
    echo "                       bash /path/to/sh-enable-specific.bash -s ~/Desktop/PrinterSetup/PrinterLists/AdminOffice-Staff ADMINOFFICE"
    echo "                        This will create a PLF link with the following name : PLF-ADMINOFFICE-030"
    echo ""
    echo "         Example (3) : create links to a specific PrinterSetupList with a spcific link number : "
    echo "                       bash /path/to/sh-enable-specific.bash -s ~/Desktop/PrinterSetup/PrinterLists/AdminOffice-Staff ADMINOFFICE-040"
    echo "                       This will create a PLF link with the following name : PLF-ADMINOFFICE-040"
    echo ""
    echo "         Example (4) : create links to a specific PrinterSetupList : "
    echo "                       bash /path/to/sh-enable-specific.bash -s ~/Desktop/PrinterSetup/PrinterLists/AdminOffice-Staff ADMINOFFICE STAFF"
    echo "                       This will create a PLF link with the following name : PLF-ADMINOFFICE-STAFF-030"
    echo ""
    echo "         Example (5) : create links to a specific PrinterSetupList : "
    echo "                       bash /path/to/sh-enable-specific.bash -s ~/Desktop/PrinterSetup/PrinterLists/AdminOffice-Staff"
    echo "                       This will create a PLF link with the following name : PLF-AdminOffice-Staff-030"
    echo ""
    echo "         The examples above will all generate a link to the AdminOffice PrinterList or "
    echo "         PrinterSetupFile. The the roomnumber on this link will be set to \"ADMINOFFICE\""
    echo ""
    echo ""

    
}


function generate_link {
        
    # Move into the PrinterSetupLinks direcotroy    
    cd "${printerSetup_folder}/${PrinterSetupLinks_name}"
        
    if [ "${create_PLF_links}" == "YES" ] ; then
        # We are linking to a Printer List File
        link_source_realitive_intermediate_path=`echo "${link_source_dir_path}" | awk -F "${PrinterLists_name}" '{ print $NF }'`
        link_source_realitive_pre_path="${PrinterLists_name}"
    else
        # We are linking to a Printer Setup File
        link_source_realitive_intermediate_path=`echo "${link_source_dir_path}" | awk -F "${PrinterSetupFiles_name}" '{ print $NF }'`
        link_source_realitive_pre_path="${PrinterSetupFiles_name}"
    fi

    link_source_file_realitive_path="../${link_source_realitive_pre_path}${link_source_realitive_intermediate_path}/${link_source_file_name}"
    
    # Check this source file is still availible 
    if ! [ -f "${link_source_file_realitive_path}" ] && ! [ -L "${link_source_file_realitive_path}" ]; then
        echo "ERROR! : Unable to located the spcified PSL or PSF :"
        echo "         $link_source_file_realitive_path"
        echo "         No link was created."
        exit -10
    fi
    

    link_destination_realitive_path="./${link_destination_file_name}"
    
    if [ -f "${link_destination_realitive_path}" ] || [ -L "${link_destination_realitive_path}" ] ; then
        
        # There is already a link with this name - do not overwrite this existing link.
        echo "ERROR! : Unable to create the PSL or PSF:"
        echo "         $link_destination_file_name"
        echo "         There was already a link with this name."
        echo "         No link was created"
        exit -8
        
    else
        
        # Create the link 
        ln -s "${link_source_file_realitive_path}" "${link_destination_realitive_path}"
        
        if [ $? != 0 ] ; then
            echo "ERROR! : While creating link : "
            echo "         $link_destination_realitive_path"
            exit -9
        fi
    fi        

    
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
link_source=""
link_source_file_name=""
link_source_file_realitive_path=""
link_source_realitive_intermediate_path=""
link_source_realitive_pre_path=""
link_destination_prefix=""
link_destination_room=""
calculate_the_link_destination="YES"
additional_arg_one_data=""
other_arg_data=""
origional_working_directory=`pwd`
link_number=030
create_PLF_links="NO"
create_PSF_links="NO"
add_link_number="YES"
link_destination_file_name=""
link_destination_realitive_path=""


# Check there are some arguments
if [ $# -lt 2 ] ; then
    display_usage
    exit 2
fi

##
## Read Command Line Options
##

NO_ARGS=0
E_OPTERROR=65
while getopts  "s:" option
do
   	case $option in
        s  ) link_source="${OPTARG}";;
        *  ) echo "" ; echo "ERROR!: Invalid argument." ; display_usage ; exit 3 ;;   # DEFAULT : Do Nothing
    	esac
done

shift $(($OPTIND - 1))

# Validate the Command Line Flags
if [ "${link_source}" == "" ] ; then
    display_usage
    exit 2
fi

# Ensure the source file exists
if ! [ -f "${link_source}" ] && ! [ -L "${link_source}" ]; then
    echo ""
    echo "   ERROR! : The PLF or PSF was not able to be located."
    echo "            Ensure that the file you are settings as the source for the link exists in the file system"
    echo ""
    echo "" 
    display_usage
    exit 4
fi

function make_room_number_caps {
    
    # This simply capitalized the room number destination
    link_destination_room=`echo "${link_destination_room}" | tr "[:lower:]" "[:upper:]"`  
}

# Work out the name of the source file which has been spcificed using the -s option
link_source_file_name=`basename "${link_source}"`

# Check if a room number or additional arguments we passed
# Check there are some arguments
if [ $# -lt 1 ] ; then
    # We will truncate the file name down to 40 charaters.
    # Swap in the line above the active line which truncates to 40
    # chararters below to remove this limit
    
    # link_destination_room=`basename "${link_source}"
    link_destination_room=`basename "${link_source}" | cut -c -40`
    # Capitalize the Room Number
    make_room_number_caps
    calculate_the_link_destination="NO"
fi


if [ "${calculate_the_link_destination}" == "YES" ] ; then
    
    ##
    ## Gather and valadate the other arguments from the command line.
    ##
    
    # Set the link_destination_room
    link_destination_room=`echo "${1}" | awk -F "-" '{ print $1 }'`
    # Capitalize the Room Number    
    make_room_number_caps
    link_destination_room_num_char=`echo "${link_destination_room}" | wc -c | awk '{ print $1 }'`
    
    #Add one more character so we strip the dilimiter
    ((link_destination_room_num_char++))
    
    # Calculate any extra arg one data
    additional_arg_one_data=`echo "${1}" | cut -c ${link_destination_room_num_char}-`
    
    # If there is additional arg one data present then check the last parameter for number.
    if [ "${additional_arg_one_data}" != "" ] ; then
        
        # Isolate the last section of the aditional arg one data
        arg_one_data_last_section=`echo "${additional_arg_one_data}" | awk -F "-" '{ print $NF }'`
        arg_one_data_last_section_numeric=`echo "${arg_one_data_last_section}" | grep -e "[0-9]"`        
        if [ "${arg_one_data_last_section_numeric}" != "" ] ; then
            # The last section of the origional data contains a number so we will not need to add one.
            add_link_number="NO"
        fi
    fi
    
    # Load any additional parameters
    shift
    first_additional_paramer_pass_completed="NO"
    while [ "$1" != "" ] ; do
        spaces_stripped=`echo -n "${1}" | tr -su [:space:] "-"`
        if [ "${first_additional_paramer_pass_completed}" == "YES" ] ; then
            other_arg_data="${other_arg_data}-${spaces_stripped}"
        else
            other_arg_data="${spaces_stripped}"
            first_additional_paramer_pass_completed="YES"
        fi
        shift
    done
fi

    

##
## Work out if we are dealing with a PSF or a PLF
##

link_source_dir_path=`dirname "${link_source}"`
link_source_dir_name=`basename "${link_source_dir_path}"`

# Do we need to go any further - to resolve what kind of file this is?
# This algorithm only works out the kind file based on the path to the file.
if [ "${link_source_dir_name}" != "${PrinterLists_name}" ] && [ "${link_source_dir_name}" != "${PrinterSetupFiles_name}" ] ; then

    # We need to do some digging to find out what kind of file this is. So lets look at the entire path.
    
    PrinterListPathCheck=`echo "${link_source_dir_path}" | grep -o ${PrinterLists_name}`
    PrinterSetupFilePathCheck=`echo "${link_source_dir_path}" | grep -o ${PrinterSetupFiles_name}`
    
    if [ "$PrinterListPathCheck" == "" ] && [ "$PrinterSetupFilePathCheck" == "" ] ; then
        echo "ERROR! : The PLF or PSF dose not appear to be located within either the of the following directories."
        echo ""
        echo "                - ${PrinterSetupFiles_name}"
        echo "                - ${PrinterLists_name}"
        echo ""
        echo "          Ensure that the file specified file to link to is in one of these directories and then try again."
        exit 6
    fi
    
    if [ "${PrinterListPathCheck}" != "" ] ; then
        # The PrinterListFile will take precidence. 
        link_source_dir_name="${PrinterLists_name}"
    else
        # If it can not be a printer list then a PrtinerSetupFile wil do.
        link_source_dir_name="${PrinterSetupFiles_name}"
    fi
    
fi

# Time to actually work out what kind of file we are dealing with and set the appropriate flags.
# Any issues with the simplicity below should have been caught earlier... if not then we are going to crash soon.
if [ "${link_source_dir_name}" == "${PrinterLists_name}" ] ; then
    link_destination_prefix="PLF"
    create_PLF_links="YES"
else
    link_destination_prefix="PSF"
    create_PSF_links="YES"
fi


# Ensure the source still exists after some manipulation
if ! [ -f "${link_source}" ] && ! [ -f "${link_source}" ] ; then
    echo ""
    echo "   ERROR! : The PLF or PSF was not able to be located."
    echo "            Ensure that the file you are settings as the source for the link exists in the file system"
    echo ""
    echo "" 
    display_usage
    exit 4
fi


##
## Calculate the name for the link which we are about to create
##

# If somone thinks about this for a couple of moments, then there will be an elegant way of doing this entire script with less than 10 lines of code.
# Ahhh you have to love bash, almost as much as my inability to think about a problem for more than one moment. This script works. (: hopefully :)

if [ "${add_link_number}" == "YES" ] ; then
    # Are going to be adding the link number because it was not provided
    if [ "${additional_arg_one_data}" != "" ] ; then
        # We will be adding arg one data
        if [ "${other_arg_data}" != "" ] ; then
            # We will add some other arg data on at the end
            link_destination_file_name="${link_destination_prefix}-${link_destination_room}-${additional_arg_one_data}-${link_number}-${other_arg_data}"
        else
            # There is no other arg data to add on so we will not put any at the end
            link_destination_file_name="${link_destination_prefix}-${link_destination_room}-${additional_arg_one_data}-${link_number}"
        fi
    else
        # We will be not be adding arg one data to this link name
        if [ "${other_arg_data}" != "" ] ; then
            # We will add some other arg data on at the end
            link_destination_file_name="${link_destination_prefix}-${link_destination_room}-${link_number}-${other_arg_data}"
        else
            # There is no other arg data to add on so we will not put any at the end
            # We are not going to add any arg one data
            link_destination_file_name="${link_destination_prefix}-${link_destination_room}-${link_number}"
        fi
        
        
    fi
else
    # The link number was provided as an additional argument. Therefore we will not need to make one up for this link.
    if [ "${other_arg_data}" != "" ] ; then
        # We will add some other arg data on at the end
        link_destination_file_name="${link_destination_prefix}-${link_destination_room}-${additional_arg_one_data}-${other_arg_data}"
    else
        # No a other arg data for this time
        link_destination_file_name="${link_destination_prefix}-${link_destination_room}-${additional_arg_one_data}"
    fi
fi

#echo $link_destination_file_name


generate_link


# Return to the origional working directory
cd "${origional_working_directory}"


exit 0




