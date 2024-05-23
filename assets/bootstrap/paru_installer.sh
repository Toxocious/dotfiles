#!/usr/bin/env sh

# Install Rustup
if ! pacman -Qi rustup &> /dev/null; then
    echo "Rustup is not installed. Installing..."
    sudo pacman -S rustup

    # Set default
    rustup default stable
fi

# Now install Paru
if command -v paru >/dev/null 2>&1;  then
  echo "paru is already installed"
else
  echo "Installing paru..."
  sudo pacman -Syu --needed base-devel
  git clone https://aur.archlinux.org/paru.git
  cd paru || exit 1
  makepkg -si
  cd ..
  rm -rf paru
fi
