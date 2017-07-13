#!/bin/bash

source /usr/bin/env.sh


# Generate conf file
FILE=$AZKABAN_WEBSERVER_CONF_DIR/azkaban.properties
rm -f $FILE
touch $FILE

cat >> $FILE << EOF

# Azkaban Personalization Settings
azkaban.name=$AZKABAN_NAME
azkaban.label=$AZKABAN_LABEL
azkaban.color=#FF3601
azkaban.default.servlet.path=/index
web.resource.dir=web/
default.timezone.id=$TIMEZONE

# Azkaban UserManager class
user.manager.class=azkaban.user.XmlUserManager
user.manager.xml.file=conf/azkaban-users.xml

# Loader for projects
executor.global.properties=conf/global.properties
azkaban.project.dir=$AZKABAN_PROJECT_DIR

database.type=mysql
mysql.port=3306
mysql.host=localhost
mysql.database=$MYSQL_DB
mysql.user=$MYSQL_USER
mysql.password=$MYSQL_PWD
mysql.numconnections=100

# Velocity dev mode
velocity.dev.mode=false

# Azkaban Jetty server properties.
jetty.use.ssl=false
jetty.maxThreads=25
jetty.port=8081

lockdown.create.projects=false
cache.directory=cache

# Azkaban Executor settings
executor.host=localhost
executor.port=12321

# JMX stats
jetty.connector.stats=true
executor.connector.stats=true

# Azkaban plugin settings
azkaban.jobtype.plugin.dir=plugins/jobtypes

EOF



if [ "$EMAIL_ENABLED" == "True" ]; then

cat >> $FILE << EOF
# mail settings
mail.sender=$EMAIL_SENDER
mail.host=$EMAIL_HOST:$EMAIL_PORT
mail.user=$EMAIL_HOST_USER
mail.password=$EMAIL_HOST_PASSWORD
job.failure.email=
job.success.email=
EOF

fi