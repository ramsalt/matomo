# matomo
Customized matomo container image based on [wodby/matomo](https://github.com/wodby/matomo).

This image adds an additional init script creating Matomo's `config.ini.php` based on
environment variables.

This makes it easier to use the image in Kubernetes environments.

For details see [config/config.tpl.php](config/config.tpl.php).

## Plugin installation

The Dockerfile for this image also installs a number of additional plugins by downloading
and unzipping them directly from Matomo's site.

Some of these plugins fall under the InnoCraft EULA and need a valid LICENSE_KEY
build arg / environment variable. For GitHub builds, the license key must be stored in a
repository secret named LICENSE_KEY.

The necessary Plugins are listed directly in `Dockerfile`:

```
ARG PLUGIN_LIST=" \
AbTesting \
CustomReports \
CustomVariables:4.0.1 \
FormAnalytics \
"
```

*Do not forget to add a `\` at the end of each line.*
Plugin versions may be specified by separating them with a colon as shown above. Otherwise
the latest available version will be installed.
