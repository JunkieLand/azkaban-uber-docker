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
  apt-get install -y perl vim less sudo mlocate curl openjdk-8-jre openssh-client && \
  echo "azkaban    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER azkaban
WORKDIR /home/azkaban

COPY lib/azkaban-web-server.tar.gz /tmp/
COPY lib/azkaban-exec-server.tar.gz /tmp/
COPY lib/mysql-connector-java-5.1.42-bin.jar /tmp/
COPY scripts/env.sh /usr/bin/
COPY scripts/install.sh /tmp/
COPY scripts/start.sh /usr/bin/
COPY conf/my.cnf.sh /tmp/
COPY conf/create-all-sql.sql /usr/bin/
COPY conf/azkaban-web-server.properties.sh /usr/bin/
COPY conf/global-web-server.properties.sh /tmp/
COPY conf/azkaban-users.xml /tmp/
COPY conf/log4j-web-server.properties /tmp/
COPY conf/commonprivate-web-server.properties /tmp/
COPY conf/azkaban-exec-server.properties.sh /usr/bin/
COPY conf/global-exec-server.properties.sh /tmp/
COPY conf/log4j-exec-server.properties /tmp/
COPY conf/commonprivate-exec-server.properties /tmp/


RUN /tmp/install.sh

EXPOSE 8081

VOLUME ["/home/azkaban/mysql-data", "/home/azkaban/projects", "/home/azkaban/public-conf", "/home/azkaban/logs", "/home/azkaban/.ssh"]

CMD /usr/bin/start.sh
