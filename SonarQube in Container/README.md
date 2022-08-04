# SonarQube container
### Description  
"Extend your toolset!
Docker Compose (herein referred to as compose) will use the Dockerfile if you add the build command to your project's docker-compose.yml.
Your Docker workflow should be to build a suitable Dockerfile for each image you wish to create, then use compose to assemble the images using the build command. "

# Task description
Create an installation for SonarQube (https://www.sonarqube.org/).
Sonar has to have separated database (postgresql)
Create a docker-compose for Jenkins which you created earlier.

## Prerequisites
Make sure you have already installed both Docker Engine and Docker Compose.
### Docker Host requirements
Because SonarQube uses an embedded Elasticsearch, make sure that your Docker host configuration complies with the Elasticsearch production mode requirements and File Descriptors configuration.

Elasticsearch uses a **mmapfs** directory by default to store its indices. The default operating system limits on mmap counts is likely to be too low, which may result in out of memory exceptions.

For example, on Linux, you can set the recommended values for the current session by running the following commands as root on the host:
```
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```
To set this value permanently, update the **vm.max_map_count** setting in **/etc/sysctl.conf**. 
To verify after rebooting, run 
```
sysctl vm.max_map_count
```
The RPM and Debian packages will configure this setting automatically. No further configuration is required.


## Dockerfile.jenkins
The image contains all the dependencies the Python application requires, including Python itself.
```
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
```

This tells Docker to:
- Build an image starting with the Jenkins official latest image.
- Set the environment variable CASC_JENKINS_CONFIG.
- Add persistent volume
- Copy jenkins-casc.yml file that contains configuration
- Add plugins and expose ports


## Compose file
This Compose file defines three services: **PostgresSQL**, **SonarQube**, and **Jenkins**.
```
version: '3.8'

services:

  postgresql:
    image: docker.io/bitnami/postgresql:13
    environment:
      - POSTGRESQL_USERNAME=bn_sonarqube
      - POSTGRESQL_PASSWORD=password
      - POSTGRESQL_DATABASE=bitnami_sonarqube
    volumes:
      - "postgresql_data:/bitnami/postgresql"
    expose:
      - "5423"

  sonar:
    image: docker.io/bitnami/sonarqube:latest
    depends_on:
      - postgresql
    environment:
      - SONARQUBE_DATABASE_HOST=postgresql
      - SONARQUBE_DATABASE_PORT_NUMBER=5432
      - SONARQUBE_DATABASE_NAME=bitnami_sonarqube
      - SONARQUBE_DATABASE_USER=bn_sonarqube
      - SONARQUBE_DATABASE_PASSWORD=password
    ports:
      - "81:9000"
    volumes:
      - "sonarqube_data:/bitnami/sonarqube"

  jenkins:
    container_name: jenkins
    restart: always
    image: jenkins/jenkins:lts
    environment:
      JENKINS_ADMIN_ID: "user"
      JENKINS_ADMIN_PASSWORD: "password"
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - "jenkins_home:/var/jenkins_home"

volumes:
  postgresql_data:
  sonarqube_data:
  jenkins_home:
```
## Persisting the application
If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the **/bitnami/sonarqube** and **/bitnami/postgresql** path.


# Build and run app with Compose
1. From your project directory, start up your application by running
```
docker compose up -d
```
Compose pulls all images, builds them, and starts the services you defined. In this case, the code is statically copied into the image at build time.

2. Enter http://localhost:81/ in a browser to see the application running.
You should see a SonarQube login window in your browser.

3. To login to SonarQube service use defualts environment variables:

- SONARQUBE_USERNAME: admin
- SONARQUBE_PASSWORD: bitnami


## Authors
* **Blazej Hinc**

## Acknowledgments
* Hat tip to anyone whose code was used
