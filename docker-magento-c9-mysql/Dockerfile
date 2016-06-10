FROM d.kt-team.de/magento-c9-mysql
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

COPY config/supervisord.conf /etc/supervisord.conf

CMD ["/entrypoint.sh"]