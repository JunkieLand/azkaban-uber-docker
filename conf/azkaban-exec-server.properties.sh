#!/bin/bash

source /usr/bin/env.sh


# Generate conf file
FILE=$AZKABAN_EXECSERVER_CONF_DIR/azkaban.properties
rm -f $FILE
touch $FILE

cat >> $FILE << EOF

# Loader for projects
executor.global.properties=conf/global.properties

database.type=mysql
mysql.port=3306
mysql.host=localhost
mysql.database=$MYSQL_DB
mysql.user=$MYSQL_USER
mysql.password=$MYSQL_PWD
mysql.numconnections=100

# Azkaban Jetty server properties.
jetty.use.ssl=false
jetty.maxThreads=25
jetty.port=8081

lockdown.create.projects=false
cache.directory=cache

# Azkaban Executor settings
executor.host=localhost
executor.port=12321
executor.maxThreads=50
executor.flow.threads=30
flow.num.job.threads=10

azkaban.project.dir=$AZKABAN_EXECPROJECT_DIR
azkaban.execution.dir=$AZKABAN_EXEC_EXECUTION_DIR

# JMX stats
jetty.connector.stats=true
executor.connector.stats=true

# Azkaban plugin settings
azkaban.jobtype.plugin.dir=plugins/jobtypes

EOF
