#!/bin/bash

# Check if zsh is installed and do nothing if not
if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh is not installed. Please install zsh and rerun this script."
  exit 1
fi

# Get the path of zsh
ZSH_PATH=$(which zsh)

PLUGINS_DIR="$HOME/.zsh_addons"
BIN_DIR="$HOME/bin"
FONTS_DIR="$HOME/.local/fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip"
FONT_ZIP="$FONTS_DIR/font.zip"

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")
# copies dotfiles

# Define the files and directories
files=(
  "$HOME/.config/starship.toml"
  "$HOME/.aliases"
  "$HOME/.zshrc"
)

# Function to check and handle file/directory existence
check_and_remove() {
  local item=$1
  if [[ -e $item ]]; then
    echo "Warning: $item already exists."
    read -p "Do you want to DELETE it? (y/n): " answer
    if [[ $answer == "y" ]]; then
      rm -rf "$item"
      echo "$item has been deleted."
    else
      echo "Exiting the script."
      exit 1
    fi
  fi
}

# Iterate over files and check them
for file in "${files[@]}"; do
  check_and_remove "$file"
done

# Check the plugins directory
if [[ -n $PLUGINS_DIR ]]; then
  check_and_remove "$PLUGINS_DIR"
fi

# Creates root directories if they don't exist
mkdir -p "$HOME/.config"
mkdir -p "$PLUGINS_DIR"

# Create symlinks for the dotfiles
ln -s "$SCRIPT_DIR/.aliases" "$HOME/.aliases"
ln -s "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"


# Create a symlink for the starship configuration
ln -s "$SCRIPT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

if [ -d "$BIN_DIR" ]; then 
  echo "Warning: $BIN_DIR already exists."
  read -p "Do you want to DELETE it? (y/n): " answer
  if [[ $answer == "y" ]]; then
    rm -rf "$item"
    echo "$item has been deleted."
  else
    echo "Exiting the script."
    exit 1
  fi
fi

# Create a symlink for the bin directory
ln -s "$SCRIPT_DIR/bin" "$BIN_DIR"

echo "Installing command-not-found (for zsh apt suggestions), exa and tmux..."
sudo apt update
sudo apt install command-not-found
sudo apt install exa
sudo apt install tmux

# sets default shell
echo "set-option -g default-shell /bin/zsh" >> $HOME/.tmux.conf

# creates root folder for autocompletions
mkdir $HOME/.zfunc

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $PLUGINS_DIR/zsh-autosuggestions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $PLUGINS_DIR/zsh-autocomplete
git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting $PLUGINS_DIR/fast-syntax-highlighting

# Install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Change the default shell to zsh
chsh -s "$ZSH_PATH"

# Check if the shell was changed successfully
if [ $? -eq 0 ]; then
  echo "Successfully changed the default shell to zsh."
  echo "Please log out and log back in for the changes to take effect."
else
  echo "Failed to change the default shell."
  exit 1
fi

# Ask if the user wants to install FiraCode Nerd Font
read -p "Do you want to install the FiraCode Nerd Font? (y/n): " install_font
if [[ $install_font == "y" ]]; then
  # Create fonts directory if it doesn't exist
  mkdir -p "$FONTS_DIR"

  # Download the font zip file
  echo "Downloading FiraCode Nerd Font..."
  curl -Lo "$FONT_ZIP" "$FONT_URL"
  
  if [[ $? -ne 0 ]]; then
    echo "Failed to download FiraCode Nerd Font. Exiting."
    exit 1
  fi

  # Unzip the font into the fonts directory
  echo "Installing FiraCode Nerd Font..."
  unzip -o "$FONT_ZIP" -d "$FONTS_DIR"

  # Delete the zip file
  rm -f "$FONT_ZIP"
  echo "FiraCode Nerd Font has been installed successfully in $FONTS_DIR."

  # clears font cache
  if command -v fc-cache &>/dev/null; then
    echo "Updating font cache..."
    fc-cache -fv "$FONTS_DIR"
  else
    echo "Font cache update command (fc-cache) not found. You may need to update it manually."
  fi
else
  echo "Skipping FiraCode Nerd Font installation."
fi

echo "Setup complete!"

read -p "Rebooting the system or logging out is recommended. Do you want to reboot now? (y/n): " reboot_system
if [[ $reboot_system == "y" ]]; then
  echo "Rebooting..."
  sudo reboot
else
  echo "You can reboot or logout later to finish setup."
  exit 0
fi