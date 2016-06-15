FROM d.kt-team.de/magento
MAINTAINER Anton Belov anton4@bk.ru

#install nodejs and rubby
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install \
	nodejs \
	sudo \
	nano \
	npm build-essential \
        apt-transport-https \
        ruby \
	ca-certificates \
        python-all \
        rlwrap && \
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

RUN npm install npm -g && npm install grunt-cli -g

ENV NODE_ENV production
RUN gem install sass 
WORKDIR /src
RUN rm -rf c9sdk && git clone https://github.com/c9/core.git c9sdk
WORKDIR /src/c9sdk
RUN ln -s /usr/bin/nodejs /usr/bin/node 
RUN scripts/install-sdk.sh
ADD ./c9ide.sh /c9ide.sh
RUN chmod 755 /c9ide.sh

COPY config/supervisord.conf /etc/supervisord.conf
WORKDIR /src/c9sdk

CMD ["/entrypoint.sh"]
