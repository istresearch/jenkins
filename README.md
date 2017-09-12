# jenkins-ist
Github repo for automated builds of a custom version of Jenkins on docker hub.

## Installation

Ensure /data/jenkins/ directory is created and has the correct permissions.
- If you are using vagrant, the directory should be owned by vagrant.
  If you are logged in to an Ubuntu EC2 instance, then the ubuntu user should own the directory.
- If it needs to be created:
  1. Run *sudo mkdir /data*
  2. Run *sudo mkdir /data/jenkins*
  3. Run *sudo chown 1000 /data/jenkins*

## Building

To build the Jenkins docker image that you want to run in a container. Ensure
you are in the `/jenkins` directory with the *Dockerfile* and run

```Bash
docker build -t istresearch/jenkins:[Version]
```

Alternatively you can do.
```Bash
docker-compose build
```

> The first approach allows you to specify the tags that you want to use for the
docker image. Meanwhile, with the second approach,  you are forced to use
whatever is defined in the `docker-compose.yml` file

## Running

To run the container, type the following

```Bash
# Run without mounting the docker socket
docker run \
  -d \
  --name jenkins \
  --net=host \
  -p 8080:8080 \
  -p 5000:5000 \
  -v /data/jenkins:/var/jenkins_home \
  -u 1000 \
  istresearch/jenkins:latest

# Run with the docker socket mounted
docker run \
  -d \
  --name jenkins \
  --net=host \
  -p 8080:8080 \
  -p 5000:5000 \
  -v /data/jenkins:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 1000 \
  istresearch/jenkins:latest
```
- *-d* to run in the background
- *--net=host* so the container shares the host network stack and has access to the /etc/hosts for network communication
- *-p 8080:8080* so the 8080 port in the container receives all requests to port 8080 on the host. Jenkins runs on Tomcat, which uses port 8080 as the default
- *-p 5000:5000* required to attach slave servers; port 50000 is used to communicate between master and slaves
- *-v /data/jenkins:/var/jenkins_home* to bind host directory /data/jenkins to the container directory /var/jennkins_home
- *-v /var/run/docker.sock:/var/run/docker.sock* Mounts the docker socket into the container 
- *-u 1000* jenkins user uid is 1000, same as ubuntu and vagrant uid's are 1000

Alternatively, you can run one of the following

```Bash
# Uses the istresearch/jenkins:latest image
docker-compose up -d

# Runs a local dev version, which allows you to modify the Dockerfile for local experimentation.
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
```
