# 指令基于的基础镜像
FROM centos:7.6.1810

# 维护者信息
MAINTAINER 诸葛温侯<neozhang@cool33.com>

# 升级系统
RUN yum -y update

# 安装openssh-server
RUN yum -y install openssh-server openssh-clients openssl-devel openssl*
RUN yum -y install vim
RUN yum -y install net-tools
RUN yum -y install wget make gcc-c++ gcc
RUN yum -y install zlib zlib-devel
RUN yum -y install libffi-devel 
RUN yum -y install libcurl-dev libcurl-devel

# 安装git
RUN yum -y install curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker
RUN yum -y remove git

RUN wget https://github.com/git/git/archive/v2.23.0.tar.gz
RUN tar -zxvf v2.23.0.tar.gz
RUN cd git-2.23.0 \
&& make prefix=/usr/local/git all \
&& make prefix=/usr/local/git install
RUN rm -rf /usr/bin/git
RUN ln -s /usr/local/git/bin/git /usr/bin/git

# 修改/etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# 生成key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key

# 修改root密码
RUN echo "root:58920912a" | chpasswd

# 添加SSHKEY
RUN git clone http://neo:u8RISzuZ@cloud.cool33.com:30001/system/centos.git
RUN mkdir ~/.ssh 
RUN mv /centos/authorized_keys ~/.ssh/

# 卸载python
# 强制删除已安装python及其关联
# RUN rpm -qa|grep python|xargs rpm -ev --allmatches --nodeps

# 删除残余文件
# RUN whereis python|xargs rm -frv

# 开放端口
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]