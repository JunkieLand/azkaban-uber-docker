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


log "Set the timezone at OS level..."

echo $TIMEZONE | sudo tee /etc/timezone

log "Disable SSH Host key check..."

echo "    StrictHostKeyChecking no" | sudo tee -a /etc/ssh/ssh_config
echo "    UserKnownHostsFile=/dev/null" | sudo tee -a /etc/ssh/ssh_config


logTitle "DATABASE"

log "Will create database data directory..."

mkdir $MYSQL_DATA_DIR

log "Will install MySQL server..."

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

log "Will generate my.cnf configuration file for MySQL..."

/tmp/my.cnf.sh



logTitle "AZKABAN WEB SERVER"

log "Unarchive Azkaban Web Server package..."

tar -xf /tmp/azkaban-web-server.tar.gz -C $HOME/

log "Rename azkaban-web-server directory..."

mv $HOME/azkaban-web-server* azkaban-web-server

log "Add extlib, plugins, conf, public-conf and log directories for Azkaban Web Server..."

mkdir $AZKABAN_WEBSERVER_EXTLIB_DIR $AZKABAN_WEBSERVER_PLUGINS_DIR $AZKABAN_WEBSERVER_CONF_DIR $AZKABAN_WEBSERVER_PUBLIC_CONF_DIR $LOG_DIR

log "Copy MySQL connector jar in extlib directory for Azkaban Web Server..."

sudo cp /tmp/mysql-connector-java-5.1.42-bin.jar $AZKABAN_WEBSERVER_EXTLIB_DIR/
sudo chown azkaban:azkaban $AZKABAN_WEBSERVER_EXTLIB_DIR/mysql-connector-java-5.1.42-bin.jar

log "Will generate global.properties file for Azkaban Web Server..."

/tmp/global-web-server.properties.sh

log "Will copy log4.properties file for Azkaban Web Server..."

sudo mv /tmp/log4j-web-server.properties $AZKABAN_WEBSERVER_CONF_DIR/log4j.properties
sudo chown azkaban:azkaban $AZKABAN_WEBSERVER_CONF_DIR/log4j.properties

log "Will copy azkaban-users.xml file for Azkaban Web Server..."

cp /tmp/azkaban-users.xml $AZKABAN_WEBSERVER_CONF_DIR/

log "Will create jobtype directory for Azkaban Web Server..."

mkdir -p $AZKABAN_WEBSERVER_JOBTYPE_DIR

log "Will copy commonprivate.properties file for Azkaban Web Server..."

sudo mv /tmp/commonprivate-web-server.properties $AZKABAN_WEBSERVER_JOBTYPE_DIR/commonprivate.properties
sudo chown azkaban:azkaban $AZKABAN_WEBSERVER_JOBTYPE_DIR/commonprivate.properties



logTitle "AZKABAN EXECUTOR SERVER"

log "Unarchive Azkaban Executor Server package..."

tar -xf /tmp/azkaban-exec-server.tar.gz -C $HOME/

log "Rename azkaban-exec-server directory..."

mv $HOME/azkaban-exec-server* azkaban-exec-server

log "Add extlib, plugins, conf directories for Azkaban Executor Server..."

mkdir $AZKABAN_EXECSERVER_EXTLIB_DIR $AZKABAN_EXECSERVER_PLUGINS_DIR $AZKABAN_EXECSERVER_CONF_DIR

log "Copy MySQL connector jar in extlib directory for Azkaban Executor Server..."

sudo cp /tmp/mysql-connector-java-5.1.42-bin.jar $AZKABAN_EXECSERVER_EXTLIB_DIR/
sudo chown azkaban:azkaban $AZKABAN_EXECSERVER_EXTLIB_DIR/mysql-connector-java-5.1.42-bin.jar

log "Will generate global.properties file for Azkaban Executor Server..."

/tmp/global-exec-server.properties.sh

log "Will copy log4.properties file for Azkaban Executor Server..."

sudo mv /tmp/log4j-exec-server.properties $AZKABAN_EXECSERVER_CONF_DIR/log4j.properties
sudo chown azkaban:azkaban $AZKABAN_EXECSERVER_CONF_DIR/log4j.properties

log "Will create jobtype directory for Azkaban Executor Server..."

mkdir -p $AZKABAN_EXECSERVER_JOBTYPE_DIR

log "Will copy commonprivate.properties file for Azkaban Executor Server..."

sudo mv /tmp/commonprivate-exec-server.properties $AZKABAN_EXECSERVER_JOBTYPE_DIR/commonprivate.properties
sudo chown azkaban:azkaban $AZKABAN_EXECSERVER_JOBTYPE_DIR/commonprivate.properties

log "Create Azkaban Executor Server execution directory..."

mkdir -p $AZKABAN_EXEC_EXECUTION_DIR