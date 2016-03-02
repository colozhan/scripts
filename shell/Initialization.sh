#!/bin/bash
#
# Filename         Initialization System
# By .             Thanatos.Ren
# Version          1.0
# Email            thanatos.ren@icloud.com
# Blog             http://blog.thanatos.net
# Description      Initialization System


#host
echo "initialization 192.168.1.254">>/etc/hosts
#yum 
yum install -y gcc gcc-c++ wget screen java nfs* openssh-clients lrzsz
#selinux disabled
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
#mkdir
mkdir -p /webapps
mkdir -p /tools
#mount
mount -t nfs 192.168.1.96:/volume1/webapps /webapps
mount -t nfs 192.168.1.96:/volume1/tools /tools
#java_path
echo "export JAVA_HOME=/tools/jdk1.8.0_73">>/etc/profile
echo "export JRE_HOME=$JAVA_HOME/jre">>/etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin"
source /etc/profile