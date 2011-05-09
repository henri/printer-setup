#!/bin/bash

# GNU GPL Copyright Henri Shustak 2008
# 
# Lucid Information Systems
# http://www.lucidsystems.org
#
# Converts a directory of apple installers into seperate disk image files, each contining one of the installers
#

# Version 1.3
# 
# Version History
# 1.0 : initial release
# 1.1 : fixed a bug relating to the deletion of images when skipping exisiting images was disabled.
# 1.2 : minor update to output reporting.
# 1.3 : added the ability to overwrite images via an environment variable.

# Configuration 

# Leave this set to yes, unles you want to overwirte old disk images
default_overwrite_existing_images="NO"


# Gather input arguments
input_directory="${1}" 
output_directory="${2}"
num_arguments=$#

# Internal Varibles
num_images_skipped=0
images_created=0
packages_processed=0
image_creation_errors=0

# Validate the environment variables
if [ "${overwrite_existing_images}" == "" ] ; then
    # validate the current setting 
    overwrite_existing_images="${default_overwrite_existing_images}"
fi

# Validate overwrite_existing_images variable
if [ "${overwrite_existing_images}" != "YES" ] && [ "${overwrite_existing_images}" != "NO" ] ; then
    echo "     ERROR! : The overwrite_existing_images variable is not valid. It must be set to \"YES\" or \"NO\"."
    echo "              Please check your shell is clean or that this shell variable is exported as a valid option."
    echo "              The env command will typically provide a list of environment variables"
    echo "              The default option is \"NO\" ; as to not overwrite existing packages."
    exit -1
fi


# Checking the arguments
if [ $num_arguments != 2 ] ; then
        echo "Usage : $0 <input_directory> <output_directory>"
        exit -1
fi

# Checking the input directory
if ! [ -d "${input_directory}" ] ; then 
	echo "ERROR! : Unable to locate input directory : $input_directory"
	exit -1
fi

# Checking the output directory
if ! [ -d "${output_directory}" ] ; then 
	echo "ERROR! : Unable to locate output directory : $input_directory"
	exit -1
fi

# correct any trailing slashes etc in the input and output directories
input_directory="`dirname "${input_directory}"`/`basename "${input_directory}"`"
output_directory="`dirname "${output_directory}"`/`basename "${output_directory}"`"




# Do something usefull like make some disk images. 
for package_pkg in "${input_directory}"/*.pkg ; do
        
        # Work out what this should be called
        name_of_packge="`basename "${package_pkg}"`"
        location_of_package="${output_directory}/${name_of_packge}"
        location_of_image=`echo "${location_of_package}" | sed 's/\..\{3\}$//'`
        location_of_image_with_extension="${location_of_image}.dmg"
        
        ((packages_processed++))
        skip_this_image_generation="NO"
        
        
        # Produce some feedback regarding which packages we are currently processing
        echo "Generating disk image for package : $name_of_packge"
        
        if [ -e "${location_of_image_with_extension}" ] ; then
                if [ "${overwrite_existing_images}" == "YES" ] ; then 
                        rm "${location_of_image_with_extension}"
                else
                        echo "       Image already exists for package. A new image will not be generated."
                        skip_this_image_generation="YES"
                        ((num_images_skipped++))
                fi
        fi
        
        # Make the package - unless we skip this one due to one already being there.
        if [ "${skip_this_image_generation}" == "NO" ] ; then
                # Disk utility in 10.5 handels all of the extensions etc.        
                hdiutil create -srcfolder "${package_pkg}" "${location_of_image_with_extension}"
                if [ $? == 0 ] ; then
                        ((images_created++))
                else
                        ((image_creation_errors++))
                fi
        fi
        
done

# Print a summary 
echo ""
echo ""
echo "Summary : "
echo "======================================================== "
echo "Packages in directory processed for image creation : $packages_processed"
echo "Packages skipped due to earlier image creation     : $num_images_skipped"
echo "Packages processed into images successfully        : $images_created"
echo "Packages with errors during creation :             : $image_creation_errors"
echo ""
echo ""

exit 0 


# Notes : 
#hdiutil create -srcfolder -volname 





