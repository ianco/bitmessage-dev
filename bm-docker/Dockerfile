FROM ubuntu:16.10
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install python openssl libssl-dev git python-msgpack python-qt4
RUN apt-get -y install libmessaging-menu-dev
RUN useradd -m -d /home/bitmsg bitmsg
COPY config/* /home/bitmsg/.config/PyBitmessage/
RUN chown -R bitmsg:bitmsg /home/bitmsg/.config
EXPOSE 8444
EXPOSE 8555



