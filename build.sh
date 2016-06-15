#!/bin/sh
set -e # EXIT on ANY error
PATH=$(pwd)
docker=/usr/bin/docker
cd $PATH/docker-magento
$docker build -t d.kt-team.de/magento .
$docker push d.kt-team.de/magento

cd $PATH/docker-magento-c9
$docker build -t d.kt-team.de/magento-c9 .
$docker push d.kt-team.de/magento-c9

cd $PATH/docker-magento-c9-mysql
$docker build -t d.kt-team.de/magento-c9-mysql .
$docker push d.kt-team.de/magento-c9-mysql

