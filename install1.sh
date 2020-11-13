#!/data/data/com.termux/files/usr/bin/sh
echo Start
export HOME=/data/data/com.termux/files/home
export PATH=/data/data/com.termux/files/usr/bin/:$PATH
SSHFS_VERSION_LINK=$(curl -s https://github.com/libfuse/sshfs/releases/latest | cut -d'"' -f2 | cut -d'"' -f1)
export SSHFS_VERSION=${SSHFS_VERSION_LINK##*/}
export SSHFS_VERSION_LITE=${SSHFS_VERSION##*-}
#set the link to the lastest .tar.xz tarball at https://github.com/libfuse/sshfs/releases
export SSHFS_LINK="https://github.com/libfuse/sshfs/releases/download/$SSHFS_VERSION/$SSHFS_VERSION.tar.xz"
#Check if sshfs is already installed
if [ -e /data/data/com.termux/files/usr/bin/sshfs ];
then
if [ -d /data/data/com.termux/files/usr/bin/sshfs ] || ! [ -x /data/data/com.termux/files/usr/bin/sshfs ];
then
rm -r --force /data/data/com.termux/files/usr/bin/sshfs
echo oui
else
SSHFS_SYSTEM_VERSION_FULL=$(/data/data/com.termux/files/usr/bin/sshfs -V)
SSHFS_SYSTEM_VERSION_LITE=${SSHFS_SYSTEM_VERSION_FULL#*"SSHFS version "}
SSHFS_SYSTEM_VERSION_LINE_BREAK=${SSHFS_SYSTEM_VERSI
