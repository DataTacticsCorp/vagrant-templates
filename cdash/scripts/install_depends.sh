#!/usr/bin/env bash
sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password password'
sudo apt-get -y install mysql-server-5.5 php5 php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl zip --fix-missing

sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO cdash@localhost IDENTIFIED BY ''"

sudo mysql_install_db

wget http://www.cdash.org/download/CDash-2.0.2.zip

unzip CDash-2.0.2.zip -d /var/www

mv /var/www/CDash-2-0-2/* /var/www/

rm /var/www/index.html

cd /var/www/cdash

sed -i "s/$CDASH_DB_PASS = '';/$CDASH_DB_PASS = 'password';/g" config.php

sudo service apache2 restart