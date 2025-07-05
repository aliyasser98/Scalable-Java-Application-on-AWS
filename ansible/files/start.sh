#!/bin/bash
jar_file=/home/ubuntu/spring-petclinic-3.1.0-SNAPSHOT.jar
app_properties=/opt/application.properties
app_properties_script=/home/ubuntu/app_properties.py
sudo python3 ${app_properties_script}
sudo java -jar ${jar_file} --spring.config.location=file:${app_properties} --spring.profiles.active=mysql --server.port=8080  &