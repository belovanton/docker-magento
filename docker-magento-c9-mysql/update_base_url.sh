#!/bin/bash
sleep 30;
echo "updating base url";
mysql -uroot magento2 -e "update core_config_data set value=\"$BASE_URL\" where path like \"%base_url%\";"
echo "clearing cache";
rm -rf /var/www/current/var/cache/*
echo "tail /var/log/lastlog";
tail -f /var/log/lastlog
