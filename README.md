# Matomo configuration

Configuration of Nginx, PHP and Matomo on the frontend servers.

For an overview see [Confluence](https://kb-ramsalt.atlassian.net/l/c/4kaDfkXt).

## Deployment

All pushes to the `main` branch trigger the deployment in [.circleci/config.yml](.circleci/config.yml).

* Add ssh key from project configuration (needs to correspond to the key set by Ansible](https://bitbucket.org/ramsalt/ansible-playbooks/src/master/roles/_local.matomo/)
* Generate matomo config by substituting env variables in [templates/matomo/config.ini.php](templates/matomo/config.ini.php)
* Copy the complete deploy directory to all Matomo frontend nodes
* Run the [deployment script](deploy/bin/deploy.sh) on each node

## Nginx configuration

Nginx configuration is in [deploy/nginx/default.conf](deploy/ngnix/default.conf). As this setup is for a dedicated web server it simply overwrites the default nginx configuration. Each node has local Let's Encrypt certificates configured by Ansible under `/etc/letsencrypt/live/matomo/`.

The configuration is based on [Matomo*s recommmendations](https://github.com/matomo-org/matomo-nginx).

## PHP configuration

PHP ocnfiguration is in [deploy/php/www.conf](deploy/php/www.conf). Again, this simply overwrites the configuration for the default php pool.

## Matomo configuration

Matomo configuration is in [template/matomo-config/config.ini.php](template/matomo-config/config.ini.php). The `MATOMO_MYSQL_PASS` environment variable will be replaced by the password configured in CircleCI on deployment.
