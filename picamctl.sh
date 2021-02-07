#!/bin/bash
# aks 02/062021
portnamepat="tty.usbmodem*" #typical for showmewebcam
#portnamepat="tty.*"
runphotobooth = "true"

reset
clear
    echo "======================================================================"
    echo "                             picamctl                                 "
    echo "======================================================================"       
    echo "  This script looks for a serial port device that could be the        "  
    echo "  Showmewebcam USB webcam device. It will connect to the device, log  "
    echo "  in as root and then run the camera settings control utility.        " 
    echo "----------------------------------------------------------------------"
    echo "  Looking for a device like: /dev/$portnamepat                        "

    serialportlist=$(ls -a /dev/$portnamepat 2> /dev/null)
    countofserialportslist=$(ls -a /dev/$portnamepat  2> /dev/null | wc -l)

    echo "  $(expr $countofserialportslist + 0) such ports found."

# terminates all the ort screen sessions.
    screen -ls | grep Attached | cut -d. -f1 | awk '{print $1}' | xargs kill
    screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill

if [ $countofserialportslist = 0 ]; then
    echo ""
    echo "  None found! Got that USB thing plugged in or waited the 10 seconds"
    echo "  needed for booting up? Run this again when it is ready."
    echo "======================================================================"
    echo ""
    exit 
else
    echo " " $serialportlist 2> /dev/null
    # changes item space separator to a newline and returns tail item
    piusbwebcamport=$(echo "$serialportlist" | tr ' ' '\n' | tail -1)
    echo "  Assuming this last one => " $piusbwebcamport
    echo "======================================================================"
    while read -r -s -p "Press any key when ready. (ESC key quits)" -n1 key 
        do
            # check for escape key
            if [[ $key == $'\e' ]]; then
                echo ""
                echo "Ok, Bye"
                exit 0
            else
                break   
            fi
        done
    echo ""
    echo "Now establishing serial connection using 'screen' ..."
    if [ "$runphotobooth" != "true" ]; then
        # -g causes application to open in background 
        # https://scriptingosx.com/2017/02/the-macos-open-command/
        open -g -a "Photo Booth"
    fi

    # For some reason screen stuffing the user, password and camera-ctl to
    # a detached screen does not work without the target screen having been
    # attached at some point. Here the nest screen into a spawner screen
    # trick is used to get around that.   
    screen -dmS spawner
    screen -S spawner -X screen screen -dR thispicam $piusbwebcamport 115200
    sleep 0.1
    screen -S thispicam -X detach
    screen -S thispicam -X stuff $'root\n'
    sleep 0.1
    screen -S thispicam -X stuff $'root\n'
    sleep 0.1
    screen -S thispicam -X stuff $'camera-ctl\n'
    screen -r thispicam
fi