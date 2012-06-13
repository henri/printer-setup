##########################################
#   Set Default Printer Package System   #
##########################################

This directory contains tools to assist you with building a packages and images for installation on OS X.

This directory may be ignored if you do not want to make PrinterSetup packages or images. 

Summary of scripts : 
--------------------

 - generate-package-for-printer-setup-file (generates a single package for a single input PSF)
 - generate-packages-for-printer-setup-files-within-a-directory (generates a package for each PSF within a directory) 
 - generate_packages_and_images.bash (generates images and packages within the provided output directory)


Basic usage : 
--------------------

Execute the 'generate_packages_and_images.bash' and provide an empty output directory. Once processing has completed you will be able to collect a variety of images and Mac OS X package installers corresponding to the PSF files within this PrinterSetup directory.


Notes : 
--------------------

At this point in time only PSF are supported for the generation of the default printer. PLF are not searched for a default printer when using the default printer options. As such, it is recommended that until this is resolved that you do not specify the building of default print queues when using PLFs. 

Kind regards,
The Printing Works Team

--
Lucid Information Systems
http://www.lucidsystems.org



