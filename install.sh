#!/data/data/com.termux/files/usr/bin/sh
echo start
export HOME=/data/data/com.termux/files/home
export PATH=/data/data/com.termux/files/usr/bin/:$PATH
SSHFS_VERSION_LINK=$(curl -s https://github.com/libfuse/sshfs/releases/latest | cut -d'"' -f2 | cut -d'"' -f1)
export SSHFS_VERSION=${SSHFS_VERSION_LINK##*/}
#set the link to the lastest .tar.xz tarball at https://github.com/libfuse/sshfs/releases
export SSHFS_LINK="https://github.com/libfuse/sshfs/releases/download/$SSHFS_VERSION/$SSHFS_VERSION.tar.xz"
export SSHFS_FILE_TAR_XZ=$HOME/$SSHFS_VERSION.tar.xz
export SSHFS_FOLDER=$HOME/$SSHFS_VERSION
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
tar -xf $SSHFS_FILE_TAR_XZ
rm $SSHFS_FILE_TAR_XZ
cd $SSHFS_FOLDER
mkdir ./build/
cd ./build/
meson ..
#uncomment following line if you have LINE_MAX error
#sed -i '1s/^/#define LINE_MAX 4096\n\n/' ../sshfs.c
ninja
cp ./sshfs $HOME/sshfs
cd $HOME
rm -r $SSHFS_FOLDER
while true; do
read -p "Do you want to move sshfs to /data/data/com.termux/files/usr/bin/sshfs ? [Y/n] " yn
case $yn in
[Yy]* ) mv $HOME/sshfs /data/data/com.termux/files/usr/bin/sshfs; echo "sshfs moved to /data/data/com.termux/files/usr/bin/sshfs !"; break;;
[Nn]* ) echo 'sshfs let at $HOME'; break;;
* ) echo 'Please type correctly [Y] or [n]';;
esac
done
echo Finished!
