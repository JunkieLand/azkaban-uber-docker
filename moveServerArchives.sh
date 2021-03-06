#!/bin/bash

AZKABAN_PROJECT=$HOME/Projects/azkaban
AZKABAN_UBER_DOCKER_DIR=$HOME/Projects/azkaban-uber-docker

AZKABAN_WEB_SERVER_PACKAGE_DIR=$AZKABAN_PROJECT/azkaban-web-server/build/distributions
AZKABAN_WEB_SERVER_PACKAGE_FILE=azkaban-web-server.tar.gz
AZKABAN_EXEC_SERVER_PACKAGE_DIR=$AZKABAN_PROJECT/azkaban-exec-server/build/distributions
AZKABAN_EXEC_SERVER_PACKAGE_FILE=azkaban-exec-server.tar.gz

AZKABAN_UBER_DOCKER_LIB_DIR=$AZKABAN_UBER_DOCKER_DIR/lib


cd $AZKABAN_PROJECT

./gradlew clean build


cd $AZKABAN_WEB_SERVER_PACKAGE_DIR

cp *.tar.gz $AZKABAN_UBER_DOCKER_LIB_DIR/$AZKABAN_WEB_SERVER_PACKAGE_FILE


cd $AZKABAN_EXEC_SERVER_PACKAGE_DIR

cp *.tar.gz $AZKABAN_UBER_DOCKER_LIB_DIR/$AZKABAN_EXEC_SERVER_PACKAGE_FILE

