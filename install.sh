#! /bin/bash

# Installing necessary packages 
sudo echo Installing necessary packages 
sudo apt install python3 -y
sudo apt install g++ -y
sudo apt install openssh-server -y
sudo apt install tree -y

# Createing files
echo Createing files
touch resources/.current_content.txt && echo "Custom message" > resources/.current_content.txt
g++ resources/message_input.cpp -o resources/.message_input
chmod +x resources/.message_input host.sh
mv resources .resources -f
mkdir -p .resources/.LocalServer/
rm server/drag_your_files_here.txt
rm README.md

# Setting up ssh-keys
if [[ -f /home/$USER/.ssh/id_rsa ]]; then
    echo done
else
    echo -ne '\n' | ssh-keygen
fi

mv ./install.sh .resources/