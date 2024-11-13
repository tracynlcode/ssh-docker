FROM --platform=linux/amd64 ubuntu:latest

ARG user_id
ARG user_gid

RUN apt update

RUN apt install  openssh-server sudo -y

RUN groupadd --gid ${user_gid} test && \
    useradd --create-home --no-log-init --uid ${user_id} --gid test test

RUN usermod -aG sudo test
RUN usermod -aG docker test

RUN echo 'test ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers

RUN mkdir ~/.ssh && chown -R test:test ~/.ssh && chmod 700 ~/.ssh



RUN service ssh start

RUN  echo 'test:test' | chpasswd

EXPOSE 22

USER test
WORKDIR /home/test

CMD ["/usr/sbin/sshd","-D"]
