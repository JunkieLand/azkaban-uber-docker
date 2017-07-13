#!/bin/bash

log () {
  echo ""
  echo "##### $1"
  echo ""
}
logTitle () {
  echo ""
  echo "########################"
  echo "##### "$1
  echo "########################"
  echo ""
}

source /usr/bin/env.sh

logTitle "PRERIQUIES"

log "Set write permission on log directory..."

sudo chmod +w $LOG_DIR


logTitle "DATABASE"

log "Stopping MySQL..."

sudo service mysql stop

log "Initializing database..."

sudo chown mysql:mysql $MYSQL_DATA_DIR
sudo -u mysql mysqld --initialize-insecure --user mysql --datadir $MYSQL_DATA_DIR

log "Starting MySQL..."

sudo service mysql start

log "Setting MySQL root password..."

mysql -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');"

log "Creating Azkaban database..."

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${MYSQL_DB};"

log "Create Azkaban database user..."

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PWD}';"

log "Set database permissions on Azkaban database..."

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT SELECT,INSERT,UPDATE,DELETE ON ${MYSQL_DB}.* to '${MYSQL_USER}'@'localhost' WITH GRANT OPTION;"

log "Create database tables..."

mysql -uroot -p${MYSQL_ROOT_PASSWORD} $MYSQL_DB < /usr/bin/create-all-sql-3.30.0.sql



logTitle "AZKABAN WEB SERVER"

log "Will generate azkaban.properties file for Azkaban Web Server..."

/usr/bin/azkaban-web-server.properties.sh

if [ -f $AZKABAN_WEBSERVER_PUBLIC_CONF_DIR/azkaban-users.xml ]; then
  log "Copy azkaban-users.xml file in conf directory since it exists..."
  cp $AZKABAN_WEBSERVER_PUBLIC_CONF_DIR/azkaban-users.xml $AZKABAN_WEBSERVER_CONF_DIR/
else
  log "No azkaban-users.xml file found"
fi


logTitle "AZKABAN EXECUTOR SERVER"

log "Will generate azkaban.properties file for Azkaban Executor Server..."

/usr/bin/azkaban-exec-server.properties.sh


logTitle "START"

log "Will start Azkaban Executor Server..."

cd $AZKABAN_EXECSERVER_INSTALL_DIR
./bin/azkaban-executor-start.sh

log "Will start Azkaban Web Server..."

cd $AZKABAN_WEBSERVER_INSTALL_DIR
./bin/azkaban-web-start.sh

PID=$(cat $AZKABAN_WEBSERVER_INSTALL_DIR/currentpid)
while [ -e /proc/$PID ]
do
    sleep 10
done

log "Start script ended"