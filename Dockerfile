FROM jenkins
USER root

RUN apt-get update && \ 
    apt-get install -y build-essential \ 
      python-dev \ 
      libxml2-dev \ 
      libxslt-dev \ 
      libffi-dev \ 
      libssl-dev \ 
      python-pip && \ 
    rm -rf /var/lib/apt/lists/*

RUN pip install pip2pi \ 
      ansible==1.9.2

ADD jenkins-ansible /var/jenkins_home/jenkins-ansible
WORKDIR /var/jenkins_home/jenkins-ansible
RUN ansible-playbook jenkins-setup.yml -c local

USER jenkins

