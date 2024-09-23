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

; do not show update notification in web frontend to normal users
show_update_notification_to_superusers_only = 1
; do not send email when updates are available
enable_update_communication = 0

minimum_memory_limit_when_archiving = ${MATOMO_MEMORY_LIMIT_WHEN_ARCHIVING}

enable_browser_archiving_triggering = 0
enable_sql_optimize_queries = 0

action_title_category_delimiter = /

; maximum number of rows for any of the Referers tables (keywords, search engines, campaigns, etc.), and Custom variables names
datatable_archiving_maximum_rows_referrers = 500000
; maximum number of rows for any of the Referers subtable (search engines by keyword, keyword by campaign, etc.), and Custom variables values
datatable_archiving_maximum_rows_subtable_referrers = 500000

; maximum number of rows for any of the Actions tables (pages, downloads, outlinks)
datatable_archiving_maximum_rows_actions = 500000
; maximum number of rows for pages in categories (sub pages, when clicking on the + for a page category)
datatable_archiving_maximum_rows_subtable_actions = 500000

; maximum number of rows for any of the Events tables (Categories, Actions, Names)
datatable_archiving_maximum_rows_events = 500000
; maximum number of rows for sub-tables of the Events tables (eg. for the subtables Categories>Actions or Categories>Names).
datatable_archiving_maximum_rows_subtable_events = 100


; maximum number of rows for the Site Search table
 datatable_archiving_maximum_rows_site_search = 500000

; maximum number of rows for the User ID report
datatable_archiving_maximum_rows_userid_users = 500000

[log]
log_writers[] = "file"
log_writers[] = "screen"
; log_level = INFO
logger_file_path = /tmp/logs/matomo.log

[CustomReports]
custom_reports_max_execution_time = 2700
custom_reports_disabled_dimensions = "CoreHome.VisitLastActionDate"

[mail]
transport = "smtp"
port = "25"
host = "127.0.0.1"
encryption = "none"
defaultHostnameIfEmpty = matomo.ramsalt.com

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
PluginsInstalled[] = "MarketingCampaignsReporting"
