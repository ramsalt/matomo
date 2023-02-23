; <?php exit; ?> DO NOT REMOVE THIS LINE
; file automatically generated or modified by Matomo; you can manually override the default values in global.ini.php by redefining them in this file.
[database]
host = "${MATOMO_DATABASE_HOST}"
username = "${MATOMO_DATABASE_NAME}"
password = "${MATOMO_DATABASE_PASSWORD}"
dbname = "${MATOMO_DATABASE_NAME}"
enable_ssl = ${MATOMO_ENABLE_DATABASE_SSL}
ssl_ca = "${MATOMO_DATABASE_SSL_CA_FILE}"
ssl_cert = "${MATOMO_DATABASE_SSL_CERT_FILE}"
ssl_key = "${MATOMO_DATABASE_SSL_KEY_FILE}"
charset = "utf8mb4"

[General]
force_ssl = ${MATOMO_ENABLE_FORCE_SSL}
assume_secure_protocol = ${MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL}
multi_server_environment = ${MATOMO_MULTI_SERVER_ENVIRONMENT}
enable_trusted_host_check = ${MATOMO_ENABLE_TRUSTED_HOST_CHECK}
salt = "4325a52bf1bc4bad5ed57c76d13aed56"
proxy_client_headers[] = "${MATOMO_PROXY_CLIENT_HEADER}"
proxy_host_headers[] = "${MATOMO_PROXY_HOST_HEADER}"

action_title_category_delimiter = /

[log]
log_level = DEBUG

[mail]
transport = "smtp"
port = "25"
host = "127.0.0.1"
encryption = "none"

[PluginsInstalled]
PluginsInstalled[] = "CustomDimensions"
PluginsInstalled[] = "CoreVue"
PluginsInstalled[] = "CorePluginsAdmin"
PluginsInstalled[] = "CoreAdminHome"
PluginsInstalled[] = "CoreHome"
PluginsInstalled[] = "WebsiteMeasurable"
PluginsInstalled[] = "IntranetMeasurable"
PluginsInstalled[] = "Diagnostics"
PluginsInstalled[] = "CoreVisualizations"
PluginsInstalled[] = "Proxy"
PluginsInstalled[] = "API"
PluginsInstalled[] = "Widgetize"
PluginsInstalled[] = "Transitions"
PluginsInstalled[] = "LanguagesManager"
PluginsInstalled[] = "Actions"
PluginsInstalled[] = "Dashboard"
PluginsInstalled[] = "MultiSites"
PluginsInstalled[] = "Referrers"
PluginsInstalled[] = "UserLanguage"
PluginsInstalled[] = "DevicesDetection"
PluginsInstalled[] = "Goals"
PluginsInstalled[] = "Ecommerce"
PluginsInstalled[] = "SEO"
PluginsInstalled[] = "Events"
PluginsInstalled[] = "UserCountry"
PluginsInstalled[] = "GeoIp2"
PluginsInstalled[] = "VisitsSummary"
PluginsInstalled[] = "VisitFrequency"
PluginsInstalled[] = "VisitTime"
PluginsInstalled[] = "VisitorInterest"
PluginsInstalled[] = "RssWidget"
PluginsInstalled[] = "Feedback"
PluginsInstalled[] = "Monolog"
PluginsInstalled[] = "Login"
PluginsInstalled[] = "TwoFactorAuth"
PluginsInstalled[] = "UsersManager"
PluginsInstalled[] = "SitesManager"
PluginsInstalled[] = "Installation"
PluginsInstalled[] = "CoreUpdater"
PluginsInstalled[] = "CoreConsole"
PluginsInstalled[] = "ScheduledReports"
PluginsInstalled[] = "UserCountryMap"
PluginsInstalled[] = "Live"
PluginsInstalled[] = "PrivacyManager"
PluginsInstalled[] = "ImageGraph"
PluginsInstalled[] = "Annotations"
PluginsInstalled[] = "MobileMessaging"
PluginsInstalled[] = "Overlay"
PluginsInstalled[] = "SegmentEditor"
PluginsInstalled[] = "Insights"
PluginsInstalled[] = "Morpheus"
PluginsInstalled[] = "Contents"
PluginsInstalled[] = "BulkTracking"
PluginsInstalled[] = "Resolution"
PluginsInstalled[] = "DevicePlugins"
PluginsInstalled[] = "Heartbeat"
PluginsInstalled[] = "Intl"
PluginsInstalled[] = "Marketplace"
PluginsInstalled[] = "ProfessionalServices"
PluginsInstalled[] = "UserId"
PluginsInstalled[] = "CustomJsTracker"
PluginsInstalled[] = "Tour"
PluginsInstalled[] = "PagePerformance"
