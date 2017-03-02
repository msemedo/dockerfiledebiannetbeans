FROM msemedo/debian8.7oraclejava8cpp:latest
LABEL maintainer "Marcello DB Semedo"

RUN apt-get -y update && \
	apt-get install -y	libxext-dev \
						sudo \
						libxrender-dev \
						libxtst-dev && \
	apt-get clean &&\
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*
	
ADD state.xml /tmp/state.xml
	
RUN wget http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh -O /tmp/netbeans.sh -q --progress=bar:force:noscroll --show-progress && \
    chmod +x /tmp/netbeans.sh && \
    echo "Instalando..." && \
    /tmp/netbeans.sh --silent --state /tmp/state.xml && \
    rm -rf /tmp/* &&\
    echo "terminado"
	
RUN mkdir -p /home/netbeansdev && \
    echo "netbeansdev:x:1000:1000:Developer,,,:/home/netbeansdev:/bin/bash" >> /etc/passwd && \
    echo "netbeansdev:x:1000:" >> /etc/group && \
    echo "netbeansdev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/netbeansdev && \
    chmod 0440 /etc/sudoers.d/netbeansdev && \
    chown netbeansdev:netbeansdev -R /home/netbeansdev
USER netbeansdev
ENV HOME /home/netbeansdev 
WORKDIR /home/netbeansdev

#CMD /usr/bin/netbeans
CMD /home/netbeansdev/netbeans-8.2/bin/netbeans
