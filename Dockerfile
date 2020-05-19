FROM openjdk:8u232-jdk

LABEL maintainer="jonathanlichi@gmail.com"
ARG HBASE_VERSION=2.1.10
WORKDIR /tmp

# change apt source
# uncomment if needed
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#   echo "deb http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list 

RUN apt-get update && apt-get install -y wget iputils-ping lsof build-essential cmake

# alternative mirror site replace if needed
# RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz
RUN wget https://downloads.apache.org/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz
RUN tar -xzvf hbase-${HBASE_VERSION}-bin.tar.gz -C / && mv /hbase-${HBASE_VERSION} /hbase

COPY snappy-1.1.8.tar.gz /
RUN tar -xzvf /snappy-1.1.8.tar.gz -C /root/ && rm -rf /snappy-1.1.8.tar.gz
RUN cd /root/snappy-1.1.8/ && mkdir build && cd build/ && cmake ../ && make && make install

COPY conf/* /hbase/conf/
COPY native /hbase/lib/
COPY scripts/start.sh /
RUN chmod +x /start.sh

# change time zone
RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
# master
EXPOSE 60000 60010
# region server
EXPOSE 60020 60030
# other
EXPOSE 16000 16010 16020


RUN rm -rf /tmp
WORKDIR /
ENTRYPOINT ["/start.sh"]