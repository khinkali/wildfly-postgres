FROM jboss/keycloak-adapter-wildfly:4.0.0.Beta2

MAINTAINER Robert Brem <robert.brem@adesso.ch>

WORKDIR ${JBOSS_HOME}
ADD postgresql-42.2.2.jar ${JBOSS_HOME}
USER root
ADD start.sh ${JBOSS_HOME}
RUN chown jboss:jboss start.sh
ADD add-datasource.sh ${JBOSS_HOME}
RUN chown jboss:jboss add-datasource.sh
USER jboss

CMD ${JBOSS_HOME}/start.sh
