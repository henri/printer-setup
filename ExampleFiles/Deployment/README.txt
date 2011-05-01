##############################
#    Print Queue Deployment  #
##############################

This directory contains tools to help you aid in your deployment of printers.


##
## PrinterSetup_OSX_UPDATE
## 

You will need Mac OS 10.5 and Xcode 3.0 in order to build the packages. However, to the pacakges created should be compatible with earlier version of Mac OS X.

This is a collection of scripts to help you build Apple Packages which will automatically check with server(s) for updates to print queues or drivers.


##
## PrinterSetup_OSX_SYNC
## 

This is a collection of scripts to syncronize a printersetup directory with a server manually or automatically. 

In addition, there is an option to update the local files and then push these changes to the server. 

Thus, when other clients pull down these changes they will be the new changes you just uploaded.



##
## PrinterSetup_OSX_DYNAMIC
## 

You will need Mac OS 10.5 and Xcode 3.0 in order to build the packages. However, to the pacakges created should be compatible with earlier version of Mac OS X.

This is a collection of scripts to allow execution of a dynamic script which may then trigger PrinterSetup based upon system configuration changes.

The idea behind this, is that your printers may change based upon various factors in the dynamic script. The example script includes the ability to make changes to printers based upon the wireless network name to which the system is currently connected.

Thus, when other clients pull down these changes they will be the new changes you just uploaded.



 
 

##
## PrinterSetup_OSX_PACKAGE
## 

The PrinterSetupPackage tools are very much a work in progress. Feed back and ideas are welcome, with regards how to improve this aspect of PrinterSetup.

You will need Mac OS 10.5 and Xcode 3.0 in order to build the packages. However, to the pacakges created should be compatible with earlier version of Mac OS X.

This is a collection of scripts to help you build Apple Packages for deployment of printers to OSX machines.

PrinterSetup Packages should be able to be deployed on clients running Mac OS 10.3 or greater.

In order to generate the PrinterSetup packages for deployment your build system is required to have both Mac OS 10.5 or later and Xcode 3.0 or later installed.

The folder "PrinterSetup_OSX_PACKAGE" contains example files to assist with the deployment of print queues and printer derivers by utilitsing the Apple pacakge system. 

This system requires the installation of Apples PackageMaker.  It is installed with the default installation of Apples DeveloperTools (Xcode 3.0 or later), which is availible from  http://developer.apple.com

Any PSF's or PSL's links which have the room number configured to the word "OSXPACKAGE" will be deployed if you build packages using this example.

Assuming you have a single print queue you wish to deploy via a package install and you have installed the apple developer tools following the instructions below will help you to build a package install which will deploy this CUPS print queue.

    (1) Creat the PSF.
    (2) Place the PrinterSetup file within the "PrinterSetupFiles" directory. 
    (3) Configuring a symbolic link to this PSF within the "PrinterSetupLinks" direcotry.
    (4) Ensure the link name is something like "PSF-PACKAGE-070" (the number is the order of installation)
    (5) Open the "PrinterSetup_OSX_PACKAGE" direcotry in the finder
    (6) Double click the  PrinterSetup(.pkg) icon.
    (7) Click on the "Project" drop down menue and then select "Buld"
    (8) Select a name and locaton to save the PrinterSetup package install.
    (9) Test the PrinterSetup Package install works.
    
It is important to note that the created packages contains a complete copy of the PrinterSetup directory. Ensure that you are sure that you are happy to include all these files in your package install. Any packages within the "additional_packages" directory will also be included as packages for deploymenrt if this feature has been enabled (explained below). 

Simply enable this feaute and then place any Apple packages for printer drivers or other printing related insallers into this directory before you build the your PrinterSetup OS X installer package. 

To add print drivers or other tools to the install you have two options outlined below.
(1) Add them manually PrinterSetup using Apples package builder before you build for deployment. 
(2) Downlaod InstallPKG from http://www.lucidsystems.org and place the "InstallPKG.pgk" into the "helper_packages" directory. If the "InstallPKG.pgk" installer is availible then any other packages located within the "additional_packages" directory will be installed. 

There are apple scripts provided to automate the downlaod and installation of "InstallPKG" and the InstallPKG uninstall script, which if present will remove InstallPKG from the system if it was not previusly insalled. With any luck this script will work behind a proxy. Althought this has not been tested. If for some reason it is not working, then manually download and install "InstallPKG.pkg" into the "helper_packages" directory in order to enable the automatic installation of packages located withint he "additional_packaged" directory.
    
The "PrinterSetup_OSX_PACKAGE" direcrtory is the second incarnation of such an example. There are plans to improve this system to offer more control to both administrators (who build packages) and also the end users (who deploy print queues with these packages).

We look forward to your feed back so we can continue to improve this system.

Finally the default action of the script will disable all print queue publishing. To enable this simply modify the PrinterSetupPackage.sh script to suit your requirments.

Kind reagrds,
The Printing Works Team

--
Lucid Information Systems
http://www.lucidsystems.org



