#!/data/data/com.termux/files/usr/bin/bash
folder=kali-armhf
if [ -d "$folder" ]; then
    first=1
    echo "skipping downloading"
fi
if [ "$first" != 1 ];then
    if [ ! -f "kali.tar.xz" ]; then
        echo "downloading kali-image"
        if [ "$(dpkg --print-architecture)" = "aarch64" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-armhf-minimal.tar.xz -O kali.tar.xz
        elif [ "$(dpkg --print-architecture)" = "arm" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-armhf-minimal.tar.xz -O kali.tar.xz
        else
            echo "unknown architecture"
            exit 1
        fi
    fi
    cur=`pwd`
    mkdir -p $folder
    echo "decompressing kali image"
    proot --link2symlink tar -xf $cur/kali.tar.xz --exclude='dev'||:
    echo "fixing nameserver, otherwise it can't connect to the internet"
    echo "nameserver 8.8.8.8" > etc/resolv.conf

cd $cur
fi
mkdir -p binds
bin=start.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
#unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A binds)" ]; then
    for f in binds/* ;do
        . \$f
    done
fi
command+=" -b /system"
command+=" -b /dev/"
command+=" -b /sys/"
command+=" -b /proc/"
#uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=\$LANG"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM
echo "fixing shebang of $bin"
termux-fix-shebang $bin
echo "making $bin executable"
chmod +x $bin
echo "You can now launch Kali with the ./start.sh script"
