# shell-tools

开发过程中常用shell脚本。

## 一键安装

### 安装Git

**方式一**

下载git.sh后直接安装：
```
source xpress_install/git.sh
```

**方式二**

由于git源码下载速度较慢，可将下载后的源码和git.sh脚本放置于nginx静态目录中，修改脚本中Git源码的下载地址，以便在公司局域网中使用。

* 1 修改git.sh文件中源码下载路径：
```
wget https://www.kernel.org/pub/software/scm/git/$GIT_VERSION.tar.gz 
```

* 2 使用
```
例如：放置于IP：10.0.30.2的nginx静态目录中：

sh -c "$(curl -s http://10.0.30.2/install/tools/git.sh)" && source /etc/profile
```

