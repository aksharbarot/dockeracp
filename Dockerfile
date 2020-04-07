FROM ubuntu:16.04

MAINTAINER "Akshar Barot" <axar1990@gmail.com>

RUN apt-get -y update && apt-get install -y \
    genisoimage \
    libffi-dev \
    libssl-dev \
    git \
    sudo \
    ipmitool \
    maven \
    openjdk-8-jdk \
    python-dev \
    python-setuptools \
    python-pip \
    wget \
    unzip \
    python-mysql.connector \
    supervisor

RUN echo 'mysql-server mysql-server/root_password password root' |  debconf-set-selections; \
    echo 'mysql-server mysql-server/root_password_again password root' |  debconf-set-selections;

RUN apt-get install -qqy mysql-server && \
    apt-get clean all && \
    mkdir /var/run/mysqld; \
    chown mysql /var/run/mysqld

RUN echo '''sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"''' >> /etc/mysql/mysql.conf.d/mysqld.cnf

RUN service mysql restart; sleep 5;  mysqladmin -u root -proot password ''

#RUN pip install --allow-external mysql-connector-python mysql-connector-python
RUN pip install paramiko requests

RUN wget http://10.148.28.252/ISO/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8.zip -O /root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8.zip

RUN unzip /root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8.zip -d /root/

#RUN mv /root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8 /root

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf


ENV PYTHONPATH="/root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/tools/marvin"

WORKDIR /root/Accelerite-CloudPlatform-acp-4.11_RHEL8Support_HF8/

RUN mvn -Pdeveloper -Dsimulator -DskipTests clean install

RUN (/usr/bin/mysqld_safe &); \
    sleep 5; \
    mvn -Pdeveloper -pl developer -Ddeploydb; \
    mvn -Pdeveloper -pl developer -Ddeploydb-simulator;

EXPOSE 8080 8096

CMD ["/usr/bin/supervisord"]
