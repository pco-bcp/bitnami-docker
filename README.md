# Docker Scaffold for Drupal using Bitnami Images

Provides an barebones, fast, and lightweight local / CI docker environment to work with [Drupal WxT][wxt].

Based on https://github.com/drupalwxt/docker-scaffold.git

## Setup

To setup a complete project, start with a clone of site-wxt:

```
git clone https://github.com/drupalwxt/site-wxt.git mysite
```

## Make it your own

Since you cloned the site-wxt repo, make it your own by removing the
git folder and initialze a new one.

```
rm -r .git
git init
```

## Bring in the docker scaffold

```
cd mysite
git clone https://github.com/djsutter/bitnami-docker.git docker
```

## Set your environment variables

Edit `.env` and modify as per this example:

```sh
BASE_IMAGE=dsutter/mysite
DOCKER_NAME=mysite
DB_NAME=drproj
PROFILE_NAME=wxt
# This must match the name of your folder
DOCKER_IMAGE=mysite
# This must match the name of your mutagen volume
MUTAGEN_VOLUME=mysite-mutagen-cache
BEHAT_PATH=profiles/wxt/tests
```

## Build the base image and the docker images

```
make all
```

## Bring up the dev stack

```
make up
```

## Install Drupal

```
make drupal_install
```

## Migrate sample content

```
make drupal_migrate
```

## View your site

To see your site, go to http://drupal.localhost:8080/

## Using ddev

If you want to run ddev, do this:

```
make stop
composer install --prefer-dist --ignore-platform-reqs --no-interaction
ddev config (answer prompts)
vi .ddev/config.yaml
  router_http_port: "8080"
```

```
ddev start
ddev exec -s web drush si wxt wxt_extension_configure_form.select_all='TRUE' -y
ddev exec -s web drush config-set wxt_library.settings wxt.theme theme-gcweb -y
ddev exec -s web drush migrate:import --group wxt --tag 'Core'
ddev exec -s web drush migrate:import --group gcweb --tag 'Core'
ddev exec -s web drush migrate:import --group gcweb --tag 'Menu'
```

Note, I'm not sure what this might be used for but it's possible that we should be using this option
in drush si as well:

```
install_configure_form.update_status_module='array(FALSE,FALSE)'
```

## Technical Details

For more information on how this package works, or how to configure it, visit the [Technical Details](technical.md) page.
