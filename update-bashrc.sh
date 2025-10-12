#!/bin/bash
# =============================================================================
# update-bashrc.sh
# -----------------------------------------------------------------------------
# This script backs up the existing ~/.bashrc and replaces it with the version
# stored in ~/codebase/.bashrc. It also automatically pulls the latest version
# from your GitHub repository.
# =============================================================================

# Exit on error
set -e

# Paths
BACKUP_DIR="$HOME/bashrc_backups"
SOURCE_BASHRC="$HOME/codebase/.bashrc"
TARGET_BASHRC="$HOME/.bashrc"

# Timestamp for backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# -----------------------------------------------------------------------------
# Step 1: Update the codebase repo
# -----------------------------------------------------------------------------
if [ -d "$HOME/codebase/.git" ]; then
    echo "Updating local codebase repository..."
    cd "$HOME/codebase"
    git fetch origin
    git pull origin main || git pull origin master
    echo "Repository updated successfully."
else
    echo "Error: ~/codebase not found or is not a Git repository."
    echo "Clone it first using: git clone git@github.com:itinfosec/codebase.git ~/codebase"
    exit 1
fi

# -----------------------------------------------------------------------------
# Step 2: Validate that the new .bashrc exists
# -----------------------------------------------------------------------------
if [ ! -f "$SOURCE_BASHRC" ]; then
    echo "Error: $SOURCE_BASHRC not found after pulling repository."
    exit 1
fi

# -----------------------------------------------------------------------------
# Step 3: Backup existing .bashrc
# -----------------------------------------------------------------------------
mkdir -p "$BACKUP_DIR"

if [ -f "$TARGET_BASHRC" ]; then
    cp "$TARGET_BASHRC" "$BACKUP_DIR/.bashrc.backup_$TIMESTAMP"
    echo "Backed up current .bashrc to $BACKUP_DIR/.bashrc.backup_$TIMESTAMP"
else
    echo "No existing .bashrc found, skipping backup."
fi

# -----------------------------------------------------------------------------
# Step 4: Replace with repo version
# -----------------------------------------------------------------------------
cp "$SOURCE_BASHRC" "$TARGET_BASHRC"
echo "Replaced ~/.bashrc with version from ~/codebase/.bashrc"

# -----------------------------------------------------------------------------
# Step 5: Reload .bashrc (optional)
# -----------------------------------------------------------------------------
if [ "$SHELL" = "/bin/bash" ]; then
    # shellcheck disable=SC1090
    source "$TARGET_BASHRC"
    echo "Reloaded new .bashrc"
fi

echo "✅ Bashrc update complete."
