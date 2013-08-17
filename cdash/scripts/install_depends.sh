#!/usr/bin/env bash

# Update repo info
sudo apt-get update

# Preset variable for the mysql-server installation
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password password'

# Install mysql, php, php modules, and zip
sudo apt-get -y install subversion mysql-server-5.5 php5 php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl --fix-missing

# Add a cdash user to mysql
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO cdash@localhost IDENTIFIED BY ''"

# Run the mysql installer script
sudo mysql_install_db

# Get CDash via SVN
svn co https://www.kitware.com/svn/CDash/Release-2-0-2/ /var/www

#Remove Apache's default index.html file
rm /var/www/index.html

# Change into our cdash directory where the configuration file is
cd /var/www/cdash

# Update the configuration file:
#   - Define password for mysql database
sed -i "s/$CDASH_DB_PASS = '';/$CDASH_DB_PASS = 'password';/g" config.php

# Back to the web root we go
cd /var/www

# Update permissions of CData folders
chmod -R 777 backup
chmod 777 upload
chmod 777 rss

# Restart apache
sudo service apache2 restart