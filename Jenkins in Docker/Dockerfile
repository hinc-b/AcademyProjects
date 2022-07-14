FROM openjdk:8

#Updates exisiting packages. Tools
RUN apt-get update -qq && apt-get install -qq curl git nano && apt-get clean

#Environmental variables
ENV JENKINS_HOME /opt/jenkins
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
##immediately shown the dashboard without the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

#Installs Jenkins
RUN mkdir -p $JENKINS_HOME
ADD https://get.jenkins.io/war-stable/2.346.1/jenkins.war $JENKINS_HOME/jenkins.war

#Installs plugins
RUN mkdir -p $JENKINS_HOME/plugins; for plugin in ec2 s3 aws-java-sdk-iam configuration-as-code; \
  do curl -sf -o $JENKINS_HOME/plugins/${plugin}.hpi -L $JENKINS_MIRROR/plugins/${plugin}/latest/${plugin}.hpi; done

#Configuration file - adds user
COPY casc.yaml /var/jenkins_home/casc.yaml

#Volume mounted and Workdir
VOLUME $JENKINS_HOME/data
WORKDIR $JENKINS_HOME

EXPOSE 8080
CMD [ "java", "-jar", "jenkins.war" ]