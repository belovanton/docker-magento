FROM d.kt-team.de/php:7.0
MAINTAINER Anton Belov anton4@bk.ru

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
# Use source.list with all repositories and Yandex mirrors.

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
	apt-get -y install \
	ca-certificates curl  \
	wget pkg-config &&\
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
	apt-get -y install \	
	python python-pip libgeoip-dev python-dev nginx-extras libfreetype6 libfontconfig1 \
	build-essential zlib1g-dev libpcre3 libpcre3-dev unzip libssl-dev &&\
	apt-get clean && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

#Install pagecahe module
ENV NGINX_VERSION 1.9.15
ENV NPS_VERSION 1.11.33.0
RUN 	cd /usr/src &&\
	cd /usr/src &&\
	cd /usr/src && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip &&\
	cd /usr/src && unzip release-${NPS_VERSION}-beta.zip &&\
	cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && pwd && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz &&\
	cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && tar -xzvf ${NPS_VERSION}.tar.gz &&\
	cd /usr/src &&\
	cd /usr/src && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz &&\
	cd /usr/src && tar -xvzf nginx-${NGINX_VERSION}.tar.gz &&\
	cd /usr/src/nginx-${NGINX_VERSION}/ && ./configure --add-module=/usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta \ 
         --prefix=/usr/local/share/nginx --conf-path=/etc/nginx/nginx.conf \
         --sbin-path=/usr/local/sbin --error-log-path=/var/log/nginx/error.log \
	 --with-pcre-jit --with-http_stub_status_module --with-http_realip_module \
	 --with-http_auth_request_module --with-http_addition_module --with-http_ssl_module \
	 --with-ipv6 --with-http_geoip_module --with-http_v2_module --with-http_gzip_static_module \
	 --with-http_sub_module && \
	cd /usr/src/nginx-${NGINX_VERSION}/ && make &&\
	cd /usr/src/nginx-${NGINX_VERSION}/ && make install &&\
        sed -i 's|/usr/sbin/nginx|/home/nginx|g' /etc/init.d/nginx && \
        rm /usr/sbin/nginx &&\
        mkdir -p /var/nginx/pagespeed_cache

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/cache/nginx", "/etc/php-fpm.d", "/var/log/php-fpm", "/var/www"]

# Define working directory.
WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443

#Install git
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive && \
        apt-get -y install \
        apt-transport-https \
        git && \
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

# Install system requirements
RUN apt-get update && apt-get install -y \
    emacs24-nox \
    locales \
    nginx \
    mc \
    python-pip \
    openssh-server \
    pv &&\
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

# Configure locales and timezone
RUN locale-gen en_US.UTF-8 &&\
	locale-gen en_GB.UTF-8 &&\
	locale-gen fr_CH.UTF-8 &&\
	cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime &&\
	echo "Europe/Moscow" > /etc/timezone &&\
	mkdir /var/run/sshd &&\
	mkdir /root/.ssh
COPY ./sshd_config /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

EXPOSE 22

# Enabling session files
RUN mkdir -p /tmp/sessions/ &&\
    chown www-data.www-data /tmp/sessions -Rf

#install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    wget -q --no-check-certificate https://raw.github.com/colinmollenhour/modman/master/modman-installer && \
    bash < modman-installer &&\
    ssh-keyscan -t rsa bitbucket.org > ~/.ssh/known_hosts &&\
	composer config -g github-oauth.github.com 6e18b614391d88b271c1e3f069e55d7fd9bf6e3d

# Supervisor config
RUN mkdir /var/log/supervisor &&\
	pip install supervisor
COPY config/supervisord.conf /etc/supervisord.conf

# Startup script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
COPY ./config/nginx/conf.d /etc/nginx/conf.d
RUN rm -rf /etc/nginx/sites-enabled/default
RUN rm -rf /etc/nginx/sites-available/default
CMD ["/entrypoint.sh"]
