# Use a versão correta do PHP
FROM php:8.3-cli

# Definir o diretório de trabalho
WORKDIR /user/app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    && docker-php-ext-install \
    pdo \
    pdo_mysql

# Instalar o Composer corretamente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar os arquivos do projeto (apenas os essenciais para instalar dependências)
COPY composer.json composer.lock ./

# Instalar dependências do projeto
RUN composer install --no-dev --prefer-dist --no-scripts --no-progress --no-interaction

# Copiar os arquivos restantes do projeto
COPY . .

# Ajustar permissões
RUN chown -R www-data:www-data /user/app/storage /user/app/bootstrap/cache \
    && chmod -R 775 /user/app/storage /user/app/bootstrap/cache

# Expor a porta usada pelo Laravel
EXPOSE 8000

# Comando de inicialização
CMD ["php", "artisan", "serve", "--host=0.0.0.0"]
