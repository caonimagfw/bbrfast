# Manual Command 

## Install tools and Get files
```
yum -y install epel-release
yum -y install wget 
systemctl stop firewalld
yum -y install firewalld && yum -y upgrade firewalld
systemctl enable firewalld && systemctl restart firewalld

# get files

wget https://raw.githubusercontent.com/caonimagfw/bbrfast/master/one.sh
wget https://raw.githubusercontent.com/caonimagfw/bbrfast/master/two.sh

# run install core 5.18.3
bash one.sh

# set base env ${1} ${2}
bash two.sh init ######

# final run ${1} ${2}
bash two.sh d4 ######
bash two.sh d6 ######

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

```