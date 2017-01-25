FROM debian:jessie

MAINTAINER txt3rob

ENV NGINX_VERSION 1.11.9-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*
	
RUN apt-get update && apt-get install -y curl wget
	
RUN apt-get update && echo "deb http://mozilla.debian.net/ jessie-backports firefox-release"  >> /etc/apt/sources.list \
	&& wget mozilla.debian.net/pkg-mozilla-archive-keyring_1.1_all.deb \
	&& dpkg -i pkg-mozilla-archive-keyring_1.1_all.deb \
	&& apt-get update \
	&& apt-get install -y -t jessie-backports firefox

RUN apt-get update && apt-get install -y git nano xvfb libxrender-dev libasound2 unzip libdbus-glib-1-2 libgeoip-dev libgtk2.0-0 bzip2 python
	
	
RUN apt-get update && curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get install -y nodejs && \
    npm init -y \
    npm install slimerjs && \
    apt-get install -y php5 php5-fpm php5-cli
    
    
    
    
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx"]
