# proxyサーバのIPアドレスとポート番号を設定。
PROXY_ADDR="10.1.4.2"
PROXY_PORT=8080

/usr/sbin/setenforce 0
sudo sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config

cat <<EOM | sudo tee -a /etc/yum.repos.d/epel.repo
[epel]
name=epel
baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch
enabled=0
gpgcheck=0
EOM

cat <<EOM | sudo tee -a /etc/yum.conf
proxy=http://${PROXY_ADDR}:${PROXY_PORT}/
EOM

sudo sed -i -e 's/^#baseurl/baseurl/' /etc/yum.repos.d/CentOS-Base.repo
sudo sed -i -e 's/mirror\.centos\.org/ftp\.iij\.ad\.jp\/pub\/linux/' /etc/yum.repos.d/CentOS-Base.repo
sudo sed -i -e 's/^mirrorlist/#mirrorlist/' /etc/yum.repos.d/CentOS-Base.repo
sudo rpm --httpproxy $PROXY_ADDR --httpport $PROXY_PORT --import http://ftp.iij.ad.jp/pub/linux/centos/RPM-GPG-KEY-CentOS-6

sudo yum -y install gcc make automake autoconf libtool gcc-c++ kernel-headers-`uname -r` kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl wget nfs-utils bind-utils policycoreutils-python
sudo yum -y --enablerepo=epel install dkms
sudo yum clean all

mkdir -pm 700 /home/vagrant/.ssh
curl -x $PROXY_ADDR:$PROXY_PORT "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub" -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

cd /tmp
sudo mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
sudo sh /mnt/VBoxLinuxAdditions.run
sudo umount /mnt

sudo /etc/rc.d/init.d/vboxadd setup
curl -x $PROXY_ADDR:$PROXY_PORT -L https://www.chef.io/chef/install.sh | sudo bash
