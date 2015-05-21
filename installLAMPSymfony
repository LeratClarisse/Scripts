#!/bin/bash
#
# Author : Tiak
# Script to install :
# Symfony from scratch

# BINARY VARS (DEFAULT VALUES)
CURL_BIN='/usr/bin/curl'
COMPOSER_BIN='/usr/local/bin/composer'
A2ENSITE_BIN='/usr/sbin/a2ensite'
A2DISSITE_BIN='/usr/sbin/a2dissite'
PHP_BIN='/usr/bin/php'


# OTHER VARS
MYSQL_ROOT_PWD='toor'
PROJECT_PATH='/var/www/html/symfony'

# update package list
#aptitude update

# UPDATE BINARY VARS
#CURL_BIN=$(which curl)
#COMPOSER_BIN=$(which curl)
#A2ENSITE_BIN=$(which a2ensite)
#A2DISSITE_BIN=$(which a2dissite)
#PHP_BIN=$(which php)

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
   if [ -d /var/www/html/symfony ]; then
      echo "Répertoire déjà existant"
      exit 1
   else
      sleep 5
      $COMPOSER_BIN create-project --no-scripts --no-dev --verbose --prefer-dist --no-progress symfony/framework-standard-edition /var/www/html/symfony 2.3.0
   fi
else
   echo "Missing composer binary"
   exit 1
fi

# Bootstrap symfony
if [ -x $PHP_BIN ]; then
   echo "Bootsraping..."
   $PHP_BIN /var/www/html/symfony/vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php /var/www/html/symfony/app
else
   echo "Missing php binary"
   exit 1
fi

# parameters.yml
cat > /var/www/html/symfony/app/config/parameters.yml <<EOL
parameters:
    database_driver:   pdo_mysql
    database_host:     127.0.0.1
    database_port:     3306
    database_name:     testScript
    database_user:     root
    database_password: toor

    mailer_transport:  smtp
    mailer_host:       127.0.0.1
    mailer_user:       ~
    mailer_password:   ~

    locale:            en
    secret:            aeznjv_èzenvç_ezanrlfvcçzenfvc
EOL

# get bundles
cd /var/www/html/symfony
composer install

# ACL
apt-get install acl
HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX app/cache app/logs
setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX app/cache app/logs


# configuration Apache
# create conf virtualhost
cat >/etc/apache2/sites-available/symfony.conf <<EOL
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/symfony/web

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOL

# link conf in sites-enabled
ln -s /etc/apache2/sites-available/symfony.conf /etc/apache2/sites-enabled

# restart Apache service
service apache2 restart
