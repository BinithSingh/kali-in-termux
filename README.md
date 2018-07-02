# kali-in-termux
This is a script by which you can install Kali in your termux application without rooted phone

Steps

1. Update termux: apt-get update && apt-get upgrade -y

2. Install wget: apt-get install wget -y

3. Install proot: apt-get install proot -y

4. Install git: apt-get install git -y

5. Go to HOME folder: cd ~

6. Download script: git clone https://github.com/MFDGaming/kali-in-termux.git

7. Go to script folder: cd kali-in-termux

8. Give execution permission: chmod +x kali.sh

9. Run the script: ./kali.sh

10. Now just start Kali ./start.sh

COMMANDS ONLY FOR THE FIRST TIME

1. ./start.sh

2. logout

3. cp ~/kali-in-termux/resolv.conf ~/kali-in-termux/kali-armhf/etc/

4. ./start.sh

5. apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 7D8D0BF6

6. apt-get update
