#!/bin/sh
# akseidel 02/06/21 02/10/21
# A script automating the steps to run showmewencam's "camera-ctl".
# Script will print diagnostic information and halt when run with an argument d.

# init per the operating system
# portnamepat is the serial device port name pattern
# The client is an application you want this script to also run.
# Edit this section accordingly for your computer.
initperos(){
    case "$(uname -s)" in
    Darwin)
        portnamepat="tty.usbmodem" 
        #portnamepat="tty."
        runtheclient="true"
        clientname="Photo Booth"
        ;;
    Linux)
        portnamepat="ttyACM"
        #portnamepat="tty*"
        runtheclient="true"
        #clientname="???"
        ;;
    #CYGWIN*|MINGW32*|MSYS*|MINGW*)
    #    ;;
    *)
        #prinf "Other OS\n"
        portnamepat="ttyACM"
        #portnamepat="tty*"
        runtheclient="false"
        #clientname="???"
        ;;
esac
}

# initial cleanup
initclean(){
    reset
    clear
    # terminates all the ort screen sessions.
    screen -ls | grep Attached | cut -d. -f1 | awk '{print $1}' | xargs kill
    screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill
}

# run the client application
runclient(){
    if [ "$runtheclient" = "true" ]; then
        # -g causes application to open in background 
        # https://scriptingosx.com/2017/02/the-macos-open-command/
        open -g -a "$clientname"
    fi
}

# start the screen session
doscreensession(){
    printf "\nNow establishing serial connection using 'screen' ...\n"
    # For some reason screen stuffing the user, password and camera-ctl to
    # a detached target screen does not work without the target screen having
    # been attached at some point. Here the nest screen into a spawner screen
    # trick is used to get around that.   
    screen -dmS spawner
    screen -S spawner -X screen screen -dR thispicam "$piusbwebcamport" 115200
    sleep 0.5
    screen -S thispicam -X detach
    sleep 0.2
    #screen -S thispicam -X stuff $'root\n'
    screen -S thispicam -X stuff "$(printf '%b_' 'root\n')"
    sleep 0.2
    #screen -S thispicam -X stuff $'root\n'
    screen -S thispicam -X stuff "$(printf '%b ' 'root\n')"
    sleep 0.2
    #screen -S thispicam -X stuff $'camera-ctl\n'
    screen -S thispicam -X stuff "$(printf '%b_' 'camera-ctl\n')"
    sleep 0.2
    screen -r thispicam
}

# show intro text
showintro(){
    printf "======================================================================\n"   
    printf "                             picamctl                                 \n"
    printf "======================================================================\n"       
    printf "  This script looks for a serial port device that could be the        \n"  
    printf "  Showmewebcam USB webcam device. It will connect to the device, log  \n"
    printf "  in as root and then run the camera settings control utility.        \n" 
    printf "======================================================================\n"
    printf "  Looking for a device like: /dev/%s*\n" "$portnamepat"
}

# collect the port names
getportnames(){
    serialportlist=$(find /dev/"$portnamepat"*) 2> /dev/null
    countofserialportslist=$( find /dev/"$portnamepat"*   | wc -l) 2> /dev/null
}

# report port qty
rptportqty(){
    printf "  %s such ports found.\n" "$((countofserialportslist+0))"
}

# report ports
rptportlist(){
    printf "  %s\n" "$serialportlist" 2> /dev/null
}

# set port to use and show it
dosetport(){
    # changes item space separator to a newline and returns tail item
    #piusbwebcamport=$(echo "$serialportlist" | tr ' ' '\n' | tail -1)
    piusbwebcamport=$(printf "%s" "$serialportlist" | tr ' ' '\n' | tail -1)
    printf "  Assuming this last one => %s\n" "$piusbwebcamport"
    printf "======================================================================\n"
}

# debug dump when run with argument d
option2debugexit(){
    if [ -n "$1" ]
    then
        if [ "$1" = 'd' ]; then
            printf "\nDiagnostic stop.\n"
            printf "OS: %s\n" "$(uname -s)"
            printf "runtheclient: %s\n" "$runtheclient"
            printf "clientname: %s\n" "$clientname"
            printf "portnamepat: %s\n" "$portnamepat"
            printf "searching: /dev/%s*\n" "$portnamepat"
            printf "serialportlist: %s\n" "$serialportlist"
            printf "countofserialportist: %s\n" "$((countofserialportslist+0))"
            printf "piusnwebcamport: %s\n" "$piusbwebcamport"
            printf "Halted\n"
            exit 0
        fi
    fi
}

# checkboot status
checkbootstatus(){
while [ "$countofserialportslist" -eq 0 ]; do
        printf "\n  None found! Got that USB thing plugged in or waited the 10 seconds\n"
        printf "  needed for booting up? Periodic boot checking is now happening.\n"
        printf "======================================================================\n\n"
        chk=1
        chklim=12
        while [ $chk -le $chklim ]
            do
                printf "  Checking for a ready showmewebcam. Attempt %s out of %s ... \r" "$chk" "$chklim"
                getportnames
                if [ ! "$countofserialportslist" -eq 0 ]; then
                    printf "\n  Bingo! Looks like showmewebcam is now ready.\n"
                    break 2
                fi
                chk=$(( chk + 1 ))
                sleep 2
            done
        printf "  Run this again when the camera is ready.                             \n\n"
        exit 
    done
}

# program section

initclean
initperos
showintro
getportnames
rptportqty
option2debugexit "$1"  
checkbootstatus 
rptportlist
dosetport
#option2debugexit "$1"
runclient
doscreensession

# end