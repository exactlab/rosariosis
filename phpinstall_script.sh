#!/bin/bash

set -e

sudo apt-get update 
sudo apt-get upgrade

sudo apt -qq -y install php8.1-cli
sudo apt -qq -y install php-pgsql
sudo apt -qq -y install php-mysql
sudo apt -qq -y install gettext
sudo apt -qq -y install php-intl
sudo apt -qq -y install php-mbstring
sudo apt -qq -y install php-gd
sudo apt -qq -y install php-curl
sudo apt -qq -y install php-xmlrpc
sudo apt -qq -y install php-xml
sudo apt -qq -y install php-zip
