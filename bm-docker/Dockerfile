FROM ubuntu:16.10
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install python openssl libssl-dev git python-msgpack python-qt4
RUN apt-get -y install libmessaging-menu-dev
COPY config/* \~/.config/PyBitmessage/
EXPOSE 8444
EXPOSE 8555



