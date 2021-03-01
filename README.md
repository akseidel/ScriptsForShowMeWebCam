# ScriptsForShowMeWebCam

## picamctl.sh

The USB Raspberry Pi Zero showmewebcam is a plug-in-and-it-works webcam system whereas running the showmewebcam camera settings utility program, "camera-ctl", requires arcane technical skills to perform a multistep process. The **picamctl.sh** script performs all the required steps for you. As of this writing, **picamctl.sh** works for Mac OS X systems and works on a Raspberry Pi 4 running a Raspbian system and Ubuntu 20.04. It is likely to work in other Linux systems with no or some fixing.  

**picamctl.sh** automates the following:

* Determines the USB connected Raspberry Pi Zero showmewebcam's most likely serial device port name.
* Establishes a 115200 baud serial connection to the Raspberry Pi Zero showmewebcam in a screen session.
* Logs into the Raspberry Pi Zero showmewebcam as root.
* Starts the showmewebcam system's "camera-ctl" utility.

**picamctl.sh** also does the following:

* Starts Apple's **PhotoBooth** application. On Linux systems the **Webcamoid** application is started. Alter or remove that application starting feature from the script as needed or use the **-c** command argument explained later on. **PhotoBooth** comes preloaded on Apple computers. On Linux systems **Webcamoid** will need to be installed. **picamctl.sh** expects to find **Webcamoid** at **/usr/bin/webcamoid** on the Linux computer.
* Removes all existing Attached and Detached screen instances. Unused screen instances are typically left over by the method used to run "camera-ctl".
* The Linux implementation in **picamctl.sh** runs the webcam using application, for example **Webcamoid**, in an additional Detached screen. It does not exempt that Detached screen when it removes existing Attached and Detached screen instances. Therefore unlike the Apple OS X implementation, an already running webcam using application, for example **Webcamoid**, previously started by **picamctl.sh** will close and then be restarted.
* Checks for the required **screen** command existence. Some systems may not have **screen** installed. **picamctl.sh** stops and advises regarding the missing **screen** installation.
* In Linux **screen** requires root user rights. **picamctl.sh** stops and advises regarding how to run **picamctl.sh** as root user.

### How To Use

**picamctl.sh** is made for use on an Apple OS X computer. It is written to comply with sh shell standards.  Look online to explain how to perform any unfamiliar step mentioned below.

* Download **picamctl.sh** to your computer and move the file to the directory where you want it stored.
* In a Terminal session, change to the directory that holds **picamctl.sh**. Then mark **picamctl.sh** as executable using the command **chmod +x picamctl.sh**.
* If on a Linux system, install **Webcamoid** or your choice of USB webcam video using application.

### Starting Up

* Open a Terminal window.
* In the Terminal window change the current directory to be the one where you copied **picamctl.sh**.
* Plug the Raspberry Pi Zero showmewebcam webcam system USB cable into the computer.
* In the Terminal window type in "**./picamctl.sh**" or "**sh ./picamctl.sh**". On Linux systems type in "**sudo ./picamctl.sh**" or "**sudo sh ./picamctl.sh**" to run as root user. The system will prompt for the root user password.
* If showmewebcam has yet to finish booting, **picamctl.sh** will make a number of attempts to check for a late startup.

<p align="center">
  <img src="graphics/picamctl_waiting.png?raw=true" alt="picamctl waiting"/>
</p>

* The Terminal window should now be logged into the Raspberry Pi Zero showmewebcam system and showing the camera control interface.

<p align="center">
  <img src="graphics/cameractl_image.png?raw=true" alt="camera-ctl running"/>
</p>

* On Apple OS X systems the application **PhotoBooth** will start. On Linus systems the application **Webcamoid** will start.
* The following 2/23/2021 problem description does not apply when using the automatic login build for showmewebcam. There remains a minor problem when using the **-m** manual login mode.  
* As of this writing, 2/23/2021, there is a problem with the **showmewebcam** system that messes up the serial connection login process when the login occurs after booting. The login process becomes interrupted when this happens. Instead of seeing the camera control as expected one sees a garbled login process. There are two ways to recover from this:

  * One method is to terminate, i.e. quit, the **Terminal** session. At this point the **Pi Zero showmewebcam** is still booted. That fact is critical because the intent here is to avoid the just booted condition. Now start a new **Terminal** session and repeat the "**./picamctl.sh**" or "**sh ./picamctl.sh**". The camera control screen you will see may not be 100% intact. If that is the case then press the letter q to quit it. Then enter in "**camera-ctl**" to restart the camera control program.
  * The second method is simply to manually login to the **Pi Zero** and start the **camera-ctl** program. The awkward aspect to this method is that the precise state of the garbled login procedure is not consistent. The user name might have been improperly entered, the password might have been improperly entered or both conditions might have occurred. The **Pi Zero** will restart the login procedure, but there is a delay before that happens. Therefore it is not always evident the **Pi Zero** is waiting for a Return keypress to finish an entry or that it is time for one to wait out the automatic re-login delay. Unless you know exactly what state the login procedure is in the tactic is to enter random keypresses followed by return keypresses until you recognize the re-login state happening. Then enter "**root**" as the user. Enter "**root**" for the password. Enter "**camera-ctl**" to start the camera control.
  * The one thing you do not want to do when faced with the garbled login condition is to restart the **Pi Zero** by unplugging and replugging the USB cable. Doing that just puts the **Pi Zero** back into the newly booted state.

### Shut Down

* Unplug the Raspberry Pi Zero showmewebcam webcam system USB cable from the computer. Unplugging the device powers off the Pi Zero. This is an important step that you might eventually learn the hard way because just terminating the Terminal session without shutting down the Pi Zero leaves the Pi Zero either still running the camera control utility or running in some other unexpected state. Running **picamctl.sh** under those circumstances results in a confused looking screen session.
* Close out the Terminal window.

### Runtime Arguments

* **-d**: When **picamctl.sh** is started using the argument **-d**, for example "**./picamctl.sh  -d**", the script halts after printing out diagnostic information. This mode can be used for troubleshooting the serial device name it has selected to use for the connection. The **-d** argument diagnostic mode halts the script before the script repeatedly tries to see the showmewebcam device complete its booting process. Perform subsequent "**./picamctl.sh  -d**" runs to observe the booting process yourself.
* **-m**: Do not automatically log in. The log in must be done manually.
* **-nc**: Do not run the client application.
* **-c**: Set the client application to be the next argument text. For example **./picamctl -c "Quicktime player"** sets the client application to **Quicktime player** on typical Apple OS X systems. The client application name argument might need to be a full path name such as **"/usr/bin/webcamoid"** for Linux systems.
* **-h**: Show help regarding runtime arguments.

### Details, Comments, Troubleshooting

* picamctl.sh is composed for sh.
* In this script the remote logging into the Raspberry Pi Zero happens in a detached terminal screen session where the user name "root", the password "root" and the application name "camera-ctl" are passed into the detached screen. Finally, the detached screen is attached, thus making it visible. The timing sometimes does not happen as it should. The result can be an improper connection. Unplug the USB connection and then repeat the startup procedure.
* The quality of the USB cable used for connecting the Raspberry Pi Zero had been found to influence whether or not the Pi Zero serial connection is made or sustained. The host computer also plays into this issue. For example the cheap noodle USB cable functions for connecting to an Apple MacBook but fails when connecting to a Raspberry Pi 4. When used with the Raspberry Pi 4 the serial device would register at the Pi 4 perhaps 1 out of 20 times and would always vanish within 5 seconds as is the voltage drop in the very tiny wires used in the cheap cable dropped below a threshold as the Pi Zero started a process drawing slightly more electrical power.
* For the situation when rerunning **picamctl.sh** is necessary to deal with an unrefreshed "camera-ctl" screen view, unplugging the USB cable is not necessary. The showmewebcam system can remain booted. Instead, press q in the "camera-ctl" interface. This quits the running "camera-ctl" instance. You should see the # prompt at the lower left corner. Depending on the computer OS and how you are starting **picamctl.sh**, you may or may not need to dispose of the unused screen session when you rerun **picamctl.sh** to get a properly running "camera-ctl" screen view.
* Running **picamctl.sh** is possible by double clicking the file in file browsers in both Apple OS X systems and in Linux systems. In Linux systems choose "Execute in Terminal" when prompted. In Apple OS X systems you need to first set the OS to open *.sh files in the Terminal application or other similar applications such as iTerm2. This is done by right clicking on **picamctl.sh** in the Finder and following the necessary selections under **Open With**. This might require using the **Other...** selection followed by changing the **Enable** selector to **All Applications**.

### Showmewebcam is found at

<https://github.com/showmewebcam/showmewebcam>
