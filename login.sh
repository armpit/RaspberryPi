#!/bin/bash
# Simple login dialog.

self=$(readlink -f "$0")

USERNAME=$(whiptail --nocancel --title "Login" --inputbox "Username:" 10 60 3>&1 1>&2 2>&3)

id -u $USERNAME > /dev/null
if [ $? -ne 0 ]
then
    exec $self
else
    PASSWD=$(whiptail --nocancel --title "Login" --passwordbox "Password:" 10 60 3>&1 1>&2 2>&3)
    export PASSWD
    ORIGPASS=`sudo grep -w "$USERNAME" /etc/shadow | cut -d: -f2`
    export ALGO=`echo $ORIGPASS | cut -d'$' -f2`
    export SALT=`echo $ORIGPASS | cut -d'$' -f3`
    GENPASS=$(perl -le 'print crypt("$ENV{PASSWD}","\$$ENV{ALGO}\$$ENV{SALT}\$")')
    if [ "$GENPASS" == "$ORIGPASS" ]
    then
	clear
	exit 0
    else
	exec $self
    fi
fi
