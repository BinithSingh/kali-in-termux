#!/data/data/com.termux/files/usr/bin/bash
folder=kali-fs
if [ -d "$folder" ]; then
    first=1
    echo "skipping downloading"
fi
if [ "$first" != 1 ];then
    if [ ! -f "kali.tar.xz" ]; then
        echo "downloading kali-image"
        if [ "$(dpkg --print-architecture)" = "aarch64" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-arm64-minimal.tar.xz -O kali.tar.xz
        elif [ "$(dpkg --print-architecture)" = "arm" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-armhf-minimal.tar.xz -O kali.tar.xz
        elif [ "$(dpkg --print-architecture)" = "x86_64" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-amd64-minimal.tar.xz -O kali.tar.xz
        elif [ "$(dpkg --print-architecture)" = "i*86" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-i386-minimal.tar.xz -O kali.tar.xz
        elif [ "$(dpkg --print-architecture)" = "x86" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-i386-minimal.tar.xz -O kali.tar.xz
        elif [ "$(dpkg --print-architecture)" = "i686" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-i386-minimal.tar.xz -O kali.tar.xz
        elif [ "$(dpkg --print-architecture)" = "amd64" ];then
            wget https://build.nethunter.com/kalifs/kalifs-latest/kalifs-amd64-minimal.tar.xz -O kali.tar.xz



        else
            echo "unknown architecture"
            exit 1
        fi
    fi
    cur=`pwd`
    mkdir -p $folder
    cd $folder
    echo "decompressing kali image"
    proot --link2symlink tar xf $cur/kali.tar.xz --strip-components=1 --exclude='dev'||:
  
    


    cd $cur

  echo "fixing nameserver, otherwise it can't connect to the internet"
  cp resolv.conf $folder/etc/resolv.conf

fi
mkdir -p kali-binds
bin=start.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A kali-binds)" ]; then
    for f in kali-binds/* ;do
      . \$f
    done
fi
command+=" -b kali-fs/dev:/dev"
command+=" -b /proc"
command+=" -b kali-fs/tmp:/dev/shm"
command+=" -b /data/data/com.termux"
command+=" -b /:/host-rootfs"
command+=" -b /sdcard"
command+=" -b /storage"
command+=" -b /mnt"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
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
echo "removing image for some space"
rm kali.tar.xz -rf
echo "You can now launch Kali with the ./start.sh script"

