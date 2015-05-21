#!/bin/bash
#
# Author : Tiak
# Script to install :
# LAMP
# GIT
# Symfony project from Git

# BINARY VARS (DEFAULT VALUES)
CURL_BIN='/usr/bin/curl'
COMPOSER_BIN='/usr/local/bin/composer'
A2ENSITE_BIN='/usr/sbin/a2ensite'
A2DISSITE_BIN='/usr/sbin/a2dissite'
PHP_BIN='/usr/bin/php'


# OTHER VARS
MYSQL_ROOT_PWD='toor'

# update package list
#aptitude update

# install dependencies
#aptitude install --assume-yes curl


# download and setup LAMP server
#debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PWD"
#debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PWD"
#aptitude install --assume-yes mysql-server apache2 libapache2-mod-php5 #php5

# UPDATE BINARY VARS
CURL_BIN=$(which curl)
COMPOSER_BIN=$(which composer)
A2ENSITE_BIN=$(which a2ensite)
A2DISSITE_BIN=$(which a2dissite)
PHP_BIN=$(which php)


# download and setup composer
if [ -x $CURL_BIN ]; then
   echo "Installing composer..."
   curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin/
else
   echo "Missing curl binary"
   exit 1
fi

# create symfony project
if [ -x $COMPOSER_BIN ]; then
   $COMPOSER_BIN create-project --no-scripts --no-dev --verbose --prefer-dist --no-progress symfony/framework-standard-edition /var/www/symfony 2.3.0
else
   echo "Missing composer binary"
   exit 1
fi

# Bootstrap symfony
if [ -x $PHP_BIN ]; then
   echo "Bootsraping..."
   $PHP_BIN /var/www/symfony/vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php /var/www/symfony/app
else
   echo "Missing php binary"
   exit 1
fi

# parameters.yml
cat >/var/www/symfony/app/config/parameters.yml <<EOL
parameters:
    database_driver:   pdo_mysql
    database_host:     127.0.0.1
    database_port:     3306
    database_name:     symfony
    database_user:     root
    database_password: toor

    mailer_transport:  smtp
    mailer_host:       127.0.0.1
    mailer_user:       ~
    mailer_password:   ~

    locale:            en
    secret:            aeznjv_èzenvç_ezanrlfvcçzenfvc
EOL

# configure apache
#disable default site
#if [ -x $A2DISSITE_BIN ]; then
#   $A2DISSITE_BIN default
#fi

