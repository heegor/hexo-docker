# 什么是Hexo-Docker
不少人使用Hexo + GitHub Pages来搭建博客。这个工具就是用来编译一个docker镜像，集成编写博客所需要的Hexo环境。

这个镜像安装了必要的应用程序，比如git等等。对于一些敏感信息（如ssh key）和数据信息（比如博客的数据），则采用挂载本地磁盘的方式。这样可以保证应用和数据独立性，相互不干扰。

# 如何使用
## 安装Docker
根据操作系统的环境，按照Docker官方文档 https://docs.docker.com/install 来安装Docker环境。

安装完之后，执行下面命令把当前登录的用户名加入到docker组中，然后重新登陆系统。这样，就可以在执行docker命令的时候不用加sudo
```
sudo usermod -aG docker <<用户名>>
```
## 编译镜像
1. clone或者下载git项目到本地
2. 修改`conf/install.conf`配置文件中`User Configurations`部分。该配置文件包含了在编译Docker镜像时候需要的设置
3. 运行`install.sh`这个脚本来编译镜像。   
如果遇到类似下面的错误提示，可以忽略它。这个是由于当前的系统不是MacOS
    >npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.4 (node_modules/hexo-cli/node_modules/fsevents):    
    >npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.4: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})
4. 编译完成后，就会生成一个名字为`hexo-docker`的docker容器。注意：`install.sh`脚本只需要执行一次，再次执行会把旧的docker容器删除，并生成一个新的。除非真有这个必要，比如Hexo-Docker的版本更新，否则不建议多次执行。

## 使用镜像
如果熟悉docker的命令，可以直接使用docker命令来操作刚才生成的Hexo-Docker容器。为了方便操作，项目里面包含了一些脚本：   
* `start.sh`：启动Hexo-Docker容器
* `stop.sh`: 停止Hexo-Docker容器
* `connect.sh`：连接到Hexo-Docker容器的命令行界面

## 使用和操作Hexo博客
有两种方法，一个是执行`connect.sh`脚本，连接到Hexo-Docker容器的命令行界面，然后执行相关的hexo命令

另外一个方法，可以使用提供的脚本：
* `hexoInit.sh`: 用于初始化博客，仅需要运行一次。    
这个命令相当于在容器中执行`hexo init`。可以修改`conf/hexo.conf`配置文件中博客的目录名称，然后执行该脚本来初始化。
* `hexoExec.sh`：用于执行hexo命令。    
例如，执行`hexoExec.sh s`就相当于在Hexo-Docker容器中执行`hexo s`。该脚本会读取`conf/hexo.conf`文件中的配置，并转到所设置的博客目录下面去执行相应的hexo命令
