# kali-in-termux
This is a script by which you can install Kali in your termux application without rooted phone
Steps
Update termux: apt-get update && apt-get upgrade -y
Install wget: apt-get install wget -y
Install proot: apt-get install proot -y
Install git: apt-get install git -y
Go to HOME folder: cd ~
Download script: git clone https://github.com/MFDGaming/kali-in-termux.git
Go to script folder: cd kali-in-termux
Give execution permission: chmod +x kaliu.sh
Run the script: ./debian.sh
Now just start Kali ./start.sh
COMMANDS ONLY FOR THE FIRST TIME
1. ./start.sh
2. echo "nameserver 8.8.8.8' > /etc/resolv.conf
3. logout
4. ./start.sh
5. apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 7D8D0BF6
6. apt-get update
