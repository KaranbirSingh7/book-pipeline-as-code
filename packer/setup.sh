#!/bin/bash
set -euo pipefail

echo "hello jenkins, we meet again"
echo "Install Jenkins stable release"
yum update -y -q
yum install -y -q wget fontconfig jq
amazon-linux-extras install java-openjdk11
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "installing jenkins"
yum update -y -q
yum install -y -q git jenkins

# # ISSUES: jenkins service timeout on initial startup sometime?!
# # RESOLUTION: modify systemd config
# systemctl show jenkins | grep ^Timeout

echo "enabling jenkins so that it can auto start on boot"
systemctl enable jenkins

echo "Configure Jenkins"
mkdir -p /var/lib/jenkins/init.groovy.d
mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
# mv /tmp/config/jenkins /etc/sysconfig/jenkins
# chmod +x /tmp/config/install-plugins.sh
# mkdir -p /var/lib/jenkins/plugins
# chown -R jenkins:jenkins /var/lib/jenkins/plugins
# bash /tmp/config/install-plugins.sh

yum clean all

# echo "setup SSH key"
# systemctl start jenkins
