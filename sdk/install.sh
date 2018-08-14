#!/bin/bash
if [ `which lsb_release 2>/dev/null` ] && [ `lsb_release -i | cut -f2` == 'Ubuntu' ]
then
	echo "In order to install this package, you have to accept the EULA"
	echo "Please use PgDown and PgUp to read the EULA, then press q"
	read -p "Now please press ENTER " -r
	less EULA
	read -p "Do you accept this EULA (y/n)? " -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		apt-get update
		apt-get -y install python3-pip
		pip3 install --upgrade numpy
		# Protobuf
		echo "Installing protobuf from source"
		cd /tmp
		wget https://github.com/google/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.tar.gz
		tar xf protobuf-all-3.6.1.tar.gz
		cd protobuf-3.6.1
		./configure
		make -j4
		make install
		echo "Installing thnets from source"
		cd /tmp
		git clone https://github.com/mvitez/thnets
		cd thnets
		make ONNX=1
		make install
		ldconfig
		echo 'Installation finished'
	fi
elif [ -f /etc/redhat-release ] && [ `cut -d ' ' -f1 /etc/redhat-release` == 'CentOS' ] && \
	[ `cut -d ' ' -f4 /etc/redhat-release | cut -d . -f1 -` == '7' ]
then
	echo "In order to install this package, you have to accept the EULA"
	echo "Please use PgDown and PgUp to read the EULA, then press q"
	read -p "Now please press ENTER " -r
	less EULA
	read -p "Do you accept this EULA (y/n)? " -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cp libsnowflake-gcc4.8.so /usr/local/lib
		ln -s libsnowflake-gcc4.8.so libsnowflake.so
		yum install unzip
		yum install yum-utils
		yum-builddep python
		echo "Installing Python3 from source"
		cd /tmp
		curl -LO https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz
		tar xf Python-3.6.5.tar.xz
		cd Python-3.6.5
		./configure
		make
		make install
		pip3 install http://download.pytorch.org/whl/cpu/torch-0.4.0-cp36-cp36m-linux_x86_64.whl
		pip3 install --upgrade torchvision
		echo "Installing protobuf from source"
		cd /tmp
		curl -LO https://github.com/google/protobuf/releases/download/v3.5.1/protobuf-all-3.5.1.tar.gz
		tar xf protobuf-all-3.5.1.tar.gz
		cd protobuf-3.5.1
		./configure
		make
		make install
		echo "Installing thnets from source"
		cd /tmp
		curl -LO https://github.com/mvitez/thnets/archive/master.zip
		unzip master.zip
		cd thnets-master
		make ONNX=1
		make install
		echo /usr/local/lib >/etc/ld.so.conf.d/local.conf
		ldconfig
		echo 'Installation finished'
	fi
else
	echo 'This installer works only for Ubuntu and CentOS 7.x, sorry'
	exit
fi
