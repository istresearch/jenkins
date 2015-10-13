FROM jenkins
USER root
RUN apt-get update && apt-get install -y build-essential python-dev libxml2-dev libxslt-dev && rm -rf /var/lib/apt/lists/*
USER jenkins
