FROM ubuntu:16.04

RUN useradd --create-home --uid 1042 azkaban

ENV AZKABAN_NAME "Test"
ENV AZKABAN_LABEL "My Local Azkaban"
ENV TIMEZONE "Europe/Paris"
ENV EMAIL_ENABLED "False"
ENV EMAIL_SENDER "noreply@example.com"
ENV EMAIL_HOST "localhost"
ENV EMAIL_PORT 25
ENV EMAIL_HOST_USER "user"
ENV EMAIL_HOST_PASSWORD "password"

RUN \
  apt-get update -qq && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-get install -y perl vim less sudo mlocate curl openjdk-8-jre && \
  echo "azkaban    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER azkaban
WORKDIR /home/azkaban

COPY lib/azkaban-web-server-3.30.0.tar.gz /tmp/
COPY lib/mysql-connector-java-5.1.42-bin.jar /tmp/
COPY scripts/env.sh /usr/bin/
COPY scripts/install.sh /tmp/
COPY scripts/start.sh /usr/bin/
COPY conf/my.cnf.sh /tmp/
COPY conf/create-all-sql-3.30.0.sql /usr/bin/
COPY conf/azkaban.properties.sh /usr/bin/
COPY conf/global.properties.sh /tmp/
COPY conf/azkaban-users.xml /tmp/
COPY conf/log4j.properties /tmp/

RUN /tmp/install.sh

EXPOSE 3306 8081

VOLUME ["/home/azkaban/mysql-data", "/home/azkaban/projects", "/home/azkaban/public-conf", "/home/azkaban/logs"]

CMD /usr/bin/start.sh
