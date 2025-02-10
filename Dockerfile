FROM php:8.4.3
WORKDIR /user/app

# Instalar extensões e dependências necessárias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    && docker-php-ext-install \
    pdo \
    pdo_mysql

# Copy in the source code
COPY . .

# Install Composer
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0"]