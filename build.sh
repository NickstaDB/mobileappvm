#!/bin/bash

#Grab current path for later
curpath=`pwd`

#Update stuff
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

#Install stuff
sudo apt-get -y install open-vm-tools-desktop git terminator adb python3-pip python python-pip openjdk-11-jdk zipalign docker.io aapt apksigner
sudo snap install --classic code

#Python stuff
pip install androguard drozer twisted
pip3 install asn1crypto bcrypt cffi click colorama cryptography delegator.py enum34 flask frida frida-tools idna ipaddress litecli objection paramiko prompt-toolkit pyasn1 pycparser Pygments PyNaCl requests scp six tabulate tasks tqdm wcwidth

#Grab tools from Github
mkdir ~/tools
cd ~/tools
git clone https://github.com/nelenkov/android-backup-extractor
git clone https://github.com/iBotPeaches/Apktool apktool
git clone https://github.com/AloneMonkey/frida-ios-dump
git clone https://github.com/NickstaDB/patch-apk

#Build Android Backup Extractor
cd ~/tools/android-backup-extractor
gradle

#Build apktool, removing "-SNAPSHOT" from the version number as this breaks objection's version detection
cd ~/tools/apktool
sed -i "s/def apktoolversion_minor = 'SNAPSHOT';/def apktoolversion_minor = '';/g" build.gradle
./gradlew
./gradlew build release shadowJar

#Mobile security framework docker image
sudo chmod 666 /var/run/docker.sock
docker pull opensecurity/mobile-security-framework-mobsf

#Ghidra
cd ~/tools
wget https://ghidra-sre.org/ghidra_9.1.2_PUBLIC_20200212.zip
unzip ghidra_9.1.2_PUBLIC_20200212.zip
ln -s ~/tools/ghidra_9.1.2_PUBLIC/ghidraRun ${curpath}/bin/ghidra

#Add scripts/tools to path
echo "PATH=\$PATH:${curpath}/bin" >> ~/.profile

#Reminder to source .profile
echo "Run \"source .profile\" to fix the PATH of the current shell."
