#!/bin/bash

chown -R www-data:www-data storage bootstrap/cache

if [ ! -d "vendor" ]; then
  composer install --no-interaction --prefer-dist --optimize-autoloader
fi

if [ ! -d "node_modules" ]; then
  npm install
  npm run build
fi

until nc -z db 3306; do
  sleep 1
done

php artisan key:generate --force
php artisan migrate:fresh --seed --force

exec "$@"
