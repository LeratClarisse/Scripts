rm /etc/apache2/sites-enabled/symfony.conf
rm /etc/apache2/sites-available/symfony.conf
service apache2 restart

rm -r /var/www/html/symfony
rm  /usr/local/bin/composer
