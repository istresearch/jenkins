FROM jenkins
USER root


RUN apt-get update && \
apt-get install -qy \
  build-essential \
  python-dev \
  libxml2-dev \
  libxslt-dev \
  libffi-dev \
  libssl-dev \
  libmysqlclient-dev \
  python-mysqldb \
  python-pip \
  libjpeg-dev \
  zlib1g-dev \
  libblas-dev\
  liblapack-dev \
  libatlas-base-dev \
  apt-transport-https \
  ca-certificates \
  gfortran && \
rm -rf /var/lib/apt/lists/*

# Install docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys \
      58118E89F3A912897C070ADBF76221572C52609D && \
    echo deb https://apt.dockerproject.org/repo debian-jessie main >> \
      /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -qy docker-engine=1.11.2-0~jessie

RUN pip install cffi --upgrade
RUN pip install pip2pi ansible==2.0

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# add the jenkins user to the docker group so that sudo is not required to run docker commands
RUN gpasswd -a jenkins docker
USER jenkins
