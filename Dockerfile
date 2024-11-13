FROM --platform=linux/amd64 ubuntu:latest

RUN apt update

RUN apt install  openssh-server sudo -y

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test 

RUN usermod -aG sudo test

RUN echo 'test ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers

RUN mkdir ~/.ssh && chmod 700 ~/.ssh

RUN chown -R test:test /home/ubuntu/.ssh && chmod 700 /home/ubuntu/.ssh 

RUN service ssh start

RUN  echo 'test:test' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
