echo 'configuring web server'
cd /var/www/html/
composer require tcg/voyager
php artisan voyager:install --with-dummy
composer require joy/voyager-api
php artisan vendor:publish --provider="Joy\\VoyagerApi\\VoyagerApiServiceProvider" --force
php artisan migrate
php artisan passport:install --force
php artisan joy-voyager-api:l5-swagger:generate