FROM debian:jessie

MAINTAINER txt3rob

ENV NGINX_VERSION 1.11.9-1~jessie
ENV SLIMERJSLAUNCHER=/usr/share/firefox/firefox
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list 
RUN apt-get update 
RUN apt-get install -y curl wget
RUN apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*
# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/conf.d/default.conf
# Add Nginx Config
RUN wget --no-check-certificate -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/txt3rob/slimerjs-docker/master/default
	

RUN apt-get update 
RUN echo "deb http://mozilla.debian.net/ jessie-backports firefox-release"  >> /etc/apt/sources.list
RUN wget "http://mozilla.debian.net/pkg-mozilla-archive-keyring_1.1_all.deb"
RUN dpkg -i pkg-mozilla-archive-keyring_1.1_all.deb
RUN apt-get update
RUN apt-get -y install openssh-server
RUN apt-get install -y firefox
RUN apt-get install -y git libxrender-dev unzip libdbus-glib-1-2 locate
RUN apt-get install -y nano nano xvfb  libasound2 libgeoip-dev libgtk2.0-0 bzip2 python



 
	
	
RUN apt-get update && curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get install -y nodejs && \
    npm init -y \
    npm install fs-extra && \
    wget -O /tmp/slimerjs-0.10.2.zip http://download.slimerjs.org/releases/0.10.2/slimerjs-0.10.2.zip && \
    unzip slimerjs-0.10.2.zip && \
    mkdir -p /srv/var && \
    mv /tmp/slimerjs-0.10.2/ /srv/var/slimerjs && \
    echo '#!/bin/bash\nxvfb-run /srv/var/slimerjs/slimerjs "$@"' > /srv/var/slimerjs/slimerjs && \
    chmod 755 /srv/var/slimerjs/slimerjs && \
    ln -s /srv/var/slimerjs/slimerjs /usr/bin/slimerjs && \
    
    
    
    apt-get install -y php5 php5-fpm php5-cli php5-gd php5-ssh2
    
    
    
    
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443 22
CMD ["service", "ssh", "start;"]
CMD ["nginx", "-g", "daemon off;"]
