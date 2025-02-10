# what's this

物联网工程专业综合设计 粉尘检测系统 包括mqtt服务器搭建,后端,前端 取得优秀成绩

# how to use

#### 1.mqtt服务器部分

服务器搭建请参考这篇文章:[docker安装部署MQTT_docker mqtt-CSDN博客](https://blog.csdn.net/qq_43917690/article/details/136705488),若有端口冲突/占用可删除其他端口,保留1883,8083,18083
使用docker部署后,使用MQTT X或[EQMX平台](http://localhost:18083/#/login?to=/dashboard/overview)测试ws连接,user:admin;password:public

#### 2.后端部分

先建立MySQL数据库,配置参考,导入backend下的sql文件,之后修改对应配置文件中的用户名和密码启动后端即可

#### 3.前端部分

cd到my_mqtt文件夹所在目录下,执行npm run serve,视频悬浮查看可以修改路径为自己本地的一个视频(你可以切成64份)
