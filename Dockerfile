FROM centos


# ENV HTTP_PROXY=http://10.0.65.1:1080 
# ENV HTTPS_PROXY=http://10.0.65.1:1080
# ENV http_proxy=http://10.0.65.1:1080 
# ENV https_proxy=http://10.0.65.1:1080

RUN export HTTP_PROXY=http://10.0.65.1:1080 && \
	export HTTPS_PROXY=http://10.0.65.1:1080 && \
	export http_proxy=http://10.0.65.1:1080 && \
	export https_proxy=http://10.0.65.1:1080 && \
	yum install -y openssh-server net-tools

#RUN yum install -y openssh-server net-tools

RUN mkdir /var/run/sshd

#RUN env

RUN echo 'root:password' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#?RSAAuthentication .*/RSAAuthentication yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#?PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#?AuthorizedKeysFile.*/AuthorizedKeysFile ~\/\.ssh\/authorized_keys/g' /etc/ssh/sshd_config

RUN mkdir -p ~/.ssh
# RUN cat /etc/ssh/ssh_host_rsa_key.pub > ~/.ssh/authorized_keys
# RUN chmod 644 ~/.ssh/authorized_keys
# RUN cat /etc/ssh/ssh_host_rsa_key > /id_rsa


ADD ./showip.sh /showip.sh
RUN chmod +x /showip.sh
EXPOSE 22

CMD /usr/sbin/sshd-keygen && \
	cat /etc/ssh/ssh_host_rsa_key.pub > ~/.ssh/authorized_keys && \
	chmod 644 ~/.ssh/authorized_keys && \
	cat /etc/ssh/ssh_host_rsa_key > /id_rsa && \
	/usr/sbin/sshd -D

#ADD ./run.sh /run.sh
#RUN chmod +x /run.sh
#
#
#
#CMD {"/run.sh"}
