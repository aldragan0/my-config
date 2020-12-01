#!/bin/bash

# =============================
# == Setup for manjaro-gnome ==
# =============================

# remove default packages that ship with gnome
sudo pacman -R --no-confirm epiphany
sudo pacman -R --no-confirm kvantum-qt5
sudo pacman -R --no-confirm gparted
sudo pacman -R --no-confirm manjaro-hello

# update all packages
pacman -Syu

# enable TRIM for SSD (extend SSD's life)
sudo systemctl enable fstrim.timer

# disable GRUB delay (comment this when dual-booting)
sudo sed -i 's/\(GRUB_TIMEOUT\)=[0-9]\+$/\1=0/1' /etc/default/grub
sudo update-grub

# increase swappiness(cannot use 'echo >' because redirection is run as normal user)
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/100-manjaro.conf

# enable the firewall
sudo ufw status
sudo ufw enable

# enable gnome-extensions
gnome-extensions enable ding@rastersoft.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# set gnome-tweaks (dconf watch / to check for updated preferences)
gsettings set org.gnome.desktop.interface gtk-theme 'Matcha-dark-azul'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark-Maia'
gsettings set org.gnome.shell.extensions.user-theme name 'Matcha-dark-azul'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/adwaita-timed.xml'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/gnome/adwaita-timed.xml'
gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
gsettings set org.gnome.desktop.interface show-battery-percentage 'true'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
gsettings set org.gnome.mutter workspaces-only-on-primary 'false'

# set dash-to-dock
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash 'false'
gsettings set org.gnome.shell.extensions.dash-to-dock animate-show-apps 'false'
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'ALL_WINDOWS'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC'
gsettings set org.gnome.shell.extensions.dash-to-dock middle-click-action 'previews'
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'do-nothing'

# set terminal
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode 'tab'
dconf load /org/gnome/terminal/legacy/profiles:/`dconf dump /org/gnome/terminal/legacy/profiles:/ | grep -o ':[a-z0-9\-]\+'` < ./terminal/term-profile.dconf
dconf load /org/gnome/terminal/legacy/keybindings/ < ./terminal/term-shortcuts.dconf

# install packages
pacman -S --no-confirm snapd
sudo systemctl enable --now snapd.socket # enable snap communication socket

pacman -S --no-confirm base-devel
pacman -S --no-confirm firefox
pacman -S --no-confirm vim
pacman -S --no-confirm git

snap install postman

# install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/Downloads/miniconda.sh
bash $HOME/Downloads/miniconda.sh -b -p $HOME/miniconda

# set oh-my-zsh for user
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i "s/\(home\/\).\+\//\1\/$USER\//g" ./dotfiles/.zshrc
cp -r ./dotfiles $HOME/
cp -r ./themes $HOME/.oh-my-zsh/themes

# install vscode
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
git clone https://AUR.archlinux.org/visual-studio-code-bin.git ~/Downloads/vscode-bin
cd ~/Downloads/vscode-bin
makepkg -si
sudo pacman -U --no-confirm visual-studio-code-bin-*.pkg.tar.xz
cd ..
rm -rf vscode-bin/
cd $SOURCE_DIR

# install vscode extensions

./tool-config/vscode.sh
