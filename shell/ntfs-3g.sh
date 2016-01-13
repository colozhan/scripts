#!/bin/bash
#url         :https://blog.coloz.net
#version     :Beta0.1
#mail        :colozhan@gmail.com
#time        :1452649909
#system      :CentOS/RHEL

if [ "$(id -u)" -ne "0" ]; then
        echo "Please use the root user to execute the script"
        exit
else
        echo "Check Root Passed"
fi
NTFS_3G=/opt/ntfs-3g
SCODE=https://down.coloz.net/linux/src
SOFT_NAME=ntfs-3g_ntfsprogs
VERSION=2015.3.14

#Rely on installation
yum install gcc gcc-c++ kernel wget make kernel-devel

#source down
cd /tmp
wget -c $SCODE/$SOFT_NAME-$VERSION.tgz

#decompression
tar xvf $SOFT_NAME-$VERSION.tgz
cd $SOFT_NAME-$VERSION
./configure --prefix=$NTFS_3G
make
make install

#PATH config
PATH=$PATH
ln -s $NTFS_3G/bin/ntfs-3g.probe /usr/bin/ntfs-3g
echo $PATH
which ntfs-3g
#finished
echo "ntfs-3g installation completed !!!!!!!!!!!!!!!!!!!!!!"
