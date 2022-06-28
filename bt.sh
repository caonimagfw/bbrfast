# install bt 
```
mkdir /root/bt
cd /root/bt

yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh 12f2c1d72
#echo '127.0.0.1 bt.cn' >>/etc/hosts
bt stop
wget https://github.com/caonimagfw/bbrfast/releases/download/v0.7.45/LinuxPanel-7.4.5.zip 
unzip -o LinuxPanel-7.4.5.zip -d /www/server/
bt restart 

```

# python
```
#依赖包
yum -y groupinstall "Development tools"
 
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
#下载 Python3
wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz
#创建文件夹
mkdir /usr/local/python3 
#解压编译安装
tar -xvJf  Python-3.6.2.tar.xz
cd Python-3.6.2
./configure --prefix=/usr/local/python3
make && make install
#给个软链
ln -s /usr/local/python3/bin/python3 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3

```

#yum 
```
/usr/bin/yum
/usr/libexec/urlgrabber-ext-down
python2
```

#update 
```
wget -O panel.zip http://download.bt.cn/install/update/LinuxPanel-7.7.0.zip
unzip -f panel.zip -d /www/server/
rm -f panel.zip

```
