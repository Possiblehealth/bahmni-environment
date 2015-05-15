# user
# to generate password hash use 'echo "password" | openssl passwd -1 -stdin'

$bahmni_user_password_hash = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1' #p@ssw0rd
$ssh_port=22

# mysql
$mysqlRootPassword = "password"

## Postgres
$postgresMajorVersion ="9"
$postgresMinorVersion = "2"
$postgresUser="postgres"

$postgresFirstTimeSetup=true # Use this for first time setup of master and slave
$postgresMasterDbFileBackup="/tmp/pg_master_db_file_backup.tar" # The path of master db backup tar file on slave

#Postgres calculated variables
$postgresServiceName = "postgresql-${postgresMajorVersion}.${postgresMinorVersion}"
$postgresDataFolder = "/var/lib/pgsql/${postgresMajorVersion}.${postgresMinorVersion}/data"


#Tomcat 8
$tomcatManagerUserName = "tomcat"
$tomcatManagerPassword = "p@ssw0rd"
$tomcatHttpPort="8080"
$tomcatRedirectPort="8443"
$tomcatShutdownPort="8005"
$tomcatAjpPort="8009"
$tomcatParentDirectory="/home/${bahmni_user}"
$tomcatInstallationDirectory = "${tomcatParentDirectory}/apache-tomcat-${tomcat_version}"
$tomcatSessionTimeoutInMinutes = 120

# Set host name or ip address
$httpd_deploy_dir="/var/www"
$httpd_log_directory="/var/log"

$bahmniAppsDirectory="${httpd_deploy_dir}/bahmniapps"
$bahmniConfigDirectory="${httpd_deploy_dir}/bahmni_config"
$bahmniRevisionsDirectory="${httpd_deploy_dir}/bahmni_revisions"

$uploadedFilesDirectory="${tomcatParentDirectory}/uploaded-files"

# Bahmni core properties
$patientImagesDirectory="/home/${bahmni_user}/patient_images"
$patientImagesUrl="/patient_images"
$documentBaseDirectory="/home/${bahmni_user}/document_images"
$uploadedResultsDirectory="/home/${bahmni_user}/uploaded_results"

$nagios_user = "nagios"
$nagios_openmrs_user=admin
$nagios_openmrs_user_password=test

$smtp_host="gmail-smtp-in.l.google.com"
$from_email="bahmni@gmail.com"

$openelis_username="admin"
$openelis_password="adminADMIN\!"

# OpenMRS
$openmrs_database_user = "openmrs-user"
$openmrs_database_password = "password"
$openmrs_password = "test"

# OpenERP properties used by OpenMRS
$openERPPort=8069
$openERPHost=localhost
$openERPDatabase=openerp
$openERPUser=admin
$openERPPassword=password


$openerpShellUser = "openerp"
$openerpGroup = "openerp"

$openERPConnectTimeout=10000
$openERPReadTimeout=20000

$ant_home="/home/${bahmni_user}/apache-ant-${ant_version}"

######################## JASPER CONFIG START##############################################
$jasperTomcatHome = $tomcatInstallationDirectory
$jasperHome = $bahmni_jasper_home ? {
  undef     => "/usr/local/jasperreports-server-cp-5.0.0-bin",
  default   => $bahmni_jasper_home
}

$jasperDbType = "mysql"
$jasperDbHost = $passive_db_server_ip ? {
  undef => $db_server,
  default => $passive_db_server_ip
}
$jasperDbUsername = "root"
$jasperDbPassword = "password"
$jasperDbName = "jasperserver"

# Set the Jasper Reports URL to download from:
$report_zip_source_url = $implementation_name ? {
  undef       => "https://github.com/jss-emr/jss-reports/archive/master.zip",
  "jss"       => "https://github.com/jss-emr/jss-reports/archive/master.zip",
  default        => "https://github.com/jss-emr/jss-reports/archive/master.zip",
  "search"       => "https://github.com/Bhamni/search-reports/archive/master.zip",
  "lokbiradari"  => "https://github.com/Bhamni/lokbiradari-reports/archive/master.zip",
  "possible"  => "https://github.com/Bhamni/possible-reports/archive/master.zip"
}

######################## JASPER CONFIG END##############################################