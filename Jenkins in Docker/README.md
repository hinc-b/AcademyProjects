# Jenkins in Docker
### Description  
Jenkins with AWS plugins in Dockerfile.

# Task description
- Install Jenkins (do not use FROM jenkins!) 
- Install plugins for AWS (these plugins need to be available in container, not installed after run!): EC2, S3, IAM (these plugins must be ready, not configured with credentials, etc.) 
- Keep pipelines configuration and history as persistent (mount volume, or any other suitable option) 
- Jenkins must be secured with user and password 

## Prerequisites
Make sure you have already installed both Docker Engine.

## Dockerfile
The image contains:
```
FFROM openjdk:11

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
```

This tells Docker to:
- Build an image starting with the Java openjdk:11 image
- Adds environmental variables
- Adds jenkins plugin manager
- Installs Jenkins
- Installs required plugins
- Copy plugins
- Copy casc.yaml file with configuration, that adds user - admin
- Mounts volume and set the working directory to /data
- Add metadata to the image to describe that the container is listening on port 8000
- Set the default command for the container to run jenkins.

## Build and run Dockerfile
1. From your project directory, start up with image building by running:
```
docker build -t jenkins-openjdk:0.1 .
```
**docker build** converts your Dockerfile into an image.

2. Check if image has been built:
```
docker images
```

3. Create the container and run it:  
```
docker run -itd -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins jenkins-openjdk:0.1
```

4. Enter http://localhost:8000/ in a browser to see the jenkins running.

5. Everything should works now. If you want to log in once again, please use password from InitialAdminPassword and admin as a UserId.

## Authors
* **Blazej Hinc**

## Acknowledgments
* Hat tip to anyone whose code was used
