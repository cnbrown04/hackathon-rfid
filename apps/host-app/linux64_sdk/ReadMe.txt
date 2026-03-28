README 
------

Prerequisite for Building RFIDSample4 for C:
-------------------------------------------
Ubuntu 16.04/18.04 (64 bit):
---------------------------
Install development tools 'gcc-5 (5.4.0-6ubuntu1~16.04.12)/make (4.1-6)' for Ubuntu 16.04, 
 'gcc-7 (7.5.0-3ubuntu1~18.04)/make (4.1-9.1ubuntu1)' for Ubuntu 18.04 and   
its dependencies using command 'apt-get install'. 

Install additional packages and create symbolic links as follows:

Packages: 
---------
zlib1g:amd64 and zlib1g-dev:amd64 (1.2.11.dfsg-0ubuntu2 for Ubuntu 18.04/ 1:1.2.8.dfsg-2ubuntu4.3 for Ubuntu 16.04)
libxml2:amd64 and libxml2-dev:amd64 (2.9.4+dfsg1-6.1ubuntu1.3 for 18.04/ 2.9.3+dfsg1-1ubuntu0.7 for Ubuntu 16.04)
libssh2-1:amd64 and libssh2-1-dev:amd64 (1.8.0-1 for Ubuntu 18.04/ 1.5.0-2ubuntu0.1 for Ubuntu 16.04)

CentOS 8.2 (64 bit):
-------------------

Install following development tools packages and its dependcies using 'yum install'.

gcc-8.3.1-5.el8.0.2.x86_64
gcc-c++-8.3.1-5.el8.0.2.x86_64

Install additional packages and create symbolic links as follow:
libxml2-2.9.7-7.el8.x86_64
libxml2-devel-2.9.7-7.el8.x86_64
libssh2-1.9.0-5.el8.x86_64
libssh2-devel-1.9.0-5.el8.x86_64
zlib-1.2.11-13.el8.x86_64
zlib-devel-1.2.11-13.el8.x86_64

steps to build RFIDSample4 for C
--------------------------------
cd linux64_sdk/samples/src/c/RFIDSample4
make linux64_clean
make linux64_release

Application once compiled will be availble in 
linux64_sdk/samples/src/c/RFIDSample4/bin/linux64_release

Prebuilt binary available in
linux64_sdk/samples/src/c/bin

Steps to run the RFIDSample4 for C
-----------------------------------
export LD_LIBRARY_PATH=<INSTALL_PATH>/linux64_sdk/lib
./rfidsample4.elf <readerIP:default 127.0.0.1> <Port:default 5084>


Prerequisite for Building Java Apps
-------------------------------------
Ubunt 16.04/Ubuntu 18.04:
------------------------
JDK 1.8
Install following package: 
$ sudo apt-get install ant 
(ant version: 1.9.6-1ubuntu1.1 for Ubuntu 16.04/
              1.10.5-3~18.04 for ubuntu 18.04)

CentOS 8.2
-----------
JDK 1.8
Install following package: 
$ sudo yum install ant
(ant version : ant-1.10.5-1.module_el8.0.0+47+197dca37.noarch)

steps to build J_RFIDSample4 for java
---------------------------------------------------
cd to linux64_sdk/samples/src/java/J_RFIDSample4
execute the following
ant clean
ant

Java Application will be available in 
linux64_sdk/samples/src/java/J_RFIDSample4/dist

Prebuilt binary available in
linux64_sdk/samples/bin/java


Steps to run the J_RFIDSample4 for Java
---------------------------------------
cd dist
export LD_LIBRARY_PATH=/home/rfidlab/hackathon-rfid/apps/host-app/linux64_sdk/lib
java -cp "J_RFIDSample4.jar:/home/rfidlab/hackathon-rfid/host-app/linux64_sdk/lib/Symbol.RFID.API3.jar" rfidsample4.RFIDSample4 192.168.50.101 5084



steps to build J_RFIDHostSample1 for Java
------------------------------------------
cd samples/src/java

Execute the following
ant -f J_RFIDHostSample1 -Dnb.internal.action.name=rebuild clean jar

Java Application will be available in 
linux64_sdk/samples/src/java/J_RFIDHostSample1/dist

Prebuilt binary available in
linux64_sdk/samples/bin/java

Steps to run the J_RFIDHostSample1 for Java
-------------------------------------------
cd dist
export LD_LIBRARY_PATH=/home/rfidlab/hackathon-rfid/apps/host-app/linux64_sdk/lib
java -cp "J_RFIDHostSample1.jar:/home/rfidlab/hackathon-rfid/apps/host-app/linux64_sdk/lib/Symbol.RFID.API3.jar" rfidsample.RFIDMainDlg



