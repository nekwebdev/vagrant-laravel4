#!/bin/sh

cd /vagrant/www
composer install --dev
php artisan migrate
php artisan db:seed