FROM jenkins:2.60.3
USER root


RUN apt-get update && \
apt-get install -qy \
  apt-utils \
  libyaml-dev \
  build-essential \
  python-dev \
  libxml2-dev \
  libxslt-dev \
  libffi-dev \
  libssl-dev \
  default-libmysqlclient-dev \
  python-mysqldb \
  python-pip \
  libjpeg-dev \
  zlib1g-dev \
  libblas-dev\
  liblapack-dev \
  libatlas-base-dev \
  apt-transport-https \
  ca-certificates \
  wget \
  software-properties-common \
  zip \
  unzip \
  gfortran && \
rm -rf /var/lib/apt/lists/*

# Install docker
RUN wget https://download.docker.com/linux/debian/gpg && \
    apt-key add gpg && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee -a /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -qy docker-ce

# Install compose
RUN curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN pip install cffi --upgrade
RUN pip install pip2pi ansible==2.0


COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# add the jenkins user to the docker group so that sudo is not required to run docker commands
RUN groupmod -g 1026 docker && gpasswd -a jenkins docker
USER jenkins
