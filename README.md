# sh
script for os


## 多服务器免密码
### 1. 安装 expect 
```
yum install expect
```

### 2. 编辑 /etc/hosts文件
```
vi /etc/hosts

192.168.1.1 test1
192.168.1.2 test2
192.168.1.3 test3
192.168.1.4 test4
192.168.1.5 test5
```

### 3. 执行脚本
```
curl -s https://raw.githubusercontent.com/indiff/sh/master/nopass2.sh | sh 
```

