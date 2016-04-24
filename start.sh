#! /bin/sh

echo "start redis server..."
redis-server &> /var/log/redis.log &
echo

echo "start mysql server..."
/usr/bin/mysqld --user=root &> /var/log/mysql.log &

echo "start jboss server..."
/jboss-eap-6.4/bin/standalone.sh
