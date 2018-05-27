FROM jboss/wildfly:12.0.0.Final

MAINTAINER Robert Brem <robert.brem@adesso.ch>

ENV KEYCLOAK_VERSION 4.0.0.Beta3
WORKDIR /opt/jboss/wildfly
RUN curl -L https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-$KEYCLOAK_VERSION.tar.gz | tar zx
WORKDIR /opt/jboss
RUN sed -i -e 's/<extensions>/&\n        <extension module="org.keycloak.keycloak-adapter-subsystem"\/>/' $JBOSS_HOME/standalone/configuration/standalone.xml && \
    sed -i -e 's/<profile>/&\n        <subsystem xmlns="urn:jboss:domain:keycloak:1.1"\/>/' $JBOSS_HOME/standalone/configuration/standalone.xml

WORKDIR ${JBOSS_HOME}
ADD postgresql-42.2.2.jar ${JBOSS_HOME}
USER root
ADD start.sh ${JBOSS_HOME}
RUN chown jboss:jboss start.sh
ADD add-datasource.sh ${JBOSS_HOME}
RUN chown jboss:jboss add-datasource.sh
USER jboss

CMD ${JBOSS_HOME}/start.sh
