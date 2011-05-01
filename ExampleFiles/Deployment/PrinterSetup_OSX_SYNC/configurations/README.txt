Printer Setup Sync Configuration Directory Read Me
==================================================


This configuration directory contains the server keys and verification.

//////////////////
//   Overview   //
//////////////////

The following files should be included in this directory.


excludes_download.txt
excludes_upload.txt
server_verification
configuration.conf
server_key

The purpose of each of these files is briefly outlined below.



//////////////////
//   Details    //
//////////////////

server_verification
-------------------
This is an SSH known hosts file. When connecting to this server It allows the system to confirm that it is in fact talking to the server. 

On a default Mac OS X system once you have manually connected to PrinterSetup Update server via SSH a line should be added to your '~/.ssh/knowen_hosts' file. This line should start with your PrinterSetup Update servers address and a finger print. 

This line may be copied into the 'server_verification' file so that when an automatic connection is made to the server. The server is confirmed to be the same server.

If your machine has not been imaged, then you may prefer to modify the upload.bash and download.bash scripts and use the standard ~/.ssh/knowen_hosts file for server verification.



server_key
----------
This is a private key which permits access via SSH to the servers PrinterSetup Sync repository. 

It is recommended that the public key which is associated with this private key should be set on your server to restrict access to the PrinterSetup Update server. In particular when you are using the server_key to access the server you will only require the ability to download the update from the server from the 'Remote Path' variable which is listed within the server_settings file using rsync.

It is recommended that you configure all other access to the PrinterSetup Update server using this key be prohibited. 


configuration.conf
----------------
Open this up there are various options which will need to be configured. Hopefully they are self explanitory. If not then let us know.


excludes_download.txt
----------------
Any regular expressions listed in this file will be exluded from the rsync download from the server. Read the rsync man page for further details.


excludes_upload.txt
----------------
Any regular expressions listed in this file will be exluded from the rsync upload from the server. Read the rsync man page for further details.




//////////////////
//   Support    //
//////////////////


For Assistance with setting up a PrinterSetup Update Server or configuration, please contact the PrinterSetup team





Kind reagrds,
The Printing Works Team

--
Lucid Information Systems
http://www.lucidsystems.org
