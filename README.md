# Manual Command 

## Install tools and Get files
```
yum -y install epel-release
yum -y install wget 
systemctl stop firewalld
yum -y install firewalld && yum -y upgrade firewalld
systemctl enable firewalld && systemctl restart firewalld

# get files

wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.20/0.sh
# run install core 5.18.3
bash 0.sh init {pwd}

# final run ${1} ${2}
bash 0.sh d4 {pwd}
bash 0.sh d6 {pwd}

```

## Other Info
```
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844


mkdir /root/5.18
cd /root/5.18
wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.18/kernel-ml-5.18.3-1.el7.elrepo.x86_64.rpm
wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.18/kernel-ml-devel-5.18.3-1.el7.elrepo.x86_64.rpm
wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.18/kernel-ml-headers-5.18.3-1.el7.elrepo.x86_64.rpm*
yum install -y /root/5.18/kernel-ml-5.18.3-1.el7.elrepo.x86_64.rpm
	
grub2-set-default 'CentOS Linux (5.18.3-1.el7.elrepo.x86_64) 7 (Core)'
grub2-editenv list

grubby --info=ALL
grubby --set-default 1
grubby --default-index


```
