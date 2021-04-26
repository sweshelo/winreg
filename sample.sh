#!/bin/bash
error=0

#checking require programs
if [ ! "`whereis fdisk`" ]; then
    echo "undified 'fdisk'."
    error=1
fi

if [ ! "`whereis ntfs-3g`" ]; then
    echo "undifined 'ntfs-3g'."
    echo "try 'apt install ntfs-3g'."
    error=1
fi

if [ ! "`whereis chntpw`" ]; then
    echo "undifined 'chntpw'."
    echo "try 'apt install chntpw'."
    error=1
fi

if [ $error -ne 0 ]; then
    echo "Some error occured."
fi


# -- load
source ./winreg.sh

# 1st : mount NTFS partition on "/mnt/Windows"
# If you don't know C drive partition, use 'getSystemDrive'.
# That search NTFS partition and mount on '/mnt/Windows'
# device name is required this function.

DEVICE='/dev/sda'
getSystemDrive $DEVICE

# 2nd : use 'getRegistryValue' to get any registry value.
# Backslashes (\) must be triple-escaped because backslashes replace 2 times.

# ex) get ProductName
REG="SYSTEM"
KEY="Microsoft\\\\\\Windows NT\\\\\\CurrentVersion\\\\\\ProductName"

getRegistryValue $REG $KEY
