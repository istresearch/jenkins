FROM jenkins
USER root
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*
USER jenkins
