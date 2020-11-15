#!/data/data/com.termux/files/usr/bin/sh
echo Start
export HOME=/data/data/com.termux/files/home
export PATH=/data/data/com.termux/files/usr/bin/:$PATH
SSHFS_VERSION_LINK=$(curl -s https://github.com/libfuse/sshfs/releases/latest | cut -d'"' -f2 | cut -d'"' -f1)
export SSHFS_VERSION=${SSHFS_VERSION_LINK##*/}
export SSHFS_VERSION_LITE=${SSHFS_VERSION##*-}
#Compiling sshfs newest version
pkg update -y
pkg upgrade -y
pkg install root-repo -y
pkg install openssh python glib libfuse3 ninja wget coreutils tar sed -y
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
cp ./sshfs $HOME/sshfs
cd $HOME
rm -r $HOME/$SSHFS_VERSION
