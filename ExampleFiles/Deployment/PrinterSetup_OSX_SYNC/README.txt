##############################
#    Print Queue Deployment  #
##############################

This directory contains tools to help you aid in your deployment of printers.



##
## PrinterSetup_OSX_SYNC
## 

Some scripts to aid with download and upload of PrinterSetup. These scripts may be used on other operating systems.

Some for rsync options may require modification for versions of Mac OS X prior to 10.4.x and also other operating systems

The AppleScripts will require an Mac OS X to run. 
10.4.x or later is reccomended.

This PrinterSetup Sync system is extremely experimental. 

The first step is to configure a PrinterSetup server. This can be pretty much any network accessible machine which has rsync and SSH enabled.

You will need to edit the configuration files in the 'configurations' directory.
 
Once configured, there are a couple of AppleScripts which will allow you to upload and download scripts from the server.

There is also a script called 'update_printers_background' which you may want to load into a scheduler. Rather than calling the 'download.bash' script from within a the PrinterSetup pre-script.




Kind reagrds,
The Printing Works Team

--
Lucid Information Systems
http://www.lucidsystems.org



