# shell-tools

常用shell脚本工具箱，提供一键安装、故障备份等功能。

## 一键安装

xpress_install目录下的脚本提供一键安装的功能，支持如下软件安装：

1. Git
2. Redis
3. Bash-support


### 使用方式

#### 1. 命令行直接执行

最近在七牛CDN上传了下列安装脚本，可以直接执行命令进行安装：

```bash

## 安装bash-support
curl http://olml6iu96.bkt.clouddn.com/script/bash_support.sh -O && vi +':w ++ff=unix' +':q' bash_support.sh && sh bash_support.sh

## 安装Git
curl http://olml6iu96.bkt.clouddn.com/script/git.sh -O && vi +':w ++ff=unix' +':q' git.sh && sh git.sh && source /etc/profile

## 安装Redis
curl http://olml6iu96.bkt.clouddn.com/script/redis.sh -O && vi +':w ++ff=unix' +':q' redis.sh && sh redis.sh && source /etc/profile

```

**`vi +':w ++ff=unix' +':q' bash_support.sh` 说明**

dos格式文件传输到unix系统时,会在每行的结尾多一个^M，即dos文件中的换行符“\r\n”会被转换为unix文件中的换行符“\n”，而此文件若是一个可执行文件的话，会导致此文件不能被执行。

```bash
## 使用vim

# vi exec.sh  
 :set ff=unix(或者:set fileformat=unix)  
# :wq
```

如果想在shell中直接调用，可以执行`vi +':w ++ff=unix' +':q' ${file}`，但是要严格注意上面空格的位置，不能多不能少。

参考：

* [convert-dos-line-endings-to-linux-line-endings-in-vim][2]
* [shell批处理中利用vi设置文件的fileformat][3]


以Git安装为例，介绍两种安装方式。

#### 2. 下载脚本后执行

下载后直接安装：

```
source xpress_install/git.sh
```

#### 3. 二次加工，修改后执行(适用于局域网)**

由于Git源码下载速度较慢，可另行下载Git源码，将之与git.sh脚本放置于nginx静态目录中，修改git.sh脚本中Git源码的下载地址，以便在局域网中使用。

* 1 修改git.sh文件中源码下载路径：

```
wget https://www.kernel.org/pub/software/scm/git/$GIT_VERSION.tar.gz 
```

* 2 使用:

```
例如：放置于IP：10.0.30.2的nginx静态目录中，直接在命令行执行：

sh -c "$(curl -s http://10.0.30.2/install/tools/git.sh)" && source /etc/profile
```

### Git

**安装版本**：V2.9.5

**安装目录**：/usr/local/git

**默认配置**：

```
git config --global alias.co "checkout"
git config --global alias.ci "commit"
git config --global alias.br "branch"
git config --global alias.st "status"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

### Redis

**安装版本**：Redis 4.0.9

**安装目录**：/usr/local/redis-4.0.9，默认增加软链接: /usr/local/redis -> redis-4.0.9/

**默认配置**：

redis.sh安装脚本默认执行了如下配置：

1. 将`redis.conf`配置文件移动到`/usr/local/redis/etc`
2. 将`mkreleasehdr.sh redis-benchmark redis-check-aof redis-cli redis-server /usr/local/redis/bin`移动到`/usr/local/redis/etc`
3. 后台启动redis服务，`redis.conf` -> `daemonize yes`
4. 将redis添加到系统服务。启动脚本：`/etc/init.d/redis`
5. 环境变量配置：`/etc/profile.d/redis.sh`


**提醒配置**：

在安装过程中，如果出现红色字体的输出，表示建议进行的配置，但是脚本并未自动设置，需要手工配置。Redis.sh建议配置主要为内存分配策略。

**内存分配策略**

内核参数：overcommit_memory 

可选值：0、1、2。
* 0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
* 1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
* 2， 表示内核允许分配超过所有物理内存和交换空间总和的内存

> 什么是Overcommit和OOM
  
>   Linux对大部分申请内存的请求都回复"yes"，以便能跑更多更大的程序。因为申请内存后，并不会马上使用内存。这种技术叫做Overcommit。
    当linux发现内存不足时，会发生OOM killer(OOM=out-of-memory)。它会选择杀死一些进程(用户态进程，不是内核线程)，以便释放内存。
    当oom-killer发生时，linux会选择杀死哪些进程？选择进程的函数是oom_badness函数(在mm/oom_kill.c中)，该函数会计算每个进程的点数(0~1000)。点数越高，这个进程越有可能被杀死。
    每个进程的点数跟oom_score_adj有关，而且oom_score_adj可以被设置(-1000最低，1000最高)。


**修改配置/etc/sysctl.conf**

```
vm.overcommit_memory = 1 

## 使之生效
sysctl -p 

```

### Bash-support

`bash-support` 是一个高度定制化的`vim`插件，它允许你插入：文件头、补全语句、注释、函数、以及代码块。它也使你可以进行语法检查、使脚本可执行、一键启动调试器；而完成所有的这些而不需要关闭编辑器。

它使用快捷键（映射），通过有组织地、一致的文件内容编写/插入，使得`bash`脚本编程变得有趣和愉快。

插件当前版本是`4.3`，`4.0` 版本 重写了之前的` 3.12.1 `版本，`4.0` 及之后的版本基于一个全新的、更强大的、和之前版本模板语法不同的模板系统。

了解更多，请参考博客：[如何用bash-support插件将Vim编辑器打造成编写Bash脚本的IDE][1]



## 故障备份

troubleshoot目录下的脚本主要用户故障备份。

### JVM Dump

每次线上环境一出问题，大家就慌了，通常最直接的办法回滚重启，以减少故障时间，这样现场就被破坏了，要想事后查问题就麻烦了，有些问题必须在线上的大压力下才会发生，线下测试环境很难重现，不太可能让开发或 Appops 在重启前，先手工将出错现场所有数据备份一下，所以最好在 kill 脚本之前调用 dump，进行自动备份，这样就不会有人为疏忽。 
`dump.sh`的备份信息涵盖操作系统和JVM，主要用到的命令包括：jstack、jinfo、jstat、jmap、lsof、sar、uptime、free、vmstat、mpstat、iostat、netstat。

> 使用方式：\"dump.sh -p jvm进程号\"指定jvm进程进行备份，不使用-p参数时，默认查找tomcat用户对应的java进程。

      
  [1]: https://roc-wong.github.io/blog/2018/02/bash-support-vim-Bash-IDE.html
  [2]: https://stackoverflow.com/questions/82726/convert-dos-line-endings-to-linux-line-endings-in-vim
  [3]: http://fandayrockworld.iteye.com/blog/1336096