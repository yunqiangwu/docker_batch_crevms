FROM centos


# ENV HTTP_PROXY=http://10.0.65.1:1080 
# ENV HTTPS_PROXY=http://10.0.65.1:1080
# ENV http_proxy=http://10.0.65.1:1080 
# ENV https_proxy=http://10.0.65.1:1080

#RUN export HTTP_PROXY=http://10.0.65.1:1080 && \
#	export HTTPS_PROXY=http://10.0.65.1:1080 && \
#	export http_proxy=http://10.0.65.1:1080 && \
#	export https_proxy=http://10.0.65.1:1080 && \
#	yum install -y openssh-server net-tools

RUN yum install -y openssh-server net-tools

RUN mkdir /var/run/sshd

RUN echo 'root:password' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#?RSAAuthentication .*/RSAAuthentication yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#?PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#?AuthorizedKeysFile.*/AuthorizedKeysFile ~\/\.ssh\/authorized_keys/g' /etc/ssh/sshd_config

RUN mkdir -p ~/.ssh

EXPOSE 22


ADD ./shell/ /shell
RUN sed -i "s/\r//" /shell/*.sh

RUN chmod +x /shell/*.sh

CMD /shell/run.sh -D 
