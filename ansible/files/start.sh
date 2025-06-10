#!/bin/bash
jar_file=/home/ubuntu/ansible/spring-petclinic-3.4.0-SNAPSHOT.jar
app_properties=/opt/application.properties
app_properties_script=/opt/app_properties.sh
sudo python3 ${app_properties_script}
sudo java -jar ${jar_file} --spring.config.location=file:${app_properties} &