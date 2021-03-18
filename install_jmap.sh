#!/bin/bash
JMVER="0.2"

[[ -d ~/tmp ]] || mkdir ~/tmp;

pushd ~/tmp

echo "Removing old version....."
rm joymap-${JMVER}.tar.gz  >/dev/null 2>&1
sudo rm -rf joymap-${JMVER}  >/dev/null 2>&1

echo "Downloading....."
wget "http://downloads.sourceforge.net/project/linuxjoymap/joymap-${JMVER}.tar.gz" >/dev/null 2>&1

echo "Extracting....."
tar xfz joymap-${JMVER}.tar.gz
cd joymap-${JMVER}

echo "Compiling and installing....."
make clean >/dev/null 2>&1
./makekeys.sh >/dev/null 2>&1
make >/dev/null 2>&1
sudo cp -v reserve_js /usr/local/bin/
sudo cp -v loadmap /usr/local/bin/

echo "Activating joymapper....."
sudo bash -c "sed '$ i\joymap_enable.sh' /etc/rc.local > /home/pi/tmp/rc.local"
sudo cp /home/pi/tmp/rc.local /etc/rc.local

popd
sudo cp -v joymap_enable.sh /usr/local/bin

joymap_enable.sh
