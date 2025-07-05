# Scalable Java Application on AWS with ASG, ALB, and RDS Using Terraform

## 📌 Project Overview

This project demonstrates how to set up a scalable Java application on AWS using DevOps tools and infrastructure as code (IaC) practices. The architecture includes an **Auto Scaling Group (ASG)**, **Application Load Balancer (ALB)**, and **RDS database**, all provisioned using Terraform, with Packer and Ansible used to build a pre-configured AMI.

## Prerequisites 
**Before you begin, ensure the following tools are installed on your local machine:**
- Packer  - To building Customized Java Application AMI
- Ansible - To configure java application during the AMI building process
- Terraform - for infrastructure provisioning on AWS
- JDK 17 & Maven version >3.0 for building src code of the java app will be deployed on EC2 Launch Template for ASG
- AWS CLI - for managing AWS resources


## 📁 Project Structure
```plaintext
README.md
ansible/
├── files/
│   ├── app_properties.py
│   ├── application.properties
│   ├── spring-petclinic-3.1.0-SNAPSHOT.jar
│   └── start.sh
├── java-app.yaml
├── roles/
│   └── Java/
│       └── tasks/
│           └── main.yaml
└── templates/
    ├── config.json.j2
    └── index.html.j2
java-app.pkr.hcl         
terraform/
├── environments/
│   ├── backend/
│   │   ├── main.tf
│   │   ├── terraform.tfstate
│   │   ├── terraform.tfstate.backup
│   │   └── variables.tf
│   └── dev/
│       ├── backend.tf
│       ├── main.tf
│       ├── terraform.tfstate.backup
│       ├── tf.tfvars
│       └── variables.tf
└── modules/
    ├── alb-asg/
    │   ├── iam-policy.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── backend/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── rds/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── vpc/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

## 🚀 Deployment Steps
### 1. Build Java Application

```bash
git clone https://github.com/pet-clinic-project/pet-clinic-app.git
cd pet-clinic-app
mvn clean install -DskipTests
```
Result file : spring-petclinic-xxxxxx.jar 
 

### 2. Provision Java Application AMI
Step 1: Copy JAR
Copy the JAR file to ansible/files/ and update ansible/java-app.yml:
```bash
files:
  - properties.py
  - start.sh
  - spring-petclinic-xxxxxx.jar 
```
Step 2: Update **start.sh**
```bash
#!/bin/bash
jar_file=/home/ubuntu/spring-petclinic-xxxxxx.jar 
app_properties=/opt/application.properties
app_properties_script=/home/ubuntu/app_properties.py
sudo python3 ${app_properties_script}
sudo java -jar ${jar_file} --spring.config.location=file:${app_properties} --spring.profiles.active=mysql --server.port=8080  &
```
Step 3: Validate & Build AMI
```bash
packer validate java-app.pkr.hcl
packer build java-app.pkr.hcl
```
### 3. Provision AWS Resources
Step 1: Provsion **S3 Bucket** for Remote Backend and DynamoDB Table for state Locking
```bash
cd terraform/environments/backend/
terraform init
terraform plan
terraform apply --auto-approve
```
Step 2: Edit backend.tf under /environments/dev to Update Bucket name for remote backend
```bash
terraform {
  backend "s3" {
    bucket= "tfstate-lock-dev-2f09ad72" >>> # Update Bucket name with real Provisoined bucket
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws_dynamodb-lock"
    encrypt        = true    
  }
}

Step 3: Create `tf.tfvars` for Provisioning VPC, ALB, and RDS
```hcl
environment             = "<your-environment-name>"            # e.g. dev
vpc_cidr                = "<your-vpc-cidr>"                    # e.g. 10.0.0.0/16
public_subnet_cidrs    = ["<subnet-cidr-1>", "<subnet-cidr-2>"]  # e.g. ["10.0.1.0/24", "10.0.2.0/24"]
availability_zones     = ["<az-1>", "<az-2>"]                  # e.g. ["us-east-1a", "us-east-1b"]
instance_type          = "<instance-type>"                    # e.g. t2.micro
ami_id                 = "<ami created by packer>"            # e.g. ami-0abcdef1234567890
min_size               = 1
max_size               = 3
desired_capacity       = 2
key_name               = "<your-ec2-keypair-name>"     # Replace with exisiting Key Pair name
user_data = <<EOF
#!/bin/bash
bash /home/ubuntu/start.sh
EOF
region                 = "<aws-region>"         # e.g. us-east-1
db_instance_class      = "<db-class>"           # e.g. db.t3.micro
db_allocated_storage   = <storage-size-in-gb>   # e.g. 20
db_name                = "<database-name>"      # e.g. petclinic
db_username            = "<db-username>"        # Username will be sotred in Secrets manager
db_password            = "<db-password>"        # Password will be stored in Secrets manager
```
Step 4: Start Provison VPC, ALB, and RDS resources
```bash
cd terraform/environments/dev
terraform init
terraform plan --var-file=tf.tfvars
terraform apply --var-file=tf.tfvars --auto-approve
```
Step 5: Access your application in the browser using the load-balancer DNS through port 80