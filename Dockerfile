FROM python:3.6-slim

COPY mlflow /mlflow

SHELL [ "/bin/bash", "-c" ]

RUN sed -i 's_deb.debian.org_mirror.kakao.com_g' /etc/apt/sources.list &&\
        apt-get update &&\
        apt-get install -y vim

RUN apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 wget
RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh &&\
bash Anaconda3-2020.02-Linux-x86_64.sh -b
RUN source /root/anaconda3/bin/activate && conda init
RUN pip install mlflow
RUN pip install pysftp

ENV GIT_PYTHON_REFRESH=quiet
RUN apt-get install -y openssh-server

COPY entrypoint.sh /
COPY sshd_config /etc/ssh/sshd_config
RUN mkdir -p /run/sshd
RUN chmod +x entrypoint.sh
ENV PATH=/root/anaconda3/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY ./ssh-key /root/.ssh
RUN mkdir -p /run/sshd
RUN chmod 700 ~/.ssh &&\
chmod 600 ~/.ssh/id_rsa &&\
chmod 644 ~/.ssh/id_rsa.pub &&\
chmod 644 ~/.ssh/authorized_keys


ENTRYPOINT [ "/bin/bash", "-c", "/entrypoint.sh" ]
