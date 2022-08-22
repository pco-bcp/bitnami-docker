# Technical Details

This page covers the technical details and background information for this package.

## Configuration

Configuration comes from the `.env` file, which should exist in the project directory (the directory which contains this repo).
It can be created from `example.env` found in this repo.

Below is a description of the env settings:

BASE_IMAGE - The full name (including repo name) of the base image for your project. Example: drupalwxt/site-wxt

DOCKER_NAME - A name for your docker containers, which will be used as a prefix for all your containers. Example: sitewxt (will create sitewxt_web, sitewxt_db, etc.)

DB_NAME - The name of the database. Example: myapp_db

PROFILE_NAME - The profile to use when initializing a new site. Example: wxt

DOCKER_IMAGE - This must match the name of your folder. It is used when running commands in containers, because this name is used to determine the network name (which ends with _default). Example: site-wxt

MUTAGEN_VOLUME - Mutagen allows a developer to connect their local environment to a cloud-based infrastructure. The name provided must match the name of your mutagen volume. Example: site-wxt-mutagen-cache

BEHAT_PATH - For behat testing, you must provide a path to where the tests are. Example: profiles/wxt/tests

## Images

There are several image types to discuss. The first group form the application itself, and then there are other supporting images such as the database.

### Base image

The first image to discuss is the base image. As the name suggests, it will be used as a source for almost all of the other images which form your application.

The base image is created from the main Dockerfile, which builds on the bitnami/php-fpm:8.1 image.
The Dockerfile adds some additional software and configuration which is appropriate for a Drupal WxT site.
It then copies some initialization files and runs a composer install.

### dev

The dev image is derived from the base image and contains minimal additions such as soft links and phpcs configuration, plus also some user alterations.
It is created by docker-compose using build-context, and the corresponding Dockerfile is located in the `images/dev` directory.

### nginx

The nginx image is based on bitnami/nginx. Additionally, it contains a full copy of the /app/html folder, which it takes from the base image.
It is created by docker-compose using build-context, and the corresponding Dockerfile is located in the `images/nginx` directory.

### database

- The default password for root is root (to be confirmed).
- The username/password for the application database is drupal/drupal, as set in `settings.php` and `docker-compose.yml`.

### firefox

Based on selenium/node-firefox.

### hub

Based on selenium/hub.

## Notes

- The main application containers have a full copy of Drupal and all supporting modules, themes, etc. In the Docker environment, the local filesystem is mounted so that changes made locally are reflected in the container.
