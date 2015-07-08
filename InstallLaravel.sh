composer create-project laravel/laravel monLaravel --prefer-dist;

chown -R tiak:tiak monLaravel;
chmod -R g+w monLaravel;

cd monLaravel;

composer install;

HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX storage vendor
setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX storage vendor

echo "pensez Ã  modifier .env";
