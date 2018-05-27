#!/bin/bash

$JBOSS_HOME/bin/jboss-cli.sh --connect --user=${WILDFLY_USER} --password=${WILDFLY_PASSWORD} <<EOF
batch
deploy ${JBOSS_HOME}/postgresql-42.2.2.jar
data-source add --jndi-name=${JNDI_NAME} --name=${DATASOURCE_NAME} --connection-url=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DATABASE_NAME} --driver-name=postgresql-42.2.2.jar --user-name=${DATABASE_USER} --password=${DATABASE_PASSWORD}
run-batch
exit
EOF