#!/usr/bin/env bash
# Simple autostart menu for Retropie.

_menu=true
DIALOG_CANCEL=1
DIALOG_ESC=255
steam_cmd="/usr/local/bin/steam"
es_cmd=""

while $_menu;
do
	exec 3>&1

	selection=$(whiptail --title "Interface Select" \
		--backtitle "into the wonderfull" \
		--clear \
		--menu "Select" 20 78 3 \
		"1" "Emulation Station" \
		"2" "Steam" \
		"3" "Shell" \
		2>&1 1>&3)

	exit_status=$?

	case $exit_status in
	$DIALOG_ESC)
		_menu=false
		;;
	$DIALOG_CANCEL)
		_menu=false
		;;
	esac

	case $selection in
	0)
		_menu=false
		;;
	1)
		_menu=false
		clear
		{
		for ((i = 0 ; i <= 100 ; i+=5)); do
			sleep 0.1
			echo $i
		done
		} | whiptail --gauge "Loading Emulation Station..." 6 50 0
		
		;;
	2)
		_menu=false
		clear
		{
		for ((i = 0 ; i <= 100 ; i+=5));
		do
			sleep 0.1
			echo $i
		done
		} | whiptail --gauge "Booting into steam..." 6 50 0
		exec $steam_cmd
		;;
	3)
		_menu=false
		clear
		;;
	esac

done
