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
```

This tells Docker to:
- Build an image starting with the Java openjdk:8 image.
- Updates exisiting packages.
- Adds environmental variables
- Installs Jenkins from .war file.
- Installs required plugins.
- Copy casc.yaml file with configuration, that adds user - admin.
- Mounts volume and set the working directory to /app.
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

5. Enter your container and find password to unlock jenkins:
```
docker exec -it container_id bash
```
Then copy contents of /opt/jenkins/secrets/initialAdminPassword and paste it.

6. Everything should works now. If you want to log in once again, please use password from InitialAdminPassword and admin as a UserId.

## Authors
* **Blazej Hinc**

## Acknowledgments
* Hat tip to anyone whose code was used
