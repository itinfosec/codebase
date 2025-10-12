# USER GUIDE!!! Make the script executable by chmod +x ~/codebase/bashrc-setup.sh AND THEN run with ./bashrc-setup.sh

#!/bin/bash
# Fully automated .bashrc setup: full repo in ~/codebase, symlink .bashrc

set -e  # Exit on error

# --- Configuration -----------------------------------------------------------
GIT_REPO="git@github.com:itinfosec/codebase.git"
DOTFILES_DIR="$HOME/codebase"
DOTFILES=( .bashrc )  # Only create symlinks for these files

echo "🔧 Starting .bashrc setup..."

# --- Detect OS ---------------------------------------------------------------
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    OS="unknown"
fi

echo "🖥️  Detected OS: $OS"

# --- Install essential packages ---------------------------------------------
install_packages() {
    echo "📦 Installing essential packages..."
    case "$OS" in
        ubuntu|debian)
            sudo apt update -y
            sudo apt install -y git curl vim
            ;;
        fedora)
            sudo dnf install -y git curl vim
            ;;
        arch)
            sudo pacman -Syu --noconfirm git curl vim
            ;;
        macos)
            if ! command -v brew &>/dev/null; then
                echo "🍺 Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install git curl vim
            ;;
        *)
            echo "⚠️  Unknown OS. Please install git, curl, and vim manually."
            ;;
    esac
}
install_packages

# --- Clone or update codebase repo ------------------------------------------
if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "🔁 Updating existing codebase repo..."
    cd "$DOTFILES_DIR"
    git pull --rebase
else
    echo "📥 Cloning codebase repo into $DOTFILES_DIR..."
    git clone "$GIT_REPO" "$DOTFILES_DIR"
fi

# --- Create symlinks in home directory --------------------------------------
for file in "${DOTFILES[@]}"; do
    SRC="$DOTFILES_DIR/$file"
    DEST="$HOME/$file"

    if [ ! -f "$SRC" ]; then
        echo "⚠️  $file not found in repo!"
        continue
    fi

    if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
        echo "📦 Backing up existing $file to $file.backup"
        mv "$DEST" "$DEST.backup"
    fi

    if [ ! -L "$DEST" ]; then
        echo "🔗 Linking $SRC → $DEST"
        ln -s "$SRC" "$DEST"
    else
        echo "✅ $file already linked"
    fi
done

# --- Reload bash -------------------------------------------------------------
echo "✅ .bashrc is set up! Reloading Bash..."
source "$HOME/.bashrc"
echo "🎉 Done! Your .bashrc is now synced."
