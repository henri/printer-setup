#!/bin/bash

##########################################################################
##							      		                                ##
## 	This script can be used to automate the generation 					## 
##	of PSF files. It may need modification depending                    ##
##  upon your purposes. Please submit modifications backto the          ##
##  PrinterSetup porject for the binifit of the community.  			##
##									                                    ##
##	(C) Copyright Henri Shustak 2007						            ##
##	This Script is Released under the GNU GPL License		            ##
##  Lucid Information Systems                                           ## 
## 	http://www.lucidsystms.org                                          ##								
## 	                                    								##
##  v0001																##
##																		##
##									                                    ##
##########################################################################

INPUTFILE=""                                            # This will need to be changed for your settings
OUTPUTDIRECTORY=""                                      # This will need to be changed for your settings
file_name=""                                            # This is set to the printer name
printer_name=""                                         # Sucked in from a tab delimited file (first field)
printer_description=""                                  # Sucked in from a tab delimited file (second field)
printer_location="MyLocations"                          # Set this to something usefull for you
printer_network_address="cupspykota:lpd://10.0.0.2"     # Set this to something usefull for you
printer_ppd=""                                          # This will use generic PPD



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
        echo -e "Printer Network Address :\t${printer_network_address}/${printer_name}" >> "${printersetupfile}"
        echo -e "Printer PPD :\t\t\t${printer_ppd}" >> "${printersetupfile}"
        echo "" >> "${printersetupfile}"
    fi
    
    return 0

}


# Loop to parse the input file

run=0
sucess=0
exec < $INPUTFILE
a1=start
while [ "$a1" != "" ] ; do
        read a1 
    if [ "$a1" != "" ] ; then
        
        # Configure Varibles
        # This is probably the section you will want to modify
        printer_name=`echo ${a1} | awk '{ print $1}'`
        file_name=${printer_name}
        printer_description=`echo ${a1} | awk -F "${printer_name} " '{ print $2}'`
        
        # Generate the Printer Setup File
        generate_printersetup_file
        if [ $? == 0 ] ; then 
            (( sucess++ ))
        fi
        
        # increment run
        (( run++ ))				
    fi
done
    
    
# Final reporting of the PSF generation
    
echo ""   
echo "Parsed $run lines from input file"
echo "Sucessfully Generated $sucess printer setup files."
echo ""



exit 0
