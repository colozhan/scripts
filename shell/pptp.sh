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

rpm_source=https://down.coloz.net/linux/centos/rpm
pptpd_name=pptpd-1.4.0-1.rhel5.x86_64.rpm
ppp_name=ppp-2.4.4-14.1.rhel5.x86_64.rpm
libpcap_name=libpcap-0.9.4-15.el5.x86_64.rpm

#Rely on installation
yum install wget screen vim

#down
cd /tmp
wget -c $rpm_source/$pptpd_name
wget -c $rpm_source/$ppp_name
wget -c $rpm_source/$libpcap_name

#uninstall
rpm -qa|grep pptp|xargs rpm -e
rpm -qa|grep ppp|xargs rpm -e
rpm -qa|grep libpcap|xargs rpm -e

#install
rpm -ivh *.rpm

$config
sed -i 's/net.ipv4.ip_forward\ =\ 0/net.ipv4.ip_forward\ =\ 1/g' /etc/sysctl.conf
sed -i 's/#localip\ 192.168.0.1/localip\ 192.168.0.1/g' /etc/pptpd.conf
sed -i 's/#remoteip\ 192.168.0.234-238,192.168.0.245/remoteip\ 192.168.0.234-238,192.168.0.245/g' /etc/pptpd.conf
echo "ms-dns 8.8.8.8">>/etc/ppp/options.pptpd
echo "ms-dns 8.8.4.4">>/etc/ppp/options.pptpd

#add username
        read -p  "Please enter pptp name: " pptp_name
             if [ "${pptp_name}" = "" ]; then
                echo "No enter,pptp name can't be empty."
                exit 1
             fi
                echo "========================================="
                echo " Your pptp name: ${vm_name}"
                echo "========================================="

        read -p  "Please enter pptp password: " pptp_password
             if [ "${pptp_password}" = "" ]; then
                echo "No enter,pptp password can't be empty."
                exit 1
             fi
                echo "========================================="
                echo " Your pptp password: ${vm_name}"
                echo "========================================="


cat >>/etc/ppp/chap-secrets<<eof
$pptp_name pptpd $pptp_password *
eof

#iptables
iptables -I INPUT 3 -p tcp -m state --state NEW -m tcp --dport 1723 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
service iptables save
service iptables restart

#start
service pptpd start

