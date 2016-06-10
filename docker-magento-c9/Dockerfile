FROM d.kt-team.de/magento
MAINTAINER Anton Belov anton4@bk.ru

#install nodejs        
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install \
	nodejs  build-essential &&\
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

RUN npm install -g pangyp\
 && ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp\
 && npm cache clear\
 && node-gyp configure || echo ""

#install ruby
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive && \
        apt-get -y install \
        apt-transport-https \
        ruby \
	ca-certificates \
        python-all \
        rlwrap && \
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory


ENV NODE_ENV production
RUN gem install sass

RUN mkdir /src
WORKDIR /src
RUN git clone https://github.com/c9/core.git c9sdk
WORKDIR /src/c9sdk
RUN scripts/install-sdk.sh
ADD ./c9ide.sh /c9ide.sh
RUN chmod 755 /c9ide.sh

COPY config/supervisord.conf /etc/supervisord.conf

RUN ln -s /usr/bin/nodejs /usr/bin/node 


CMD ["/entrypoint.sh"]