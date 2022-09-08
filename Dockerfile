FROM docker.io/bitnami/php-fpm:8.1

RUN install_packages git patch composer vim mariadb-client
RUN echo -e "\n\n; Allow environment variables to reach the FPM worker process.\nclear_env = no" >> /opt/bitnami/php/etc/php-fpm.d/www.conf
ENV PATH=$PATH:/app/vendor/bin

RUN echo -e "\\nalias ll='ls -alF'\\nalias ls='ls --color=auto'\\n" >> /root/.bashrc

COPY docker/conf/php.ini /opt/bitnami/php/etc/conf.d/php.ini
COPY scripts/ScriptHandler.php /app/scripts/ScriptHandler.php
COPY composer.json composer.lock auth.json* /app/

WORKDIR /app

RUN composer install --prefer-dist \
                     --ignore-platform-reqs \
                     --no-interaction
