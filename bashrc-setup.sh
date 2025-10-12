# USER GUIDE!!! Make the script executable by chmod +x ~/dotfiles/bashrc-setup.sh AND THEN run with ./bashrc-setup.sh

#!/bin/bash
# Fully automated dotfiles setup with auto-clone and OS detection

set -e  # Exit on error

# --- Configuration -----------------------------------------------------------
GIT_REPO="git@github.com:itinfosec/codebase.git"  # ⚠️ Change this to your repo
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES=( .bashrc )  # Add more files as needed

echo "🔧 Starting dotfiles setup..."

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

# --- Clone or update dotfiles repository ------------------------------------
if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "🔁 Updating existing dotfiles repo..."
    cd "$DOTFILES_DIR"
    git pull --rebase
else
    echo "📥 Cloning dotfiles repo..."
    rm -rf "$DOTFILES_DIR"
    git clone "$GIT_REPO" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# --- Symlink managed dotfiles ------------------------------------------------
echo "🔗 Setting up symlinks..."
for file in "${DOTFILES[@]}"; do
    SRC="$DOTFILES_DIR/$file"
    DEST="$HOME/$file"

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
echo "✅ Setup complete! Reloading Bash..."
source ~/.bashrc
echo "🎉 All done — your dotfiles are now synced!"
