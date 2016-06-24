FROM d.kt-team.de/magento-c9
MAINTAINER Anton Belov anton4@bk.ru

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
# Use source.list with all repositories and Yandex mirrors.

# install MySQL
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
    mysql-server-5.7 &&\
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory
  
# Expose ports
EXPOSE 3306

WORKDIR /src/c9sdk

COPY config/supervisord.conf /etc/supervisord.conf
RUN mysqld_safe  --initialize-insecure 
COPY ./update_base_url.sh /update_base_url.sh
RUN chmod +x /update_base_url.sh
COPY ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

CMD ["/entrypoint.sh"]
