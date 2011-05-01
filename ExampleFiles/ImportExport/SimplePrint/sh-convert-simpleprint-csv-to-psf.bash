#!/bin/bash

##########################################################################
##							      		                                ##
## 	This script converts a SimplePrint CSV file to a PrinterSetup   	## 
##	PSF files. It may need modification depending upon your requirments ##
##                                                                      ##
##	(C) Copyright Henri Shustak 2007						            ##
##	This Script is Released under the GNU GPL License		            ##
##  Lucid Information Systems                                           ## 
## 	http://www.lucidsystms.org                                          ##
## 	                                    								##
##  v0002																##
##																		##
##									                                    ##
##########################################################################



INPUTFILE="${1}"                                        # This may need to be changed for your settings
OUTPUTDIRECTORY="${2}"                                  # This may need to be changed for your settings


file_name=""                                            # This is set to the printer name
printer_name=""                                         # read from csv file (first field)
printer_description=""                                  # read from csv file (second field)
printer_location=""                                     # read from csv file
printer_network_address=""                              # read from csv file
printer_published=""                                    # this should be set to yes or no if you would like it written to the PSF file.
printer_ppd=""                                          # This will use generic PPD unless a PPD is specified within the csv file
default_printer_ppd="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/English.lproj/Generic.ppd"




function generate_printersetup_file {

    # This function simply generates the PSF.
    # You will most likly want to modify the section below this 
    # function, where the input file is parsed.
    
    printersetupfile="$OUTPUTDIRECTORY""/""$printer_name"
    
    if [ -f "${printersetupfile}" ] ; then
        echo "WARNING! : printer setup file already exisits"
        echo "           $printer_name not created"
        return -1
    else
        touch "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo "# This is a Printer Setup : Printer Configuration File" >> "${printersetupfile}"
        echo "# Copyright 2006 Henri Shustak GNU GPLv2" >> "${printersetupfile}"
        echo "#" >> "${printersetupfile}"
        echo "#" >> "${printersetupfile}"
        echo "# Printer Setup File v0001" >> "${printersetupfile}"
        echo "# it is important that there are tabs inserted after the colon." >> "${printersetupfile}"
        echo "# This version of the parsing system has an issue which means that" >> "${printersetupfile}"
        echo "# you can only have a few tabs. The port to python should resolve this" >> "${printersetupfile}"
        echo "# issue. Also note that currently comments can only be at the start of a line" >> "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo "# Printer Setup Notes : Printer Name is only valid if it contains no spaces" >> "${printersetupfile}"
        echo "# Use the Printer Description to a description with spaces" >> "${printersetupfile}"
        echo "" >> "${printersetupfile}"
        echo -e "Printer Name :\t\t\t${printer_name}" >> "${printersetupfile}"
        echo -e "Printer Description :\t\t${printer_description}"  >> "${printersetupfile}"
        echo -e "Printer Location :\t\t${printer_location}"  >> "${printersetupfile}"
        echo -e "Printer Network Address :\t${printer_network_address}" >> "${printersetupfile}"
        echo -e "Printer PPD :\t\t\t${printer_ppd}" >> "${printersetupfile}"
        if [ "$printer_published" != "" ] ; then
            echo -e "Printer Published :\t\t${printer_published}" >> "${printersetupfile}"
        fi           
        echo "" >> "${printersetupfile}"
    fi
    
    return 0

}



# Preflight Check
function pre_flight_check {

    if [ "$num_argumnets" -lt "1" ] ; then
        echo "ERROR ! : No argument provided. This script will now exit."
        echo "          Usage : sh-convert-simpleprint-csv-to-psf.bash /path/to/inputfile.csv /path/to/outputdirectory"
        exit -127
    fi

    # Check that the input csv file exists
    if ! [ -f "${INPUTFILE}" ] ; then 
        echo "ERROR ! : The input CSV file could not be found."
        echo "          Usage : sh-convert-simpleprint-csv-to-psf.bash /path/to/inputfile.csv /path/to/outputdirectory"
        exit -127
    fi
    
    # Check the output directory exists
    if ! [ -d "${OUTPUTDIRECTORY}" ] ; then 
        echo "ERROR ! : The output directory could not be found."
        echo "          Usage : sh-convert-simpleprint-csv-to-psf.bash /path/to/inputfile.csv /path/to/outputdirectory"
        exit -127
    fi

}


# Run Preflight Check
num_argumnets=$#
pre_flight_check


# Loop to parse the input file

run=0
sucess=0
exec < "${INPUTFILE}"
a1=start
while [ "$a1" != "" ] ; do
    read a1 
    if [ "$a1" != "" ] ; then
        # Skip the first line of the SimplePrint CSV file... this is just the header line.
        if [ $run != 0 ] ; then
            # Configure Varibles
            # This is probably the section you will want to modify
            printer_name=`echo ${a1} | awk 'BEGIN {FS = ","}; { print $3}'`
            file_name=${printer_name}

            # Printer Description
            printer_description=`echo ${a1} | awk 'BEGIN {FS = ","}; { print $4}'`

            # Printer Location
            printer_location=`echo ${a1} | awk 'BEGIN {FS = ","}; { print $5}'`
            
            # Printer PPD
            # Chaged from field 6 to field 7 in beta update.
            printer_ppd_full_path=`echo ${a1} | awk 'BEGIN {FS = ","}; { print $7}'`     
            printer_ppd=`basename "${printer_ppd_full_path}"`
            if [ "${printer_ppd}" == "" ] ; then
                printer_ppd="${default_printer_ppd}"
            fi
            
            # Printer Network Address
            # Chaged from field 7 to field 6 in beta update.
            printer_network_address=`echo ${a1} | awk 'BEGIN {FS = ","}; { print $6}'`
            
            # Generate the Printer Setup File
            generate_printersetup_file
            if [ $? == 0 ] ; then 
                (( sucess++ ))
            fi		
        fi
        # increment run
        (( run++ ))		
    fi
done
    
    
# Final reporting of the PSF generation

parseed=`echo $run - 1 | bc`
    
echo ""   
echo "Parsed $parseed lines from input file"
echo "Sucessfully Generated $sucess printer setup files."
echo ""



exit 0


