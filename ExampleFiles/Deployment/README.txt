##############################
#    Print Queue Deployment  #
##############################

This directory contains tools to help you aid in your deployment of printers.


##
## PrinterSetup_OSX_UPDATE
## 

You will need Mac OS 10.5 and Xcode 3.0 in order to build the packages. However, to the packages created should be compatible with earlier version of Mac OS X.

This is a collection of scripts to help you build Apple Packages which will automatically check with server(s) for updates to print queues or drivers.


##
## PrinterSetup_OSX_SYNC
## 

This is a collection of scripts to synchronise a printersetup directory with a server manually or automatically. 

In addition, there is an option to update the local files and then push these changes to the server. 

Thus, when other clients pull down these changes they will be the new changes you just uploaded.



##
## PrinterSetup_OSX_DYNAMIC
## 

You will need Mac OS 10.5 and Xcode 3.0 in order to build the packages. However, to the packages created should be compatible with earlier version of Mac OS X.

This is a collection of scripts to allow execution of a dynamic script which may then trigger PrinterSetup based upon system configuration changes.

The idea behind this, is that your printers may change based upon various factors in the dynamic script. The example script includes the ability to make changes to printers based upon the wireless network name to which the system is currently connected.

Thus, when other clients pull down these changes they will be the new changes you just uploaded.



 
 

##
## PrinterSetup_OSX_PACKAGE
## 

The PrinterSetupPackage tools are very much a work in progress. Feed back and ideas are welcome, with regards how to improve this aspect of PrinterSetup.

You will need Mac OS 10.5 and Xcode 3.0 in order to build the packages. However, to the packages created should be compatible with earlier version of Mac OS X.

This is a collection of scripts to help you build Apple Packages for deployment of printers to OSX machines.

PrinterSetup Packages should be able to be deployed on clients running Mac OS 10.3 or greater.

In order to generate the PrinterSetup packages for deployment your build system is required to have both Mac OS 10.5 or later and Xcode 3.0 or later installed.

The folder "PrinterSetup_OSX_PACKAGE" contains example files to assist with the deployment of print queues and printer derivers by utilising the Apple package system. 

This system requires the installation of Apples PackageMaker.  It is installed with the default installation of Apples DeveloperTools (Xcode 3.0 or later), which is available from  http://developer.apple.com

One later systems such as Mac OS 10.9 and and 10.10 you will need to load PackageMaker (which is now depreciated) into the /Applications/ folder. PackageMaker may be obtained from <https://developer.apple.com/downloads/index.action?name=PackageMaker>. However, note, that you will require an Apple Developer ID in order to download the auxiliary tools.

Any PSF's or PSL's links which have the room number configured to the word "OSXPACKAGE" will be deployed if you build packages using this example.

Assuming you have a single print queue you wish to deploy via a package install and you have installed the apple developer / auxiliary tools (such as /Applications/PackageMaker.app) following the instructions below will help you to build a package install which will deploy this CUPS print queue.

    (1) Create the PSF. Note, that if you already have the CUPS queue configured,
	there are example scripts bundled within PrinterSetup to make generating PSF files as simple as possible.
    (2) Place the PrinterSetup file within the "PrinterSetupFiles" directory. 
    (3) Configuring a symbolic link to this PSF within the "PrinterSetupLinks" directory.
    (4) Ensure the link name is something like "PSF-PACKAGE-070" (the number is the order of installation)
    (5) Open the "PrinterSetup_OSX_PACKAGE" directory in the finder
    (6) Double click the  PrinterSetup(.pkg) icon.
    (7) Click on the "Project" drop down menu and then select “Build”
    (8) Select a name and location to save the PrinterSetup package to install.
    (9) Test the PrinterSetup Package install works.
    
It is important to note that the created packages contains a complete copy of the PrinterSetup directory. Ensure that you are sure that you are happy to include all these files in your package install. Any packages within the "additional_packages" directory will also be included as packages for deployment if this feature has been enabled (explained below). 

Also, note that there are helper scripts which are able to assist with symbolic link setup. These are located within the “link_creation_scripts” directory.

Simply enable this feature and then place any Apple packages for printer drivers or other printing related installers into this directory before you build the your PrinterSetup OS X installer package. 

To add print drivers or other tools to the install you have two options outlined below.
(1) Add them manually PrinterSetup using Apples package builder before you build for deployment. 
(2) Download InstallPKG from http://www.lucidsystems.org and place the "InstallPKG.pgk" into the "helper_packages" directory. If the "InstallPKG.pgk" installer is available then any other packages located within the "additional_packages" directory will be installed. 

There are apple scripts provided to automate the download and installation of "InstallPKG" and the InstallPKG uninstall script, which if present will remove InstallPKG from the system if it was not previously installed. With any luck this script will work behind a proxy. Although this has not been tested. If for some reason it is not working, then manually download and install "InstallPKG.pkg" into the "helper_packages" directory in order to enable the automatic installation of packages located within the "additional_packaged" directory.
    
The "PrinterSetup_OSX_PACKAGE" directory is the second incarnation of such an example. There are plans to improve this system to offer more control to both administrators (who build packages) and also the end users (who deploy print queues with these packages).

We look forward to your feed back so we can continue to improve this system.

Finally the default action of the script will disable all print queue publishing. To enable this simply modify the PrinterSetupPackage.sh script to suit your requirements.

Kind regards,
The Printing Works Team

--
Lucid Information Systems
http://www.lucidsystems.org



