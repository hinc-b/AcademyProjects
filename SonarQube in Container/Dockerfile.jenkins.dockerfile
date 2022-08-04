FROM jenkins/jenkins:lts

#Environment variables
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yml

#Volume
VOLUME /var/jenkins_home

#Copy config file
COPY jenkins-casc.yml /var/jenkins_home/casc.yml

#Plugins added
COPY --chown=jenkins:jenkins jenkins-plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

#Port expose for main web interface
EXPOSE 8080

#Port expose that will be used by attached slave agents:
EXPOSE 50000