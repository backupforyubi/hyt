#!/bin/bash

mkdir -p /opt/lnmp1.2
tar zxf mysql-5.6.23-linux-x86_64.tar.gz -C /opt/lnmp1.2/
mv /opt/lnmp1.2/mysql-5.6.23-linux-x86_64 /opt/lnmp1.2/mysql

dpkg -i jxch168deb/*.deb
#dpkg -i jxchjemalloc_3.6.0-1_amd64.deb
#libc-dev-bin libc6-dev libjpeg-dev libjpeg-turbo8 libjpeg-turbo8-dev libjpeg8 libjpeg8-dev linux-libc-dev manpages-dev
#libc-dev-bin libc6-dev libpng12-dev linux-libc-dev manpages-dev zlib1g-dev
#libpng12-0

groupadd mysql
useradd -s /sbin/nologin -M -g mysql mysql

#apt-get install libjpeg-dev
#apt-get install libpng-dev
ln -s /usr/lib/x86_64-linux-gnu/libpng* /usr/lib/
ln -s /usr/lib/x86_64-linux-gnu/libjpeg* /usr/lib/


    ulimit -v unlimited

    if [ `grep -L "/lib"    '/etc/ld.so.conf'` ]; then
        echo "/lib" >> /etc/ld.so.conf
    fi

    if [ `grep -L '/usr/lib'    '/etc/ld.so.conf'` ]; then
        echo "/usr/lib" >> /etc/ld.so.conf
    fi

    if [ -d "/usr/lib64" ] && [ `grep -L '/usr/lib64'    '/etc/ld.so.conf'` ]; then
        echo "/usr/lib64" >> /etc/ld.so.conf
    fi

    if [ `grep -L '/usr/local/lib'    '/etc/ld.so.conf'` ]; then
        echo "/usr/local/lib" >> /etc/ld.so.conf
    fi

    ldconfig

    cat >>/etc/security/limits.conf<<eof
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
eof

    echo "fs.file-max=65535" >> /etc/sysctl.conf
	
#apt-get install g++
#apt-get install libncurses5-dev
mkdir -p /opt/lnmp1.2/mysql/etc
cp conf/my.cnf /opt/lnmp1.2/mysql/etc/my.cnf
cp conf/mysql /etc/init.d/mysql
mkdir -p /data/mysql
chown -R mysql /data/mysql
chgrp -R mysql /opt/lnmp1.2/mysql/.
chmod 755 /etc/init.d/mysql


    cat > /etc/ld.so.conf.d/mysql.conf<<EOF
    /opt/lnmp1.2/mysql/lib
    /usr/local/lib
EOF
    ldconfig
ln -sf /opt/lnmp1.2/mysql/lib/mysql /usr/lib/mysql
ln -sf /opt/lnmp1.2/mysql/include/mysql /usr/include/mysql

ln -sf /opt/lnmp1.2/mysql/bin/mysql /usr/bin/mysql
ln -sf /opt/lnmp1.2/mysql/bin/mysqldump /usr/bin/mysqldump

/opt/lnmp1.2/mysql/scripts/mysql_install_db --defaults-file=/opt/lnmp1.2/mysql/etc/my.cnf --basedir=/opt/lnmp1.2/mysql --datadir=/data/mysql --user=mysql

systemctl enable mysql.service
service mysql start

/opt/lnmp1.2/mysql/bin/mysqladmin -u root password 'new-password'
