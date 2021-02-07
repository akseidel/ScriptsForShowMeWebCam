# ScriptsForShowMeWebCam

## picamctl.sh

The USB Raspberry Pi Zero showmewebcam is a plug-in-and-it-works webcam system whereas running its camera settings utility program, "camera-ctl", requires arcane technical skills to perform a multistep process. The **picamctl.sh** script performs all the required steps for you.  

**picamctl.sh** automates the following:

* Determines the USB connected Raspberry Pi Zero showmewebcam's most likely serial device port name.

* Establishes a 115200 baud serial connection to the Raspberry Pi Zero showmewebcam in a screen session.

* Logs in to the Raspberry Pi Zero showmewebcam as root.

* Starts the showmewebcam system's "camera-ctl" utility.

**picamctl.sh** also does the following:

- Starts Apple's PhotoBooth application. Alter or remove that feature from the script as needed.

- Removes all existing Attached and Detached screen instances. Unused screen instances are typically left over by the method used to run "camera-ctl". Alter or remove this feature as needed if you have other screen instances you need to remain.
