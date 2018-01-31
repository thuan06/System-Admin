# Install all
yum install -y epel-release vim
yum install -y open-vm-tools wget curl telnet gcc c++ make bind-utils net-tools gzip gunzip tar tmux atop sysstat ntp nload rsync logrotate git bc nc tcpdump man go unzip
yum groupinstall "Development tools" -y


ntpdate pool.ntp.org
service ntpd start

# Disable selinux
setenforce 0
sed -i 's/SELINUX=*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/SELINUX=*/SELINUX=disabled/' /etc/selinux/config

#Change SSH port
sed -i 's/#Port\ 22/Port\ 65535/' /etc/ssh/sshd_config
sed -i 's/#TCPKeepAlive/TCPKeepAlive/' /etc/ssh/sshd_config
service sshd restart 

#Add firewalld rules

iptables -I INPUT 4 -m tcp --dport 65535 -j ACCEPT
iptables -I INPUT 4 -m tcp -s 210.211.121.24, 10.68.68.11 --dport 9100 -j ACCEPT
service iptables reload
service iptables save

# User limit 
echo "*       -       nproc   64000" >> /etc/security/limits.conf
echo "*       soft    nofile  64000" >> /etc/security/limits.conf
echo "*       hard    nofile  64000" >> /etc/security/limits.conf
echo "*          soft    nproc     unlimited" >> /etc/security/limits.d/90-nproc.conf
echo "root       soft    nproc     unlimited" >>/etc/security/limits.d/90-nproc.conf


# sysctl config
