# 这是什么？
这是一个用于上海交通大学软件学院企业级信息系统课程的作业的基镜像。同学们可以在此镜像的基础上构建自己的容器镜像，作为每次作业的提交物。

本镜像目前包含jre7/tomcat7/mysql5.6/redis3.0。

# 如何使用
首先，[安装Docker](https://docs.docker.com/engine/quickstart/).

之后，下载基础镜像并运行：
```
docker pull qqiangwu/reins
docker run --name reins-homework -d qqiangwu/reins-eis
```

此时，一个包含tomcat/mysql/redis的容器已经运行起来了。你可以通过
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' reins-homework
```
来获得容器IP，在浏览器中打开`IP:8080`即可看到tomcat入口页面。

你可以通过`docker exec -it reins-homework /bin/sh`打开容器shell，并在其中对容器进行操作，比如，连接mysql：`#> mysql -uroot`, 连接redis：`#> redis-cli`。

默认的，mysql账号名为root，无密码。redis无密码。

# 如何部署我的应用
假设，你已经有了创建数据库的脚本：create.sql，以及一个可以运行的homework.war。先将它们复制到容器中。
```
docker cp create.sql reins-homework:/
docker cp homework.war reins-homework:/
```

创建数据库，并部署应用。首先通过`docker exec -it reins-homework /bin/sh`打开shell，导入数据库：
```
mysql -uroot
source create.sql
```
部署应用：
```
mv reins-homework.war /usr/local/tomcat/webapps/ROOT.war
```

此时，打开浏览器，访问`IP:8080`（IP是刚才得到的），即可看到你的应用。

如果你想修改tomcat有关的配置，它的位置在`/usr/local/tomcat`中

# 如何打包我的应用
当你部署完成后，请确保你的应用已经可以访问了。之后，打包容器。
```
docker commit reins-homework your-name/homework
docker save your-name/homework > your-name-homework.tar
gzip your-name-homework.tar
```

此时，你应该已经得到了一个`your-name-homework.tar.gz`的文件。这就是最终的提交物。

# 如何验证我操作
在得到`your-name-homework.tar.gz`后，我希望你能够验证一下你的tarball的可用性：
```
gzip -d your-name-homework.tar.gz
docker rmi your-name/homework       # 移除旧的镜像，因此接下来要提交新的
docker load -i your-name-homework.tar
docker run --name verification -d your-name/homework
```

用同样的方法获取`verification`的IP，并在浏览器中访问其8080端口。如果一切无误，则打包正确。
