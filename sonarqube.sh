# INSTALL SONARQUBE
  
    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube

https://gist.github.com/dmancloud/0abf6ad0cb16e1bce2e907f457c8fce9

https://community.sonarsource.com/t/sonarqube-service-is-active-on-server-but-url-is-not-working-on-browser/97734

#Install locally

apt install unzip
sudo su
adduser sonarqube
sudo su -sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
unzip *
chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424
cd sonarqube-9.4.0.54424/bin/linux-x86-64/
./sonar.sh start

#install with postgre
# https://medium.com/@deshdeepakdhobi/how-to-install-and-configure-sonarqube-on-aws-ec2-ubuntu-22-04-c89a3f1c2447
 install java jdk
 sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" /etc/apt/sources.list.d/pgdg.list'
 sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
 sudo apt install postgresql postgresql-contrib -y
 sudo systemctl enable postgresql
 sudo systemctl start postgresql
 sudo systemctl status postgresql
 psql --version
 sudo -i -u postgres
 createuser ddsonar
 psql
 ALTER USER ddsonar WITH ENCRYPTED password 'ddsonar9090';
 CREATE DATABASE sonardb OWNER ddsonar;
 GRANT ALL PRIVILEGES ON DATABASE sonardb to ddsonar;
 \l
 \du
 \q
 exit
 sudo apt install zip -y
 sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip
 sudo unzip sonarqube-10.0.0.68432.zip
 sudo mv sonarqube-10.0.0.68432 sonarqube
 sudo mv sonarqube /opt/
 sudo groupadd ddsonar
 sudo useradd -d /opt/sonarqube -g ddsonar ddsonar
 sudo chown ddsonar:ddsonar /opt/sonarqube -R
 sudo nano /opt/sonarqube/conf/sonar.properties
 a) Find the following lines:

#sonar.jdbc.username=

#sonar.jdbc.password=

b) Uncomment the lines, and add the database user and Database password you created in Step 4 (xi and xii). For me, it’s:

sonar.jdbc.username=ddsonar

sonar.jdbc.password=mwd#2%#!!#%rgs

c) Below these two lines, add the following line of code.

sonar.jdbc.url=jdbc:postgresql://localhost:5432/ddsonarqube
save and exit

sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh
a) Add the following line

RUN_AS_USER=ddsonar
save and exitt
i) Create a systemd service file to start SonarQube at system boot.

sudo nano /etc/systemd/system/sonar.service

ii) Paste the following lines to the file.

[Unit]
Description=SonarQube service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=ddsonar
Group=ddsonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096
[Install]
WantedBy=multi-user.target

Note: Here in the above script, make sure to change the User and Group section with the value that you have created. For me its:

User=ddsonar

Group=ddsonar

iv) Enable the SonarQube service to run at system startup.

sudo systemctl enable sonar
v) Start the SonarQube service.

sudo systemctl start sonar
vi) Check the service status.

sudo systemctl status sonar
i) Edit the sysctl configuration file.

sudo nano /etc/sysctl.conf
ii) Add the following lines.

vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

iv) Reboot the system to apply the changes.

sudo reboot
 
