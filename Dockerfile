FROM justckr/ubuntu-nginx-php:php7

MAINTAINER txt3rob


ENV SLIMERJSLAUNCHER=/usr/share/firefox/firefox

RUN apt-get update 
RUN apt-get install  curl wget -y

RUN apt-get -y install debian-keyring
RUN apt-get update 
RUN echo "deb http://mozilla.debian.net/ jessie-backports firefox-release"  >> /etc/apt/sources.list
RUN wget "http://mozilla.debian.net/pkg-mozilla-archive-keyring_1.1_all.deb"
RUN dpkg -i pkg-mozilla-archive-keyring_1.1_all.deb
RUN apt-get update
RUN apt-get -y install openssh-server
RUN apt-get install -y firefox
RUN apt-get install -y git libxrender-dev unzip libdbus-glib-1-2 locate
RUN apt-get install -y nano xvfb  libasound2 libgeoip-dev libgtk2.0-0 bzip2 python



 
	
	
RUN apt-get update && curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get install -y nodejs && \
    npm init -y \
    npm install fs-extra --save-dev && \
    npm install slimerjs --save-dev && \
    
    
RUN wget http://download.slimerjs.org/releases/0.10.2/slimerjs-0.10.2.zip -O /tmp/slim.zip
RUN mkdir /home/slim/
RUN unzip /tmp/slim.zip -d /home/slim/
RUN mv /home/slim/slimerjs-0.10.2 /home/slim/slimerjs
RUN chmod 755 /home/slim/slimerjs/slimerjs
RUN ln -s /home/slim/slimerjs/slimerjs /usr/bin/slimerjs
RUN chmod 755 /usr/bin/slimerjs
RUN mkdir -p /var/www/html/
RUN touch /var/www/html/index.html
    
    
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 8080
CMD ["export" "SLIMERJSLAUNCHER=/usr/share/firefox/firefox;"]

