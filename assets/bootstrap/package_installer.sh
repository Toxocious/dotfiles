#!/usr/bin/env sh

packages=(
    # # core packages
    qt5-wayland
    qt5ct
    qt6-wayland
    qt6ct
    qt5-svg
    qt5-quickcontrols2
    qt5-graphicaleffects
    gtk3
    polkit-gnome
    pipewire
    wireplumber
    jq
    wl-clipboard
    cliphist
    python-requests
    pacman-contrib
    linux-headers
    # # nvidia gpu packages
    # nvidia-dkms
    # nvidia-settings
    # libva
    # libva-nvidia-driver-git
    # # personal packages
    hyprland
    zsh
    zsh-completions
    fzf
    kitty
    mako
    waybar
    swww
    swaylock-effects
    wofi
    wlogout
    xdg-desktop-portal-hyprland
    swappy
    wl-clipboard
    grim
    slurp
    thunar
    btop
    thunderbird
    mpv
    exa
    bat
    pamixer
    pavucontrol
    brightnessctl
    bluez
    bluez-utils
    blueman
    network-manager-applet
    gvfs
    thunar-archive-plugin
    neofetch
    file-roller
    starship
    papirus-icon-theme
    ttf-jetbrains-mono-nerd
    noto-fonts-emoji
    lxappearance
    xfce4-settings
    nwg-look-bin
    sddm
    firefox
    brave-bin
    visual-studio-code-bin
    discord
    docker
    docker-compose
    npm
    pnpm
    noto-fonts-cjk
    # # packages to improve screensharing via certain apps
    xwaylandvideobridge-cursor-mode-2-git
)

countdown=5  # Set the countdown time in seconds
echo "Starting update in $countdown seconds. Press any key to cancel."

# Start the countdown loop
for i in $(seq $countdown -1 1); do
    echo "$i..."
    read -t 1 -n 1 && exit 1  # Wait for a key press and exit if one is detected
done

# Run the update command
paru -Syu --needed "${packages[@]}"

echo ""
echo -e "\033[1;33mThere may be some packages that weren't installed that are still mentioned in configs.\033[0m"
echo -e "\033[1;33mThese packages like firefox, webcord, prismlauncher, etc were not included because I'd\033[0m"
echo -e "\033[1;33mlike to leave these larger packages to user choice.\033[0m"

