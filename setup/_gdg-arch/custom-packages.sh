#!/usr/bin/env bash

declare -A additionalPackages=(
    ["AMD packages"]="amdPackages"
    ["NVIDIA packages"]="nvidiaPackages"
#    ["Intel packages"]="intelPackages"
    ["Packages only for 'Framework16' laptop"]="framework16Packages"
#    ["Boot splash packages"]="bootSplash"
    ["Login manager (greeted+nwg-hello)"]="loginManager"
    ["Firmware packages"]="firmwarePackages"
    ["Extra fonts packages"]="extraFontsPackages"
    ["Docker (not Desktop)"]="dockerPackages"
    ["My favorite applications"]="applicationPackages"
    ["Virt-Manager"]="vmPackages"
    ["Printer packages"]="printerPackages"
    ["Timeshift"]="timeshift"
)

declare -a timeshift=(
    "timeshift"
)

declare -a dockerPackages=(
    "docker"
    "docker-buildx"
    "docker-compose"
    "docker-credential-secretservice-bin"
    "docker-machine"
    "lazydocker"
)

declare -a amdPackages=(
    "amdguid-wayland-bin"
    "amf-amdgpu-pro"
    "ffmpeg-amd-full"
    "vulkan-amdgpu-pro"
    "vulkan-headers-git"
    "vulkan-radeon"
    "vulkan-tools"
)

declare -a nvidiaPackages=(
    "python-gpustat"
)

declare -a intelPackages=()

declare -a extraFontsPackages=(
    "gnu-free-fonts"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "powerline-console-fonts"
    "powerline-fonts"
#    "terminess-powerline-font-git" # Parts conflicts with powerline-console-fonts
    "terminus-font"
    "ttf-dejavu"
    "ttf-fira-sans"
    "ttf-fira-code"
    "ttf-hack"
    "ttf-jetbrains-mono"
    "ttf-jetbrains-mono-nerd"
    "ttf-material-icons"
    "ttf-roboto"
    "ttf-ubuntu-font-family"
    "woff2-font-awesome"
)

declare -a bootSplash=(
    "plymouth-git"
    "plymouth-theme-arch-os"
    "plymouth-theme-framework-git"
    "plymouth-theme-optimus-git"
)

declare -a loginManager=(
    "nwg-hello"
    "mugshot"
#    "sddm"
)

declare -a framework16Packages=(
    "certbot"
    "certbot-dns-dnsimple"
    "framework-laptop-kmod-dkms-git"
    "framework-sensors-git"
    "framework-system"
    "sof-firmware"
    "qmk-hid" "qmk-udev-rules-git"
)

declare -a firmwarePackages=(
    "ast-firmware"
    "linux-firmware"
#    "linux-lts"
#    "linux-lts-headers"
#    "linux-zen"
#    "linux-zen-headers"
    "mkinitcpio-firmware"
)

declare -a applicationPackages=(
    "appimagelauncher"

    # Thunderbird alternative https://www.betterbird.eu/
    "betterbird-de-bin"

#    "binance"
    "brave-bin"
    "chromium"
    "easyeffects" "lsp-plugins-lv2" "mda.lv2"
#    "filezilla"
    "firefox-developer-edition" "firefox-developer-edition-i18n-de"
    "geany" "geany-plugins" "geany-plugin-jsonprettifier"
    "gitkraken"
    "gnome-calculator"
    "gnome-keyring"
    "gnome-mplayer" "mplayer"
    "gnome-software"
    "gtk4"
    "inkscape"
#    "keepass"
#    "keepass-de"
    "keepassxc" "keepassxc-wordlist-german-better"
    "libreoffice-fresh-de"
    "localsend-bin" # Share between Mobil / PC / Laptop
    "mediainfo" "mediainfo-gui"
    "meld"
    "mpv-full"
#    "mousepad"
    "naps2-bin"
    "nextcloud-client"
    "obs-studio"
    "openfortigui-git"
#    "phpstorm" "phpstorm-jre" "wmname"
    "pinta"
    "qalculate-gtk"
    "qpdfview"
    "qt5ct"
##    "qt6ct"
    "rambox-pro-bin"
    "rambox-pro-bin-blur-me-not"
    "remote-desktop-manager" "freerdp"
#    "rustdesk-bin"
    "signal-desktop"
    "simple-scan"
    "smile"
    "solaar"
    "teams-for-linux-bin"
#    "teamviewer"
#    "thunderbird" "thunderbird-i18n-de"
    "vlc" "phonon-qt6-vlc" "vlc-plugins-all"
    "x264" "x265"
)

declare -a vmPackages=(
    "edk2-ovmf"
    "libguestfs"
    "qemu-base"
    "qemu-desktop"
    "qemu-full"
    "qemu-guest-agent"
    "qemu-user-static"
    "qemu-user-static-binfmt"
    "virt-firmware"
    "virt-manager"
    "virt-viewer"
    "vde2"
)

declare -a printerPackages=(
    "brscan-skey"
    "brscan5"
    "colord"
    "cups"
    "cups-browsed"
    "cups-pdf"
    "cups-filters"
    "foomatic-db"
    "foomatic-db-engine"
    "foomatic-db-gutenprint-ppds"
    "foomatic-db-nonfree"
    "foomatic-db-nonfree-ppds"
    "foomatic-db-ppds"
    "ghostscript"
    "gutenprint"
    "ipp-usb"
    "nss-mdns"
    "system-config-printer"
)

declare -a systemPackages=(
    "7zip"
#    "acpi"
#    "acpi_call-dkms"
#    "acpid"
#    "alacritty"
#    "alsa-utils"
#    "aylurs-gtk-shell"
    "bash-completion"

    # Alternative for cat
    "bat"

    "bluez"
    "bluez-utils"
    "bolt"
    "breeze-icons"
    "bridge-utils"

    # Alternative to htop
#    "btop"

    "btrfs-progs"
#    "bun-bin"
    "cdrtools"
    "dconf-editor"
    "dog" # A better dig
    "downgrade"

    # Disk Usage/Free Utility
    "duf"

    "fd" # Better then find (simpler syntax)
#    "feh"
    "ffmpegthumbnailer"
#    "firmware-manager-git"
    "fwupd"
#    "gparted"
#    "grub"
#    "grub-btrfs"
#    "gtk-sharp-3"
    "gufw"
#    "guvcview"
    "gvfs"
    "gvfs-smb"
    "htop"
    "hunspell-de"
    "hyperfine" # Make performance test between two commands
    "i2c-tools"
##    "imagemagick"
    "inetutils"
    "inxi"
    "iptables-nft"
#    "kguiaddons"
    "libcurl-gnutls"
    "libfido2"
    "libgepub"
#    "libgnome-keyring"
#    "libgsf"
#    "libopenraw"
    "libusb"
    "less"
    "logrotate"
    "man-pages"
#    "matugen-bin"
    "mesa-utils"
    "meson"
    "mkinitcpio-numlock"
    "mission-center"
    "nano"
    "nano-syntax-highlighting"
    "ncdu" # TUI to find big files by scanning dirs
    "net-tools"
    "networkmanager-openconnect"
    "networkmanager-openvpn"
    "nfs-utils"
    "nmap"
#    "nodejs-lts-iron"
    "ntfs-3g"
    "numlockx"
#    "nut-monitor"
    "nvme-cli"
    "nwg-displays"
    "openbsd-netcat"
    "openssh"
#    "openssh-askpass"
    "pacman-contrib"
    "pacseek"
    "perl-image-exiftool"
    "pipewire" "gst-plugin-pipewire"
    "pipewire-alsa"
#    "pipewire-jack"
    "pipewire-libcamera"
    "pipewire-pulse"
    "pipewire-v4l2"
    "pipewire-zeroconf"
    "powertop"
    "python-libevdev"
#    "python-pip"
#    "python-psutil"
#    "python-qt-material"
    "python-rich"
#    "python-screeninfo"
    "qt5-graphicaleffects"
    "qt5-quickcontrols2"
    "qt6-multimedia-ffmpeg"
#    "qt6-virtualkeyboard"
    "reflector"
    "seahorse"
    "smartmontools"
    "speech-dispatcher"
    "sshfs"
#    "starship"
#    "stow"
#    "strace"
#    "sudo-askpass-git"
#    "swtpm"
    "system-config-printer"
    "systemd-numlockontty"
    "tcpdump"
    "thunar"
    "thunar-archive-plugin" "xarchiver"
    "thunar-media-tags-plugin"
    "thunar-shares-plugin"
    "thunar-vcs-plugin"
    "thunar-volman"
#    "timeshift"
    "tmux"
#    "trizen"
#    "ufw"
#    "uglify-js"
    "usbutils"
    "vscodium-insiders-bin"
#    "weston"
    "wireguard-tools"
    "wl-clip-persist"
    "wl-screenrec-git"
    "xdg-utils"

    # Yubikey configuration und authenticator
    "yubico-authenticator-bin"
#    "xf86-video-amdgpu"
#    "xf86-video-qxl"
#    "xf86-video-vesa"
#    "xorg-bdftopcf"
#    "xorg-docs"
#    "xorg-font-util"
#    "xorg-fonts-100dpi"
#    "xorg-fonts-75dpi"
#    "xorg-fonts-encodings"
#    "xorg-iceauth"
#    "xorg-mkfontscale"
#    "xorg-server"
#    "xorg-server-common"
#    "xorg-server-devel"
#    "xorg-server-xephyr"
#    "xorg-server-xnest"
#    "xorg-server-xvfb"
#    "xorg-sessreg"
#    "xorg-setxkbmap"
#    "xorg-smproxy"
#    "xorg-x11perf"
#    "xorg-xauth"
#    "xorg-xbacklight"
#    "xorg-xcmsdb"
#    "xorg-xcursorgen"
#    "xorg-xdpyinfo"
#    "xorg-xdriinfo"
#    "xorg-xev"
#    "xorg-xgamma"
#    "xorg-xhost"
#    "xorg-xinit"
#    "xorg-xinput"
#    "xorg-xkbcomp"
#    "xorg-xkbevd"
#    "xorg-xkbutils"
#    "xorg-xkill"
#    "xorg-xlsatoms"
#    "xorg-xlsclients"
#    "xorg-xmodmap"
#    "xorg-xpr"
#    "xorg-xprop"
#    "xorg-xrandr"
#    "xorg-xrdb"
#    "xorg-xrefresh"
#    "xorg-xset"
#    "xorg-xsetroot"
#    "xorg-xvinfo"
#    "xorg-xwayland"
#    "xorg-xwd"
#    "xorg-xwininfo"
#    "xorg-xwud"
#    "xsel"
    "zram-generator"
    "zsh-completions"
)

POST_configureLoginManager=0
_configureLoginManager() {
    if [[ ! -f /usr/share/nwg-hello/current_wallpaper.jpg ]]; then
       echo ":: Configure login manager (greetd)"
       sudo cp -f ${SCRIPT_DIR}/_gdg-arch/nwg-hello/nwg-hello* /etc/nwg-hello/
       sudo cp -f ${SCRIPT_DIR}/_gdg-arch/nwg-hello/greetd.conf /etc/greetd/
       sudo cp -f /etc/pam.d/greetd /etc/pam.d/greetd.bkp
       sudo cp -f ${SCRIPT_DIR}/_gdg-arch/nwg-hello/greetd.pam.file /etc/pam.d/greetd
       sudo cp -f ${SCRIPT_DIR}/_gdg-arch/nwg-hello/background.jpg /usr/share/nwg-hello/background.jpg
    fi
    echo
    if [[ "$(systemctl is-enabled greetd.service)" == "disabled" ]]; then
        local lm_service_name="$(systemctl status display-manager.service | head -n 1 | cut -d ' ' -f 2)"
        sudo systemctl disable ${lm_service_name}
        sudo systemctl enable greetd.service
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}:: The DisplayManager 'greetd' with 'nwg-hello' as theme is now enabled.${NONE}"
            echo -e "${GREEN}:: It will take effect on the next Login.${NONE}"
        else
            echo -e "${RED}!! Something went wrong. Please enable 'greetd' manualy by using this command:${NONE}"
            echo -e "${GREEN}sudo systemctl enable greetd.service${NONE}"
        fi
    fi
}

POST_configureFramework16KbdBacklight=0
_configureFramework16KbdBacklight() {
    if [[ ! -f /etc/udev/rules.d/99-framework16-kbd-backlight.rules ]]; then
        echo ":: Add udev rule for Framework KDB Backlight"
        sudo cp -f ${SCRIPT_DIR}/_gdg-arch/framework16/99-framework16-kbd-backlight.rules /etc/udev/rules.d/99-framework16-kbd-backlight.rules
        sudo udevadm control --reload-rules && sudo udevadm trigger
    fi
}

IFS=$'\n'

read -d '' -a selectedKeys < <(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedlist" "${!additionalPackages[@]}")

IFS=$' \t\n'

echo
echo -e "${GREEN}:: Prepare additional packages list to install ...${NONE}"

for key in "${selectedKeys[@]}"; do
    value="${additionalPackages[$key]}"
    readarray -t packages_to_install < <(eval "printf '%s\n' \"\${${value}[@]}\"")
    echo "Installation for ${key}:"
    _installPackages "${packages_to_install[@]}"
    _installAllPackages
    case $value in
        loginManager)
            POST_configureLoginManager=1
#            break
            ;;
        framework16Packages)
            POST_configureFramework16KbdBacklight=1
#            break
            ;;
    esac
done
