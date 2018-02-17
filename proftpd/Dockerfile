FROM debian:jessie

MAINTAINER FLORIAN AJIR <florian@tag-walk.com>

RUN apt-get update && apt-get install -y \
    proftpd \
    openssl

ADD proftpd.conf /etc/proftpd/proftpd.conf
RUN chown root:root /etc/proftpd/proftpd.conf
ADD ftpd.passwd /etc/proftpd/ftpd.passwd
RUN chown root:root /etc/proftpd/ftpd.passwd

#RUN /usr/sbin/ftpasswd --passwd --file=/etc/proftpd/ftpd.passwd --name=tagwalk --uid=1000 --gid=1000 --home=/home/ftp --shell=/bin/false

RUN groupadd tagwalk
RUN useradd -g tagwalk -s /bin/false -d /home/ftp tagwalk

RUN export uid=$(id -u tagwalk)
RUN export gid=$(id -g tagwalk)

# copy the proftpd.conf file to /etc/proftpd.conf
COPY proftpd.conf /etc/proftpd/proftpd.conf
COPY ftpd.passwd /etc/proftpd/ftpd.passwd

RUN chmod 600 /etc/proftpd/ftpd.passwd

EXPOSE 20 21

CMD	["proftpd", "--nodaemon"]