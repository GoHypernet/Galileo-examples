FROM ubuntu

RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get dist-upgrade -y && \
     apt-get -y autoremove && \
     apt-get clean && \
     apt-get install -y unzip

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd


RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /var/run/ngrok
COPY ngrok-stable-linux-amd64.zip /var/run/ngrok
RUN unzip /var/run/ngrok/ngrok-stable-linux-amd64.zip -d /var/run/ngrok
RUN rm /var/run/ngrok/ngrok-stable-linux-amd64.zip 

COPY startup.sh /var/run/ngrok

CMD ["bash", "/var/run/ngrok/startup.sh"]
