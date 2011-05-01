PrinterSetup Configuration Directory Read Me
============================================

This directory is a PrinterSetup Server configuration directory.


//////////////////
//   Overview   //
//////////////////

The following files should be included in this directory.

server_verification
server_settings
server_key

The purpose of each of these files is briefly outlined below.

The name of the directory is the address which we will be connecting for via SSH for updates.


//////////////////
//   Details    //
//////////////////

server_verification
-------------------
This is an SSH known hosts file. When connecting to this server It allows the system to confirm that it is in fact talking to the server. 

On a default Mac OS X system once you have manually connected to PrinterSetup Update server via SSH a line should be added to your '~/.ssh/knowen_hosts' file. This line should start with your PrinterSetup Update servers address and a finger print. 

This line may be copied into the 'server_verification' file so that when an automatic connection is made to the server. The server is confirmed to be the same server.



server_key
----------
This is a private key which permits access via SSH to the servers PrinterSetup Update repository. 

It is recommended that the public key which is associated with this private key should be set on your server to restrict access to the PrinterSetup Update server. In particular when you are using the server_key to access the server you will only require the ability to download the update from the server from the 'Remote Path' variable which is listed within the server_settings file using rsync.

It is recommended that you configure all other access to the PrinterSetup Update server using this key be prohibited. 



server_settings
----------------
This file specifies the settings to be assosiated with search keys as described in the file : 

/root/var/printersetup/run/additions/update_server_search_keys.config

These settings include
Remote User : The user name to use when connecting to the update server.
Remote Path : This is the path to pull down using rsync from the server.
Remote Port : This is the TCP port number to use when connecting.
Name Prefix : This is the prefix to attach to the queue_names managed by this PrinterSetup Update server.



//////////////////
//   Support    //
//////////////////


For Assistance with setting up a PrinterSetup Update Server or configuration, please contact Lucid Information Systems.
http://www.lucidsystems.org/



