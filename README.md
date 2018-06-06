# 什么是Hexo-Docker
不少人使用Hexo来撰写和发布博客，这个工具就是为了方便这些用户，快速地搭建所需要的Hexo环境。

它会编译一个docker镜像，集成编写博客所需要的Hexo环境。这个镜像安装了必要的应用程序，比如git等等。对于一些敏感信息（如ssh key）和数据信息（比如博客的数据），则采用挂载本地磁盘的方式。这样可以保证应用和数据独立性，相互不干扰。

很多用户会需要在公司或家庭等多个电脑上进行Hexo的博客撰写和发布工作，这里就涉及到Hexo博客的源文件在多台电脑之间的同步问题。使用Hexo-Docker也可以很方便的解决这个问题。Hexo-Docker也是采用多数人用的方案，分布的文章提交到一个公有的git库，源文件提交到另外一个私有的git库。仅仅需要简单的设置和执行一个脚本，就可以立刻把源文件从私有库上面恢复下来。

# 如何使用
## 安装Docker
根据操作系统的环境，按照Docker官方文档 https://docs.docker.com/install 来安装Docker环境。

安装完之后，执行下面命令把当前登录的用户名加入到docker组中，然后重新登陆系统。这样，就可以在执行docker命令的时候不用加sudo
```
sudo usermod -aG docker <<用户名>>
```
## 编译镜像并创建容器
1. clone或者下载git项目到本地
2. 修改`conf/install.conf`配置文件中`User Configurations`部分。该配置文件包含了在编译Docker镜像时候需要的设置
3. 运行`install.sh`这个脚本来编译镜像。   
如果遇到类似下面的错误提示，可以忽略它。这个是由于当前的系统不是MacOS
    >npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.4 (node_modules/hexo-cli/node_modules/fsevents):    
    >npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.4: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})
4. 编译完成后，就会生成一个名字为`hexo-docker`的docker容器。注意：`install.sh`脚本只需要执行一次，再次执行会把旧的docker容器删除，并生成一个新的。除非真有这个必要，比如Hexo-Docker的版本更新，否则不建议多次执行。

## 启动容器
执行`start.sh`脚本

## SSH KEY
如果宿主机的目录上面原先没有生成过ssh key，那么需要先生成一个。可以在宿主机上生成，或者执行`connect.sh`连接到容器的命令行，在容器里面生成

## 准备Hexo工作环境
### 初始化Hexo工作环境
如果是初次使用Hexo，执行下面的命令来初始化一个从零开始的工作环境。这个命令会调用`hexo init`来初始化环境
```
init.sh -m 0
``` 

### 从git仓库还原Hexo工作环境
如果之前备份过Hexo工作环境到git仓库，可以按照下面的步骤来进行恢复工作环境

修改`conf/hexo.conf`配置文件中git仓库的地址和分支名。务必要保证该仓库已经存在，并设置好访问的权限。
```
WORKSPACE_GIT_REPO_URL=
WORKSPACE_GIT_REPO_BRANCH=
```

执行下面的命令从所配置的git仓库获取信息，并还原工作环境
```
init.sh -m 1
```

## 停止容器
执行`stop.sh`脚本

## 连接到容器的命令行
可以执行`connect.sh`脚本来连接到容器的命令行，在容器里面进行操作

## 备份工作环境到git仓库
如果工作环境从来没有备份到git仓库，或者说工作环境没有和任何git仓库绑定，可以按照下面的方法备份。先切换到Hexo-docker目录下，执行`connect.sh`来连接到容器的命令行再执行下面的命令
```
cd /hexo/blog
git init
git remote add origin <<git url>>
git add .
git commit
git push -u origin master
```

如果工作环境就是通过git仓库里面还原的，那么可以直接用git命令来提交改动到git仓库
