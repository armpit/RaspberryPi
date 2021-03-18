#!/bin/bash -
# Simple retropie backup script.

BACKUP_DIR="/media/media_storage/backup/retropie"
ROM_DIR="/home/pi/RetroPie/roms"
BIOS_DIR="/media/media_storage/emulators/BIOS"

BACKUP_SAVES='yes'
BACKUP_BIOS='yes'
BACKUP_CONFIGS='yes'

DROPBOX_STORAGE='yes'
DROPBOX_OPTIONS='-s -h -p'
GDRIVE_STORAGE='no'

DATE="$(date +'%m-%d-%Y')"

[ -d $BACKUP_DIR ] || mkdir $BACKUP_DIR

# Dropbox uploader setup.
# First check if we have a .dropbox_uploader config in the users folder, then check for
# a bin directory in the users home containing the uploader script and download it if not
# present. Then we perform a first run of the script in order to create the config.
if [ $DROPBOX_STORAGE = 'yes' ];
then
    if [ ! -f $HOME/.dropbox_uploader ];
    then
	if [ ! -d $HOME/bin ];
	then
	    echo "Creating $HOME/bin..."
	    mkdir $HOME/bin
	fi
	if [ ! -f $HOME/bin/dropbox_uploader.sh ];
	then
	    echo "Downloading dropbox upload script..." && \
	    curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o $HOME/bin/dropbox_uploader.sh >/dev/null 2>&1
	    chmod +x $HOME/bin/dropbox_uploader.sh
	fi
	echo "You need to configure dropbox uploader. Press enter to do so."
	read foo
	$HOME/bin/dropbox_uploader.sh
    fi
fi

# Backup saves
if [ $BACKUP_SAVES = 'yes' ];
then
    echo -en "Backing up save games....."
    cd $ROM_DIR
    # Skip if backup dated today exists
    if [ ! -f $BACKUP_DIR/savegames_$DATE.tbz ];
    then
	find . | egrep "\.(sav|srm)$" | tar -jcf $BACKUP_DIR/savegames_$DATE.tbz -T -
	echo "  DONE"
    else
	echo "  SKIPPED"
    fi
fi

# Backup BIOS files
if [ $BACKUP_BIOS = 'yes' ];
then
    echo -en "Backing up BIOS files....."
    if [ ! -f $BACKUP_DIR/bios_$DATE.tbz ];
    then
	BIOS_DIR=`echo $BIOS_DIR | sed -e 's/\///'`
	tar jcf $BACKUP_DIR/bios_$DATE.tbz -C / $BIOS_DIR
	echo "  DONE"
    else
	echo "  SKIPPED"
    fi
fi

# Backup config files
if [ $BACKUP_CONFIGS = 'yes' ];
then
    echo -en "Backing up Config files..."
    if [ ! -f $BACKUP_DIR/configs_$DATE.tbz ];
    then
	tar jcf $BACKUP_DIR/configs_$DATE.tbz -C / opt/retropie/configs
	echo "  DONE"
    else
	echo "  SKIPPED"
    fi
fi

# Create checksum files
cd $BACKUP_DIR
md5sum savegames_$DATE.tbz > savegames_$DATE.md5
md5sum bios_$DATE.tbz > bios_$DATE.md5
md5sum configs_$DATE.tbz > conf_$DATE.md5

# Upload to dropbox
if [ $DROPBOX_STORAGE = 'yes' ];
then
    echo "Uploading to dropbox......"
    $HOME/bin/dropbox_uploader.sh $DROPBOX_OPTIONS mkdir $DATE
    if [ $BACKUP_SAVES = 'yes' ];
    then
	[ ! -f savegames_$DATE.tbz ] || $HOME/bin/dropbox_uploader.sh $DROPBOX_OPTIONS upload savegames_$DATE.tbz $DATE/savegames_$DATE.tbz
	[ ! -f savegames_$DATE.md5 ] || $HOME/bin/dropbox_uploader.sh $DROPBOX_OPTIONS upload savegames_$DATE.md5 $DATE/savegames_$DATE.md5
    fi
    if [ $BACKUP_BIOS = 'yes' ];
    then
	[ ! -f bios_$DATE.tbz ] || $HOME/bin/dropbox_uploader.sh $DROPBOX_OPTIONS upload bios_$DATE.tbz $DATE/bios_$DATE.tbz
	[ ! -f bios_$DATE.md5 ] || $HOME/bin/dropbox_uploader.sh $DROPBOX_OPTIONS upload bios_$DATE.md5 $DATE/bios_$DATE.md5
    fi
    if [ $BACKUP_CONFIGS = 'yes' ];
    then
	[ ! -f configs_$DATE.tbz ] || $HOME/bin/dropbox_uploader.sh $DROPBOX_OPTIONS upload configs_$DATE.tbz $DATE/configs_$DATE.tbz
	[ ! -f configs_$DATE.md5 ] || $HOME/bin/dropbox_uploader.sh $DROPBOX_OPTIONS upload configs_$DATE.md5 $DATE/configs_$DATE.md5
    fi
fi

exit $?
