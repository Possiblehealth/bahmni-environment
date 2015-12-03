#!/bin/bash

BAHMNI_SCRIPTS=/usr/local/bahmni/bin
source $BAHMNI_SCRIPTS/bahmni_functions.sh
source $BAHMNI_SCRIPTS/db_backup_function.sh

if [[ $EUID -ne 0 ]]; then
   echo -e "$red[Error]$original This script must be run as root or with sudo!" 1>&2
   exit 1
fi


# stops all services
stop() {
    echo -e "=================================================================="
    echo -e "$yellow[WARNING]$original All services required for Bahmni will be shut down"
    echo -e "Make sure you run [bahmni start] before you use Bahmni"
    echo -e "=================================================================="

    echo -e "Checking $yellow openerp-server $original service..."
    if(is_service_running openerp-server) then
        stop_service openerp
    fi 
    
    echo -e "Checking $yellow tomcat $original service..."
    if(is_service_running tomcat) then
        stop_service tomcat
    fi

    echo -e "Checking $yellow nagios $original service..."
    if(is_service_running nagios) then
        stop_service nagios
    fi

    sleep 3
    stop_service httpd
}

status() {
    up_count=0
    down_count=0
    for service in httpd nagios mysql pgsql-9.2 wvdial
    do
        if(is_service_running $service) then
            echo -e "$service...... $green[Running] $original"
            let up_count=$up_count+1
        else
            echo -e "$service...... $yellow[Not Running]$original"
            let down_count=$down_count+1
        fi
    done
    services_count="5"
    if (("$services_count" != "$up_count")); then
        echo -e "=================================================================="
        echo -e "$red[ERROR]$original $down_count out of $services_count services are not running"
        echo -e "$red[ERROR]$original Please run [bahmni start] to bring up all services."
        echo -e "=================================================================="
    else
        echo -e "=================================================================="
        echo -e "$green Bahmni is ready to be used $original"
        echo -e "=================================================================="
    fi
}

# starts all services
start() {
    echo -e "=================================================================="
    echo -e "All services required for Bahmni will be starting up"
    echo -e "Run [bahmni.sh status] to check the status"
    echo -e "=================================================================="
    start_service mysql
    start_pgsql
    start_service httpd
    start_service nagios
    echo -e "=================================================================="
    echo -e "$green Bahmni services started... $original"
    echo -e "=================================================================="
}

# restarts all services
restart() {
    echo -e "=================================================================="
    echo -e "Restarting all services required for Bahmni"
    echo -e "Run [bahmni status] to check the status"
    echo -e "=================================================================="
    stop
    sleep 3
    start
}

backup() {
    # Ensure DBs are running if they are down
    start_service mysql
    start_pgsql
    sleep 3
    all_dbs_backup /backup
}

printUsage() {
    echo -e "-----------------------------------------"
    echo -e "Command line tool for managing bahmni"
    echo -e "\nUsage:"
    echo -e "\tbahmni start"
    echo -e "\tbahmni stop"
    echo -e "\tbahmni restart"
    echo -e "\tbahmni logs [ tomcat | access | openerp ]"
    echo -e "\tbahmni backup-all-dbs"
    echo -e "\tbahmni status"
    echo -e "\n-----------------------------------------"
}

case "$1" in
    "help" )
        printUsage
        ;;
    "start" )
        start
        ;;
    "stop" )
        stop
        ;;
    "restart" )
        restart
        ;;
    "backup-all-dbs" )
        backup
        ;;
    "logs" )
        get_logs
        ;;
    "status" )
        status
        ;;
    * )
        echo -e "$red[ERROR]$original Invalid option $1"
        printUsage
        ;;
esac

tput sgr0

echo ""
read -p "Please press any key to exit ..." -s -n1
