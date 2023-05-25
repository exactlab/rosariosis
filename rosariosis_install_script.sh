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
dump=$( which pg_dump )
dumpPath="DatabaseDumpPath = '$dump';"
converter=$( which wkhtmltopdf )
converterPath="wkhtmltopdfPath = '$converter';"

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
sed "s/DatabaseDumpPath = '';/${dumpPath}/" config.inc.sample.php > config.inc.php
sed "s/wkhtmltopdfPath = '';/${converterPath}/" config.inc.sample.php > config.inc.php
# add italian language, to add other languages check if the lang_LANG.uft8 folder is present in the ./locale/ folder,
# then add , 'lang_LANG.uft8' to the language configuration line of the config.inc.php file
sed "s/[ 'en_US.utf8' ]/[ 'en_US.utf8' , 'it_IT.utf8' ]" config.inc.sample.php > config.inc.php

#----------

# -> postgres configuration
echo "  local         all       all   md5" >> /etc/postgresql/14/main/pg_hba.conf
sudo -u postgres psql
# change the username and password here and in the next commands accordingly
CREATE USER rosariosis_user WITH PASSWORD 'rosariosis_user_password';
# -> will require password in input
CREATE DATABASE rosariosis_db WITH ENCODING 'UTF8' OWNER rosariosis_user;
#a:X dove X e' il numero di elementi che rimangono. Per togliere una riga dalla lista si elimina da s:N a b:1;
UPDATE config SET config_value = 'a:10:{s:12:"School_Setup";b:1;s:8:"Students";b:1;s:5:"Users";b:1;s:10:"Scheduling";b:1;s:6:"Grades";b:1;s:10:"Attendance";b:1;s:11:"Eligibility";b:1;s:10:"Discipline";b:1;s:9:"Resources";b:1;s:6:"Custom";b:1;}' WHERE title = 'MODULES';
\q

#----------

# -> now open a new tab in the browser: 
# http://localhost/rosario/rosario_postgres/rosariosis/InstallDatabase.php
# -> and then another one:
# http:/localhost/rosario/rosario_postgres/rosariosis/index.php
