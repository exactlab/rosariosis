#!/bin/bash

set -e

#installation of prerequisite software

. /var/www/html/rosario/rosario_postgres/rosariosis/phpinstall_script.sh

. /var/www/html/rosario/rosario_postgres/rosariosis/apache_postgres_htmltopdf_install_script.sh

#----------

comment1() #the script will be placed directly in the repo
{

 # -> clone rosariosis into the directory where the software will be installed
 apacheFolder="/var/www/html/"
 cd apacheFolder
 sudo mkdir -p rosario/rosario_postgres   #idempotency
 sudo chown -R $USER rosario/rosario_postgres
 cd rosario/rosario_postgres
 if [ -d rosariosis ]; then
 	 cd rosariosis 
	 git pull
 else 
	 git clone https://github.com/francoisjacquet/rosariosis.git
	 cd rosariosis
 fi
}

# config variables to be edited
location="localhost"
dbUser="rosariosis_user"
dbPass="rosariosis_user_password"
dbName="rosariosis_db"
dumpPath="$DatabaseDumpPath = '$( which pg_dump )';"
converterPath="$wkhtmltopdfPath = '$( which wkhtmltopdf )';"

# editing of the config variables
# $DatabaseType = 'postgresql' #should be alright
# $DatabaseServer = 'localhost' #localhost or the IP address for the db server
sed "s/localhost/${location}/" config.inc.sample.php > config.inc.php
# ! The following two should be changed !
# $DatabaseUsername = 'rosariosis_user'
sed "s/username_here/${dbUser}/" config.inc.sample.php > config.inc.php
# $DatabasePassword = 'rosariosis_user_password'
sed "s/password_here/${dbPass}/" config.inc.sample.php > config.inc.php
# ! do NOT change the following one !
# $DatabaseName = 'rosariosis_db'
sed "s/database_name_here/${dbName}/" config.inc.sample.php > config.inc.php
# $DatabaseDumpPath = 'usr/bin/pg_dump' (usually)
sed "s/$DatabaseDumpPath = '';/${dumpPath}/" config.inc.sample.php > config.inc.php
sed "s/$wkhtmltopdfPath = '';/${converterPath}/" config.inc.sample.php > config.inc.php

#----------

# -> postgres configuration
echo "  local         all       all   md5" >> /etc/postgresql/14/main/pg_hba.conf
sudo -u postgres psql
# change the username and password here and in the next commands accordingly
CREATE USER rosariosis_user WITH PASSWORD 'rosariosis_user_password';
# -> will require password in input
CREATE DATABASE rosariosis_db WITH ENCODING 'UTF8' OWNER rosariosis_user;
\q

#----------

# -> now open a new tab in the browser: 
# http://localhost/rosario/rosario_postgres/rosariosis/InstallDatabase.php
# -> and then another one:
# http:/localhost/rosario/rosario_postgres/rosariosis/index.php
