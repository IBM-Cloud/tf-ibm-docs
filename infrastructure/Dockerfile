FROM jenkinsci/jenkins:lts

USER root

RUN apt-get update && apt-get install -y ruby ruby-dev gcc make
RUN gem install bundler

USER jenkins
