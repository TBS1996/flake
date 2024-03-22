#!/run/current-system/sw/bin/bash


# Check for the correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_dir> <sync_dir> <days>"
    exit 1
fi

# Assign arguments to variables
SOURCE_DIR="$1"
SYNC_DIR="$2"
DAYS="$3"

# Ensure the sync directory exists
mkdir -p "$SYNC_DIR"

# Delete files in the sync directory older than the specified number of days
find "$SYNC_DIR" -type f -mtime +$DAYS -delete

# Copy files from the source directory to the sync directory
# Files must be newer than the specified number of days
find "$SOURCE_DIR" -type f -mtime -$DAYS -exec cp {} "$SYNC_DIR" \;

# Optional: Remove files from the SOURCE_DIR older than a certain threshold (e.g., 90 days)
# Uncomment the next line if you want to enable this
# find "$SOURCE_DIR" -type f -mtime +90 -delete

