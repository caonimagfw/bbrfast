# two.sh

#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"

Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"


pa2=$2

optimizing_system_v2(){
    modprobe ip_conntrack
    echo "
fs.file-max = 1024000
fs.inotify.max_user_instances = 8192
net.core.netdev_max_backlog = 262144
net.core.rmem_default = 8388608
net.core.rmem_max = 67108864
net.core.somaxconn = 65535
net.core.wmem_default = 8388608
net.core.wmem_max = 67108864
net.ipv4.ip_local_port_range = 10240 65000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time=60
net.ipv4.tcp_keepalive_intvl=5
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_max_tw_buckets = 60000
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_rmem = 8192 87380 67108864
net.ipv4.tcp_sack = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 8192 65536 67108864
net.netfilter.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_established = 3600
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.nf_conntrack_max = 6553500
net.ipv4.ip_forward = 1
net.ipv4.icmp_echo_ignore_all=1

">>/etc/sysctl.conf
    sysctl -p
    echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
    echo "ulimit -SHn 1000000">>/etc/profile
}


startbbr(){
    : > /etc/sysctl.conf
    echo "net.core.default_qdisc=fq_pie" >>/etc/sysctl.d/99-sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.d/99-sysctl.conf
    sysctl --system
    sysctl -p
    echo -e "${Info}BBR and fq_pie 启动成功！"
}

installbbr(){
    mkdir /root/5.18
    cd /root/5.18
    wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.18/kernel-ml-5.18.3-1.el7.elrepo.x86_64.rpm
    wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.18/kernel-ml-devel-5.18.3-1.el7.elrepo.x86_64.rpm
    wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.18/kernel-ml-headers-5.18.3-1.el7.elrepo.x86_64.rpm*
    yum install -y /root/5.18/kernel-ml-5.18.3-1.el7.elrepo.x86_64.rpm
    
    grub2-set-default 'CentOS Linux (5.18.3-1.el7.elrepo.x86_64) 7 (Core)'
    grub2-editenv list
    startbbr
    optimizing_system_v2
    echo -e "${Tip} ------ BBR Done -------- ${Font_color_suffix}"
}

mainRun(){
    modprobe ip_conntrack

    wget https://github.com/caonimagfw/bbrfast/releases/download/v0.5.18/rarlinux-x64-5.5.0.tar.gz
    tar -zxvf rarlinux-x64-5.5.0.tar.gz
    cd rar
    sudo cp -v rar unrar /usr/local/bin/
    cd ..

    installbbr
}

init(){
    systemctl start firewalld
    modprobe ip_conntrack
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control
    sysctl net.core.default_qdisc
    lsmod | grep bbr
    # set ssh port
    # #Port 22
    sed -i.bak '0,/#Port 22/s//Port 58899/' /etc/ssh/sshd_config
    firewall-cmd --zone=public --add-port=58899/tcp --permanent
    firewall-cmd --reload && firewall-cmd --permanent --list-all --zone=public
    systemctl restart sshd
    yum provides semanage
    yum -y install policycoreutils-python
    semanage port -a -t ssh_port_t -p tcp 58899
    semanage port -l | grep ssh
    semanage port -d -t ssh_port_t -p tcp 22
    semanage port -l | grep ssh
    systemctl start firewalld
    firewall-cmd --zone=public --remove-port=22/tcp --permanent && firewall-cmd --reload 
    firewall-cmd --zone=trusted --remove-port=22/tcp --permanent && firewall-cmd --reload 

    # set all firewall 
    #systemctl stop firewalld && yum -y upgrade firewalld
    #systemctl enable firewalld && systemctl restart firewalld
    firewall-cmd --permanent --zone=public --add-port=10111/tcp 
    firewall-cmd --permanent --zone=public --add-port=20677/tcp --add-port=20688/tcp
    firewall-cmd --permanent --zone=public --add-port=30677/tcp --add-port=30688/tcp
    firewall-cmd --permanent --zone=public --add-port=40677/tcp --add-port=40688/tcp
    firewall-cmd --permanent --zone=public  --add-forward-port=port=20677:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=20688:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=30677:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=30688:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=40677:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-forward-port=port=40688:proto=tcp:toport=10111
    firewall-cmd --permanent --zone=public  --add-masquerade 
    firewall-cmd --permanent --zone=trusted --add-masquerade
    firewall-cmd --permanent --zone=public --direct --add-rule ipv4 filter INPUT_direct 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --permanent --zone=public --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --permanent --zone=trusted --direct --add-rule ipv4 filter INPUT_direct 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --permanent --zone=trusted --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags RST,RST RST -j DROP	
    firewall-cmd --reload
    #install all tools and caddy yum install bind-utils -y
    yum -y install wget net-tools bridge-utils && yum -y install epel-release && yum -y install unar
    wget --no-check-certificate -O caddy_install.sh https://raw.githubusercontent.com/caonimagfw/Caddy/master/caddy_install.sh && bash caddy_install.sh
cat > /usr/local/caddy/Caddyfile <<-EOF
	:8099 {
		root /usr/local/caddy/www
		gzip
	}
EOF
    cat /usr/local/caddy/Caddyfile 
    service caddy restart 
    #docker 
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    yum makecache fast
    yum list docker-ce --showduplicates | sort -r
    yum -y install docker-ce-20.10.16 docker-ce-cli-20.10.16 containerd.io
    systemctl enable docker.socket --now
    systemctl enable docker && systemctl restart docker  

    sed -i.bak 's/^After=.*/After=containerd.service/g' /etc/systemd/system/multi-user.target.wants/docker.service
    sed -i.bak 's/^Wants=.*/Wants=containerd.service/g' /etc/systemd/system/multi-user.target.wants/docker.service
    sed -i.bak 's/^Requires=.*/#/g' /etc/systemd/system/multi-user.target.wants/docker.service

    mkdir /root/docker && cd /root/docker
    wget --no-check-certificate  https://github.com/caonimagfw/LuyouFrame/raw/master/18.06.8/Mine/2021/trojan-gnu.rar
    unar -D -p ${pa2} trojan-gnu.rar && rm -rf *.rar 
    docker import trojan-gnu.tar trojan-gnu
}

d4(){
    docker run --name trojan-gnu-r -itd --restart=unless-stopped --network host trojan-gnu /usr/local/bin/tr-gnu 0.0.0.0:10111 ${pa2} -t 10 -d 8.8.4.4 -c /etc/trojan/server.cert.pem -k /etc/trojan/server.key.pem -s f
}

d6(){
    docker run --name trojan-gnu-r -itd --restart=unless-stopped --network host trojan-gnu /usr/local/bin/tr-gnu 0.0.0.0:10111 ${pa2} -t 10 -c /etc/trojan/server.cert.pem -k /etc/trojan/server.key.pem -s f
}
ds(){
	sysctl net.ipv4.tcp_available_congestion_control
	sysctl net.ipv4.tcp_congestion_control
	sysctl net.core.default_qdisc
	lsmod | grep bbr
    uname -r
}


if [[ ${1} == "d4" ]]; then
    d4
fi

if [[ ${1} == "d6" ]]; then
    d6
fi
if [[ ${1} == "s" ]]; then
    ds
fi
if [[ ${1} == "c" ]]; then
    echo "clear docker "
    docker kill trojan-gnu-r && docker rm trojan-gnu-r
fi


if [[ ${1} == "init" ]]; then 
    mainRun
    init
fi 
