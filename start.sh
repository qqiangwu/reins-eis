#! /bin/sh

echo "start redis server..."
redis-server &> /var/log/redis.log &
echo

echo "start mysql server..."
/usr/bin/mysqld --user=root &> /var/log/mysql.log &

echo "start tomcat server..."
/usr/local/tomcat/bin/catalina.sh run
