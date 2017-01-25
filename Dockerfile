FROM debian:jessie

MAINTAINER txt3rob

ENV NGINX_VERSION 1.11.9-1~jessie
ENV SLIMERJSLAUNCHER=/usr/share/firefox/firefox

RUN apt-get update 
RUN apt-get install  curl wget -y

RUN apt-get -y install debian-keyring
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --force-yes --no-install-recommends --no-install-suggests -y \
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
    npm install slimerjs && \
    apt-get install -y php5 php5-fpm php5-cli php5-gd php5-ssh2
    
    
RUN wget http://download.slimerjs.org/releases/0.10.2/slimerjs-0.10.2.zip -O /tmp/slim.zip
RUN unzip /tmp/slim.zip
RUN mv /tmp/slimerjs-0.10.2/ /home/slim/
RUN echo '#!/bin/bash\nxvfb-run /home/slim/slimerjs "$@"' > /home/slim/slimerjs
RUN chmod 755 /home/slim/slimerjs
RUN ln -s /home/slim/slimerjs /usr/bin/slimerjs
    
    
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443 22
CMD ["service", "ssh", "start;"]
CMD ["service", "php5-fpm", "start;"]
CMD ["nginx", "-g", "daemon off;"]
CMD ["mkdir", "-p", "/var/www/html/"]
CMD ["touch", "/var/www/html/index.html"]
