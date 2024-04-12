#!/bin/bash

echo "Welcome to the Ubuntu Cinnamon Conversion script!"
echo ""
echo "Setting variables..."
KERNEL=$(uname -r)
ARCH=$(uname -m)
echo ""
echo "This script is best made for 8GB USBs/SD Cards if you want to package them into an image file (.img)."
echo ""
echo "Running a few checks..."

if [[ $EUID -eq 0 ]]; then
echo "Error: Do not run this script as root!" 1>&2
echo "Solution: Run this script as a normal user without sudo."
exit
fi

if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo "You are online, continuing..."
  echo ""
else
  echo "Error: You are offline."
  exit
fi

if [[ "$ARCH" == "aarch64" ]]; then
    echo "Running on aarch64, continuing..."
else
    echo "Error: This script is only meant for ARM64 Chromebooks!"
    exit
fi

echo "Extending rootfs..."
sudo bash /scripts/extend-rootfs.sh
echo ""
echo "Setting password for user linux..."
passwd
echo ""
echo "Setting root password..."
sudo passwd
echo ""
echo "Installing Cinnamon Desktop..."
sudo apt update
sudo apt install cinnamon-desktop-environment unzip git -y
echo "Installing all Ubuntu Cinnamon base themes and icons. NOTE: You may need to change these things manually in the Appearances settings page."
sudo unzip kinmo.zip
sudo cp kinmo-gtk-theme-master/Kinmo* /usr/share/themes/
sudo git clone https://github.com/ubuntucinnamon/ubuntucinnamon-wallpapers/
sudo cp -r ubuntucinnamon-wallpapers/usr/share/backgrounds/ubuntucinnamon /usr/share/backgrounds
sudo cp -r ubuntucinnamon-wallpapers/usr/share/gnome-background-properties /usr/share/gnome-background-properties
sudo git clone https://github.com/ubuntucinnamon/ubuntucinnamon-artwork/
sudo cp -r ubuntucinnamon-artwork/etc/lightdm/lightdm.conf.d/ /etc/lightdm/
sudo git clone https://github.com/ubuntucinnamonremix/kimmo-icon-theme
sudo cp -r kinmo-icon-theme/usr/share/icons/Kinmo* /usr/share/icons/
sudo git clone https://github.com/ubuntucinnamon/yaru-cinnamon
sudo cp -r yaru-cinnamon/usr/share/themes/* /usr/share/themes/
sudo cp -r yaru-cinnamon/usr/share/icons/* /usr/share/icons/
sudo git clone https://github.com/ubuntucinnamon/ubuntucinnamon-environment
sudo cp -r ubuntucinnamon-environment/usr/share/* /usr/share/*
sudo apt purge deja-dup gdebi gnome-games gnote hexchat inkscape libreoffice* remmina sound-juicer synaptic yelp --autoremove -y
sudo apt purge firefox-esr --autoremove -y
sudo apt purge snapd --autoremove -y
sudo apt install gnome-software -y
echo ""
echo "Installing Brave Browser..."
sudo apt install curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y
echo ""
echo "Setting Hostname to ubuntu-cinnamon..."
sudo hostnamectl set-hostname ubuntu-cinnamon
echo ""
sleep 7
clear
echo "The Ubuntu Cinnamon Conversion Script has finished..."
echo ""
echo "Rebooting in 10 seconds... (Press CTRL+C to cancel reboot)"
echo "" 
echo "After rebooting, at the login screen, click on the icon near the password field and select Cinnamon, then log in. After that, open the terminal, and run second.sh, in the same directory."
sleep 10
systemctl reboot


