#!/run/current-system/sw/bin/bash

# A script that scans a source directory for files more recent than given days
# then copies it over to a target folder. It also deletes files in the target folder
# older than the #days given. Useful with for example putting new podcasts into a directory for syncing with your phone.


if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_dir> <sync_dir> <days>"
    exit 1
fi

SOURCE_DIR="$1"
SYNC_DIR="$2"
DAYS="$3"

mkdir -p "$SYNC_DIR"

find "$SYNC_DIR" -type f -mtime +$DAYS -delete

find "$SOURCE_DIR" -type f -mtime -$DAYS -exec cp {} "$SYNC_DIR" \;
