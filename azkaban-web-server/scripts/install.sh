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


logTitle "DATABASE"

log "Will create database data directory..."

mkdir $MYSQL_DATA_DIR

log "Will install MySQL server..."

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

log "Will generate my.cnf configuration file for MySQL..."

/tmp/my.cnf.sh


logTitle "AZKABAN WEB SERVER"

log "Unarchive Azkaban Web Server package..."

tar -xf /tmp/azkaban-web-server-3.30.0.tar.gz -C $HOME/

log "Add extlib, plugins, conf, public-conf and log directories for Azkaban Web Server..."

mkdir $AZKABAN_SERVER_EXTLIB_DIR $AZKABAN_SERVER_PLUGINS_DIR $AZKABAN_SERVER_CONF_DIR $AZKABAN_SERVER_PUBLIC_CONF_DIR $LOG_DIR

log "Copy MySQL connector jar in extlib directory..."

sudo mv /tmp/mysql-connector-java-5.1.42-bin.jar $AZKABAN_SERVER_EXTLIB_DIR/
sudo chown azkaban:azkaban $AZKABAN_SERVER_EXTLIB_DIR/mysql-connector-java-5.1.42-bin.jar

log "Will generate global.properties file..."

/tmp/global.properties.sh

log "Will copy log4.properties file..."

sudo mv /tmp/log4j.properties $AZKABAN_SERVER_CONF_DIR/
sudo chown azkaban:azkaban $AZKABAN_SERVER_CONF_DIR/log4j.properties

log "Will copy azkaban-users.xml file..."

cp /tmp/azkaban-users.xml $AZKABAN_SERVER_CONF_DIR/