########################################
#    Print Queue OS X DYNAMIC SYSTEM   #
########################################

This is the second revision of a system to dynamically modify print queues
based upon a script which you configure for your deployment.

The idea is that using this dynamic system, you are able to have the 
default printer or in fact the managed available printers
change as you move between wireless access points or make other network
related alterations to you system.

For example if a change is detected with network by the LaunchAgent
com.yourdomain.PrinterSetupDynamic.plist then the script for your 
this domain will be executed. This script may then run printer setup or perform
other operations.

It is a way to configure a hook for establishing dynamic changes to the printers
on the system, based upon factors which you decide are appropritate.

Abig thanks to Onne Gorter, who put together LocationChanger.
Details on LocationChanger are available from the following site : 
http://tech.inhelsinki.nl/locationchanger/

LocationChanger was the basis for this system. A big thank for releasing
the code from LocationChanager and which is used in PrinterSetup,
under the GNU GPL.

To get started. You should edit and possible rename the following files 
and directorieswithin  within the "PrinterSetup_Dynamic_Configuration_Installer-template" 
directory :

    /scripts/printersetup_dynamic_configuration_postflight_script.bash
    /root/Library/LaunchDeamons/com.yourdomain.PrinterSetupDynamic.plist
    /etc/printersetup/configurations/printersetup-dynamic.yourdomain.com/dynamicscript
    /etc/printersetup/configurations/printersetup-dynamic.yourdomain.com
    /var/printersetup/configurations/printersetup-update-server.yourdomain.com

There is a script in the same directory as this read me called 
    "Generate_Domain_Specific_Installer_Example"
This script will effectively copy the template and modify some these files
so they are customized to your domain. You may still want to make alterations,
to the various files and directories. This is just an example. However, for
all intents and purposes this will be ready to roll out after you edit the 
following file : 
    /etc/printersetup/configurations/printersetup-dynamic.yourdomain.com/dynamicscript

If this package will also deploy your PrinterSetup configuration then you
may want to also drop this in place before you build your testing or 
deployment package. Alternatively, you may be using a update server or some
other method of deployment for PrinterSetup configurations.

Finally, once you are ready to deploy, you can use Apple PackageMaker to build 
the Apple package for testing and deployment. As always, when creating packages 
double check your permissions on any files.

Keep in mind that this system is very much in it's infancy and could well
radically change in an later release. 

Kind reagrds,
The Printing Works Team

--
Lucid Information Systems
http://www.lucidsystems.org



