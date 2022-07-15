FROM openjdk:11

#Environmental variables
ENV JENKINS_HOME /opt/jenkins
ENV JENKINS-USER admin
ENV JENKINS_PASSWD password
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
##immediately shown the dashboard without the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

#Installs plugins and jenkins and updates existing packages
ADD https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.8/jenkins-plugin-manager-2.12.8.jar /usr/share/jenkins/ref/jenkins-plugin-manager.jar
RUN curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null \
&& echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null \
&& apt-get update \
&& apt-get install -y jenkins
COPY jenkins-plugins.txt /usr/share/jenkins/ref/plugins.txt

#Configuration file - adds user
COPY casc.yaml /var/jenkins_home/casc.yaml

#Volume mounted and Workdir
VOLUME $JENKINS_HOME/data
WORKDIR $JENKINS_HOME

EXPOSE 8080
RUN java -jar /usr/share/jenkins/ref/jenkins-plugin-manager.jar -d /opt/jenkins/plugins --war /usr/share/java/jenkins.war --plugin-file /usr/share/jenkins/ref/plugins.txt
CMD ["jenkins"]
