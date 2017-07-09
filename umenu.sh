#!/usr/bin/env bash
# Simple autostart menu for RaspberryPi.

DIALOG_CANCEL=1
DIALOG_ESC=255

steam_cmd="/usr/local/bin/steam"
steam_res="720"

dt_cmd="startx"
es_cmd="/usr/bin/emulationstation"
ms_cmd="/usr/bin/mehstation"
db_cmd="/usr/bin/dosbox"
rp_cmd="sudo /home/pi/RetroPie-Setup/retropie_setup.sh"

function pbar()
{
	{
		for ((i = 0 ; i <= 100 ; i+=5));
		do
			sleep 0.1
			echo $i
		done
	} | whiptail --gauge "${_msg}" 6 50 0
}

# Menu Loop
_menu=true
while $_menu;
do
	exec 3>&1

	selection=$(whiptail --title "Interface Select" \
		--backtitle "into the wonderfull" \
		--clear \
		--menu "Select" 20 78 10 \
		"1" "Desktop" \
		"2" "Dosbox" \
		"3" "Emulation Station" \
		"4" "mehstation" \
		"5" "RetroPie Setup" \
		"6" "Steam" \
		"7" "Shell" \
		"8" "Midnight Commander" \
		"9" "Reboot" \
		"10" "Shutdown System" \
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
		_msg="Starting desktop..."
		pbar
		exec $dt_cmd
		;;
	2)
		_menu=false
		clear
		_msg="Launching Dosbox..."
		pbar
		exec $db_cmd
		;;
	3)
		_menu=false
		clear
		_msg="Starting Emulation Station..."
		pbar
		exec $es_cmd
		;;
	4)
		_menu=false
		clear
		_msg="Starting mehstation..."
		pbar
		LD_LIBRARY_PATH=/usr/local/lib
		exec $ms_cmd
		;;
	5)
		_menu=false
		clear
		_msg="Starting Retropie setup..."
		pbar
		exec $rp_cmd
		;;
	6)
		_menu=false
		clear
		_msg="Connecting to Steam..."
		pbar
		exec $steam_cmd $steam_res
		;;
	7)
		_menu=false
		clear
		;;
	8)
		_menu=false
		clear
		_msg="Starting Midnight Commander..."
		pbar
		exec $(which mc)
		;;
	9)
		_menu=false
		_msg="Rebooting system..."
		pbar
		sudo reboot
		;;
	10)
		_menu=false
		_msg="Shutting down system..."
		pbar
		sudo halt
		;;
	esac

done

exit $?
