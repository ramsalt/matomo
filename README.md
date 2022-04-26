# matomo
Customized matomo container image based on [wodby/matomo](https://github.com/wodby/matomo).

This image adds an additional init script creating Matomo's `config.ini.php` based on
environment variables.

This makes it easier to use the image in Kubernetes environments.

For details see [config/config.tpl.php](config/config.tpl.php).
