pipeline {
agent any
environment {
TF_VAR_db_password = credentials('rds-db-password') // store sensitive in Jenkins
AWS_CREDS = credentials('aws-creds')
TF_BACKEND_BUCKET = "terraform-bucket-27987" // or pass as param
TF_BACKEND_REGION = "us-east-1"
}


stages {
stage('Checkout') {
steps {
checkout scm
}
}


stage('Install Terraform') {
steps {
sh '''
if ! command -v terraform >/dev/null 2>&1; then
wget https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
unzip terraform_1.5.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
fi
terraform -v
'''
}
}


stage('Terraform Init') {
steps {
withEnv(["AWS_ACCESS_KEY_ID=${AWS_CREDS_USR}", "AWS_SECRET_ACCESS_KEY=${AWS_CREDS_PSW}", "AWS_DEFAULT_REGION=${TF_BACKEND_REGION}"]) {
sh "terraform init -backend-config=\"bucket=${TF_BACKEND_BUCKET}\" -backend-config=\"region=${TF_BACKEND_REGION}\""
}
}
}


stage('Terraform Plan') {
steps {
withEnv(["AWS_ACCESS_KEY_ID=${AWS_CREDS_USR}", "AWS_SECRET_ACCESS_KEY=${AWS_CREDS_PSW}"]) {
sh 'terraform plan -out=tfplan'
}
}
}


stage('Terraform Apply') {
steps {
}