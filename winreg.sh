#!/bin/bash
function getSystemDrive () {
    umount /mnt/Windows
    disk=$1

    # Search C Drive
    part=(`fdisk -l "${disk}" | grep -o "${disk}[0-9]"`)
    targ=""
    for d in ${part[@]};do
        if [ -d "/mnt/Widnwos" ]; then
            mkdir /mnt/Windows
        fi

        ntfs-3g $d /mnt/Windows
        if [ -e "/mnt/Windows/Windows/System32/config/SYSTEM" ]; then
            ls /mnt/Windows
            targ=$d
        fi
        if [ $targ ]; then
            break;
        else
            umount /mnt/Windows
        fi
    done
    if [ $targ ]; then
        return `echo $targ|grep -o '[0-9]'`
    fi
    return 0
}

# Get Machine Name
function getRegistryValue () {
    KEYTYPE=$1
    KEYNAME=$2
    expect -c "
    spawn env LANG=C /usr/sbin/chntpw -e /mnt/Windows/Windows/System32/config/${KEYTYPE}
    set timeout 2
    expect \"^> \"
    send \"cat ${KEYNAME}\n\"
    expect \"$\"
    exit 0
    " > /var/log/reg.log & wait

    name=`cat /var/log/reg.log | sed -e '/^.\{0,2\}$/d'|tail -n 1`
    echo $name
}
