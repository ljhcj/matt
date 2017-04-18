# ubuntu14.04_jdk1.7_erlang19.02_mqtt基础镜像的Dockerfile
FROM registry.cn-qingdao.aliyuncs.com/gf/ubuntu-14.04:latest

# 安装更新、安装wget和ssh工具、修改系统时区
RUN apt-get update \
    && apt-get -y install wget vim net-tools unzip build-essential  libncurses5-dev  libssl-dev m4 unixodbc unixodbc-dev freeglut3-dev libwxgtk2.8-dev  xsltproc  fop tk8.5 \
        && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

RUN apt-get -y remove openjdk*

# 下载软件包并解压
RUN wget -P /usr/local/ http://download.zhongyinginfo.com/soft/jdk-7u79-linux-x64.tar.gz \
    && wget -P /usr/local/ http://download.zhongyinginfo.com/soft/otp_src_19.2.tar.gz \
    && wget -P /usr/local/ http://download.zhongyinginfo.com/soft/mqtt-release.tar.gz \
    && cd /usr/local/ && tar xvf jdk-7u79-linux-x64.tar.gz && tar xvf otp_src_19.2.tar.gz && tar xvf mqtt-release.tar.gz 
    
# 配置java环境变量
ENV JAVA_HOME /usr/local/jdk1.7.0_79
ENV JRE_HOME $JAVA_HOME/jre
ENV CLASSPATH .:$JAVA_HOME/lib:$JRE_HOME/lib
ENV PATH $PATH:$JAVA_HOME/bin

# 安装Erlang和MQTT
RUN cd /usr/local/otp_src_19.2/ && ./configure && make && make install \
    && chmod -R 777 /usr/local/mqtt-release

EXPOSE  1883 8083

# 启动mqtt服务
CMD ["/usr/local/mqtt-release/bin/emqttd","start"]
