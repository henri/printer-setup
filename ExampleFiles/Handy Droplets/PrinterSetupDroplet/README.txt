The PrinterSetup Droplet allows you to use printer setup on to setup printers without the need to install printer setup onto the host system, this script has been tested on Mac OS 10.3 and Mac OS 10.4.

The PrinterSetup Droplet is ideal if you are deploying printers on a small scale. Although PrinterSetup installation on the host system is not required, you will still need to install PrinterSetup somewhere. PrinterSetup can be installed on a USB flash drive, or on a server accessible via the network.

Finally, if you decide to move the PrinterSetup Droplet from the default location you will need to edit one line in the PrinterSetup Droplet so it is able to find the PrinterSetup installation.

        (1) Open the Droplet with ScriptEditor : /Applications/AppleScript/Script Editor.app
        
        (2) Change the line shown below so the path within the quotation marks is the path to PrinterSetup for your setup.
        
            -- this will need to be changed depending upon where the printer setup folder is located for your installation
            set printerSetup_folder to "/Volumes/tech2/Printing & Fonts/PrinterSetup"
            
Now you can drop PSF's (printer setup files) onto the droplet. The droplet will setup a link to this PSF. Then it will run PrinterSetup. Next it removes the link, and finally opens the Printer Setup Utility. So you can check that the printer has been created.

Please note that this version of the Printer Setup Droplet will not run the post and pre hook scripts. If you require the functionality provided by these scripts you will need to edit the script and remove the command line flag which will disables the scripting subsystem.

In this folder there is also a shell script which does a similar job. However, it will require configuration before it may be used.

Good Luck, if you make this more useable, please submit patches back to http://www.lucidsystems.org.


