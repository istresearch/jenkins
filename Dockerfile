FROM jenkins
USER root

RUN apt-get update && apt-get install -y build-essential python-dev libxml2-dev libxslt-dev libffi-dev libssl-dev libmysqlclient-dev python-mysqldb python-pip libjpeg-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN pip install pip2pi ansible==2.0

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

USER jenkins
