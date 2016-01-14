#!/bin/bash
#url         :https://blog.coloz.net
#version     :Beta0.1
#mail        :colozhan@gmail.com
#time        :1452759771
#system      :CentOS/RHEL
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
if [ "$(id -u)" -ne "0" ]; then
        echo "Please use the root user to execute the script"
        exit
else
        echo "Check Root Passed"
fi
#set -x
path=/webapps/kvm
virt_install="/usr/bin/virt-install "
	read -p  "Please enter virtual machine name: " vm_name
	     if [ "${vm_name}" = "" ]; then
		echo "No enter,virtual machine name can't be empty."
		exit 1
             fi
	        echo "========================================="
	        echo " Your virtual machine name: ${vm_name}"
	        echo "========================================="

	read -p "Please enter virtual machine Memory size: " mem_size
	    if [ "${mem_size}" = "" ]; then
		echo "No enter,virtual machine Memory size can't be empty."
		exit 1
	    fi
                echo "==================================================="
                echo " Your virtual machine Memory size: ${mem_size}"
                echo "==================================================="
 
	read -p "Please enter virtual machine disk size: " disk_size
	    if [ "${disk_size}" = "" ]; then
		echo "No enter,virtual machine disk size can't be empty."
		exit 1
	    fi
                echo "==================================================="
                echo " Your virtual machine disk size: ${disk_size}" G
                echo "==================================================="
 
	read -p "Please enter virtual machine vcpu process: " vcpu_number
	    if [ "${vcpu_number}" = "" ]; then
		echo "No enter,virtual machine vcpu process can't be empty."
		exit 1
	    fi
                echo "==================================================="
                echo " Your virtual machine vcpu process: ${vcpu_number}"
                echo "==================================================="

                echo "================================================"
                echo " Your virtual machine name: ${vm_name}"
		echo " Ypur virtual machine Memory size: ${mem_size} M"
		echo " Your virtual mechine disk size: ${disk_size} G"
		echo " Your virtual mechine vcpu process: ${vcpu_number} "
                echo "================================================"
		echo "press any key to continue"
		read

		virt_install --name "${vm_name}" --ram="${mem_size}" --vcpus="${vcpu_number}" --network bridge:bridge0 --disk path="${path}"/"${vm_name}".img,size="${disk_size}" --graphics none --location=/home/iso/CentOS-6.6-x86_64-bin-DVD1.iso --extra-args="console=tty0 console=ttyS0,115200"
