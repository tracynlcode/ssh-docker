FROM --platform=linux/amd64 ubuntu:latest

RUN apt update

RUN apt install  openssh-server sudo -y

RUN usermod -aG sudo test
RUN usermod -aG docker test
RUN useradd -m -s /bin/bash test
RUN echo 'test ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers
RUN mkdir /var/run/sshd
RUN mkdir ~/.ssh && chown -R test:test ~/.ssh && chmod 700 ~/.ssh

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN service ssh start && bash

RUN echo 'test:test' | chpasswd
RUN echo 'root:root' | chpasswd

RUN apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
