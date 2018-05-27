#!/bin/bash

echo "=> Executing Customization script"
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_server() {
  until `$JBOSS_CLI -c --user=${WILDFLY_USER} --password=${WILDFLY_PASSWORD} ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

echo "=> Starting WildFly server"
echo "JBOSS_HOME  : " $JBOSS_HOME
echo "JBOSS_CLI   : " $JBOSS_CLI
echo "JBOSS_MODE  : " $JBOSS_MODE
echo "JBOSS_CONFIG: " $JBOSS_CONFIG

echo $JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG &
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG &

echo "=> Create Wildfly user"
/opt/jboss/wildfly/bin/add-user.sh ${WILDFLY_USER} ${WILDFLY_PASSWORD} --silent

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Add Datasource"
$JBOSS_HOME/add-datasource.sh

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c --user=${WILDFLY_USER} --password=${WILDFLY_PASSWORD} ":shutdown"
else
  $JBOSS_CLI -c --user=${WILDFLY_USER} --password=${WILDFLY_PASSWORD} "/host=*:shutdown"
fi

echo "=> Deploy application"
mv ${JBOSS_HOME}/application.war ${JBOSS_HOME}/standalone/deployments/

echo "=> Restarting WildFly"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG