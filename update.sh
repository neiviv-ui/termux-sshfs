#!/data/data/com.termux/files/usr/bin/sh
echo Start
if ! [ -x /data/data/com.termux/files/usr/bin/sshfs-update ]
then
echo "You cannot run this script, it is another script who launch it"
fi
export HOME=/data/data/com.termux/files/home
export PATH=/data/data/com.termux/files/usr/bin/:$PATH
SSHFS_VERSION_LINK=$(curl -s https://github.com/libfuse/sshfs/releases/latest | cut -d'"' -f2 | cut -d'"' -f1)
export SSHFS_VERSION=${SSHFS_VERSION_LINK##*}
export SSHFS_VERSION_LITE=${SSHFS_VERSION##*-}
export SSHFS_LINK="https://github.com/libfuse/sshfs/releases/download/$SSHFS_VERSION/$SSHFS_VERSION.tar.xz"
#Compiling sshfs newest version
pkg update -y
pkg upgrade -y
pkg install root-repo -y
pkg install openssh python glib libfuse3 ninja wget coreutils tar sed termux-elf-cleaner -y
python -m pip install --upgrade pip
pip install meson
pip install docutils
cd $HOME
rm -r $HOME/sshfs*
wget -P $HOME $SSHFS_LINK
tar -xf $HOME/$SSHFS_VERSION.tar.xz
rm $HOME/$SSHFS_VERSION.tar.xz
cd $HOME/$SSHFS_VERSION
mkdir ./build/
cd ./build/
meson ..
if ! grep -q '#define LINE_MAX' ../sshfs.c;
then
sed -i '1s/^/#define LINE_MAX 4096\n\n/' ../sshfs.c
fi
ninja
if [ -x ./sshfs ]
then
data/data/com.termux/files/usr/bin/termux-elf-cleaner ./sshfs
cp ./sshfs /data/data/com.termux/files/usr/bin/sshfs
cd $HOME
rm -r $HOME/$SSHFS_VERSION
rm -r --force /data/data/com.termux.files/usr/bin/sshfs-update
chmod +x $HOME/termux-sshfs/sshfs-update
mv $HOME/termux-sshfs/sshfs-update /data/data/com.termux/files/usr/bin/sshfs-update
rm -r --force /data/data/com.termux/files/usr/bin/sshfs-temp
rm -r --force $HOME/termux-sshfs
echo "\nDone".
else
mv /data/data/com.termux/files/usr/bin/sshfs-temp /data/data/com.termux/files/usr/bin/sshfs
echo "\nThere was/were error(s) during the update, Sshfs let at old version."
fi
