import boto3, json
secret_name_tag = 'dev-rds-db'
ssm = boto3.client('ssm', region_name='us-east-1')
secrets_client = boto3.client('secretsmanager', region_name='us-east-1')
FILE_PATH = "/opt/application.properties"
rds_endpoint = ssm.get_parameter(Name='/java/dev/rds_endpoint')['Parameter']['Value']
secrets_list = secrets_client.list_secrets()
secret_arn = None
for secret in secrets_list['SecretList']:
    if 'Tags' in secret:
        for tag in secret['Tags']:
            if tag['Key'] == 'Name' and tag['Value'] == secret_name_tag:
                secret_arn = secret['ARN']
if secret_arn is None:
    print(f"Secret with name tag '{secret_name_tag}' not found.")
    exit(1)
response = secrets_client.get_secret_value(SecretId=secret_arn)
secret_value = response['SecretString']
secret_data = json.loads(secret_value)
with open(FILE_PATH, 'r') as file:
    content = file.read()
content = content.replace('spring.datasource.url=jdbc:mysql://localhost:3306/petclinic', f'spring.datasource.url=jdbc:mysql://{rds_endpoint}')
content = content.replace('spring.datasource.username=petclinic', f'spring.datasource.username={secret_data["username"]}')
content = content.replace('spring.datasource.password=petclinic', f'spring.datasource.password={secret_data["password"]}')
with open(FILE_PATH, 'w') as file:
    file.write(content)