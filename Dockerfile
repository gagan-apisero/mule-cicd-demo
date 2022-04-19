FROM maven:3.8.5-jdk-11-slim

RUN apt-get update && apt-get -y install git

CMD [ "sh","-c", "mvn --version"]
