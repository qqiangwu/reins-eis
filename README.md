# 这是什么？
这是一个用于上海交通大学软件学院企业级信息系统课程的作业的基镜像。同学们可以在此镜像的基础上构建自己的容器镜像，作为每次作业的提交物。

本镜像目前包含jre7/jboss-6.4/mysql5.6/redis3.0。 还有另一个安装有tomcat版本的. 自己看tag.

# 如何使用
首先，[安装Docker](https://docs.docker.com/engine/quickstart/).

之后，下载基础镜像并运行：
```
docker pull qqiangwu/reins-eis:jboss
docker run --name reins-homework -d qqiangwu/reins-eis
```

此时，一个包含jboss/mysql/redis的容器已经运行起来了。你可以通过
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' reins-homework
```
来获得容器IP，在浏览器中打开`IP:8080`即可看到jboss入口页面。

**注意**: 在Windows/Mac下, 情况会复杂一些. 因为这两种平台下, Docker实际上是跑在一个虚拟机中. 因此建议安装一个Ubuntu虚拟机, 然后在里面玩.. 如果非要在这两个平台上玩, 可以用ssh tunnel进行端口映射:
```
boot2docker ssh -NL 8000:{dockerIP}:8080 -L 9990:{dockerIP}:9990
```
这样, 直接访问localhost:8000即可.

再或者:
```
docker run --name reins-homework -p 8080:8080 -p 9990:9990 -d qqiangwu/reins-eis
boot2docker ip # => we get IP, access IP:8080
```

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

嗯, 我提供了一个新安装的Jboss-6.4, 所有内容都没有配置, 你们自己配置吧. jboss使用的是standalone模式.


# 如何打包我的应用
当你部署完成后，请确保你的应用已经可以访问了。之后，打包容器并上传到docker hub上。

首先, 注册一个docker hub的帐号. 假设用户名为reins.

```
docker login
docker commit reins-homework reins/homework:x
docker push reins/homework:x # x 表示第x个迭代. 如reins/homework:1
```

# 如何验证我操作
```
docker rmi reins/homework
docker pull reins/homework:x
docker run --name test -d reins/homework:x
```
