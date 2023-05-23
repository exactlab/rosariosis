#!/bin/bash

set -e

# -> apache installation
sudo apt -qq -y install apache2
sudo ufw allow 'Apache'
sudo ufw enable
sudo systemctl restart apache2

# -> postgres installation
sudo apt -qq -y install postgresql

# -> html to pdf utility installation
sudo apt -qq -y install wkhtmltopdf

sudo apt-get -qq update 
sudo apt-get -qq upgrade

# -> service restart
sudo systemctl restart apache2
sudo systemctl restart postgresql
