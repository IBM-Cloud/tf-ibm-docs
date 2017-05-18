FROM jenkinsci/jenkins:lts

USER root

RUN apt-get update && apt-get install -y ruby make
RUN gem install bundler

USER jenkins
