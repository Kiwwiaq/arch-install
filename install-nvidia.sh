
#!/bin/bash
clear

# Install GPU driver
echo "Installing GPU driver..."
pacman --noconfirm --needed -S nvidia nvidia-settings
