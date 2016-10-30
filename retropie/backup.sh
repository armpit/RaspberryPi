#!/bin/bash -
# Simple retropie backup script.

BACKUP_DIR="/media/media_storage/backup/retropie"
ROM_DIR="/home/pi/RetroPie/roms"
BIOS_DIR="/media/media_storage/emulators/BIOS"

DATE="$(date +'%m-%d-%Y')"

[ -d $BACKUP_DIR ] || mkdir $BACKUP_DIR

# Backup saves
echo -en "Backing up save games..."
cd $ROM_DIR
find . | egrep "\.(sav|srm)$" | tar -jcf $BACKUP_DIR/savegames_${DATE}.tbz -T -
echo -e "  DONE"

# Backup BIOS files
echo -en "Backing up BIOS files..."
# strip leading slash to suppress tar message
BIOS_DIR=`echo $BIOS_DIR | sed -e 's/\///'`
tar jcf $BACKUP_DIR/bios_${DATE}.tbz -C / $BIOS_DIR
echo "  DONE"

# Backup config files
echo -en "Backing up Config files..."
tar jcf $BACKUP_DIR/configs_${DATE}.tbz -C / opt/retropie/configs
echo "  DONE"

# Create md5 files
cd $BACKUP_DIR
md5sum savegames_${DATE}.tbz > savegames_${DATE}.md5
md5sum bios_${DATE}.tbz > bios_${DATE}.md5
md5sum configs_${DATE}.tbz > conf_${DATE}.md5
