FROM jenkins/jenkins:lts

ARG ADMIN_USER="admin"
ENV ADMIN_USERNAME $ADMIN_USER

ARG ADMIN_PASS="password"
ENV ADMIN_PASSWORD $ADMIN_PASS

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git python make curl unzip && \
    rm -rf /var/lib/apt/lists/*
 
USER jenkins

RUN echo "envinject\npython\ncredentials\nblueocean\nantisamy-markup-formatter" > /tmp/plugins.txt && \
    /usr/local/bin/install-plugins.sh < /tmp/plugins.txt && \
    rm -rf /tmp/plugins.txt

ADD groovy-scripts /var/jenkins_home/init.groovy.d/

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]

