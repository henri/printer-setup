# Printer Setup #

PrinterSetup is an open source (GNU GPL) cups print queue management system. 

Excellent for CUPS Print queue deployment on BYOD, lab, server deployments and more. 

PrinterSetup supports CUPS print queue management on BSD, GNU/LINUX and macOS operating systems.

Printer setup allows you to define "Printer Setup Files". Each PSF, defines the configuration of a CUPS print queue. You also have the ability to define "Printer List Files". A PLF contains a list of printers, to be setup.

  - [Download][1] the latest build version (.zip). 
  - [PrinterSetup screen casts][2].
  - [PrinterSetup presentation][3].
  - [PrinterSetup discussion mailing list][4]. (This is now an archive)

  
Comments and suggestions regarding the PrinterSetup project are welcomed.

[1]: http://www.lucidsystems.tk/download/printersetup/
[2]: http://www.lucidsystems.tk/tools/printingworks/printersetup/screencasts/
[3]: http://www.lucidsystems.tk/download/printersetup/presentation/
[4]: http://www.lucidsystems.tk/tools/printingworks/printersetup/lists/discuss/
[5]: http://www.lucidsystems.tk/tools/printingworks/printersetup/SystemOverview.png

Additional documentation and tutorials are welcome, particularly those which cover intergratation of PrinterSetup with different deployment and direcotry management systems. It is also nice to hear stories of how you are using PrinterSetup for management of your print queues.

PrinterSetup offers extream flexibility in terms of print queue deployment. The exampels directory offers various setups and we are open to pull requests to further grow the included library. At present, you have support for the driver package installation on MacOS, removal or addition of print queues beasted on system events such as the network names to which a system is connected or even the specific MAC addresses of the base station to which a system is connected. There is even a basic script to export a batch file to allow print queue setup on Microsoft Windows operating clients. Powerful tools for automatic print queue clean up after specific dates or when an SSID has not been seen in a while. The examples folder offers a place to get your imagination started. 

