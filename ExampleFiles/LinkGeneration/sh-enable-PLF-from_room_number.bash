#!/bin/bash

# SetupLink to Printer List if it Matches a Room Number
# Copyright 2006, Henri Shustak 
# Licenced under the GNU GPL
#
#  Basic Example Script Sets up links to PSL files.
#

function make_those_links {
        
        
        # Finds items to Create links for PSL based upon the name matching the
        # room number. Exlude Files that start with period.
        
        SEARCHDIR="$printer_list_folder"
        SEARCHDIR_FILECOUNT=`ls "${SEARCHDIR}/" | grep -v --regexp="^\." | wc -l | awk '{ print $1 }'`
        
        if [ -d "${SEARCHDIR}" ] && [ $SEARCHDIR_FILECOUNT -gt 0 ] ; then
            
            echo "     Creating PLF Links for room ${roomNumber}..." | tee -ai "$printer_setup_log"
            
            for item in "${SEARCHDIR}/"*${roomNumber}*; do
            
                item_name=`basename "$item"`
                                            
                if [ -r "${item}" ]; then
                
                	
                    echo -n "     " ; logger -s -t SetupRoomNumber -p user.info Linking ${item}... 1>&2
                    link_destination="${printer_setup_links_folder}/PLF-${item_name}"
                    if ! [ -f "${link_destination}" ] ; then
                    
                    	ln -s "${item}" "${link_destination}"
                    
						# Check that worked
						exit_value=$?
						if [ $exit_value -ne 0 ]; then	
							echo -n "    " ; logger -s -t SetupPrinters -p user.info ${item} failed! 1>&2
							echo "      ERROR! : Linking {item_name}" | tee -ai "$printer_setup_log"
						fi
					fi
                    
                else
                    echo "       WARNING! : PLF is not readable or is not availile and has been skipped" | tee -ai "$printer_setup_log"
                    echo "                  PLF File Path : ${item}"
                fi
            done
        fi
    
}


make_those_links

exit 0
