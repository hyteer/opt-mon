
# mysql
docker run -d --name mysql \
-e MYSQL_ROOT_PASSWORD=111 \
-p 3306:3306 \
-v /mnt/data/mysql:/var/lib/mysql \
mysql:5.6

# zabbix Server
docker run -d --name demo-zabbix-server-mysql \
-e DB_SERVER_HOST="10.20.60.3" \
-e MYSQL_DATABASE="demo_zabbix2" \
-e MYSQL_USER="root" \
-e MYSQL_PASSWORD="111" \
zabbix/zabbix-server-mysql:alpine-3.2-latest

docker run -d --name demo-zabbix-server \
--link demo-zabbix-agent:zabbix-agent \
zabbix/zabbix-server:latest


# zabbix Agent
docker run -d --name demo-zabbix-agent \
-e ZBX_HOSTNAME="manager-3" \
-e ZBX_SERVER_HOST="10.20.60.3" \
zabbix/zabbix-agent:latest

docker run -d --name demo-zabbix-agent \
-e ZBX_HOSTNAME="build-4" \
-e ZBX_SERVER_HOST="10.20.60.3" \
zabbix/zabbix-agent:latest

## link
docker run -d --name demo-zabbix-agent \
--link demo-zabbix-server:zabbix-server \
--privileged \
-p 10050:10050 \
-e ZBX_HOSTNAME="node-3" \
-e ZBX_SERVER_HOST="10.20.60.3" \
zabbix/zabbix-agent:alpine-3.2-latest


# zabbix web server
docker run -d --name demo-zabbix-web-nginx-mysql \
-e DB_SERVER_HOST="10.20.60.3" \
-e MYSQL_DATABASE="demo_zabbix2" \
-e MYSQL_USER="root" \
-e MYSQL_PASSWORD="111" \
-e ZBX_SERVER_HOST="zabbix-server" \
-e PHP_TZ="Asia/Shanghai" \
-p 80:80 \
zabbix/zabbix-web-nginx-mysql
