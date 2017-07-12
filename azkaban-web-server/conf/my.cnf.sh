#!/bin/bash

source /usr/bin/env.sh


# Generate conf file
TMP_FILE=/tmp/my.cnf
FILE=/etc/mysql/my.cnf
touch $TMP_FILE

cat >> $TMP_FILE << EOF


#
# The MySQL database server configuration file.
#
# You can copy this to one of:
# - "/etc/mysql/my.cnf" to set global options,
# - "~/.my.cnf" to set user-specific options.
#
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

#
# * IMPORTANT: Additional settings that can override those from this file!
#   The files must end with '.cnf', otherwise they'll be ignored.
#

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/

[mysqld]

datadir = $MYSQL_DATA_DIR
max_allowed_packet=1024M

EOF

sudo mv $TMP_FILE $FILE
sudo chown root:root $FILE