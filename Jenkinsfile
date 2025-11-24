pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret')
        AWS_REGION            = 'ap-south-1'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init (Migrate Backend State)') {
            steps {
                sh """
                    terraform init -migrate-state || terraform init -reconfigure
                """
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                    terraform init -reconfigure
                    terraform plan -out=tfplan
                """
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.APPLY == true }
            }
            steps {
                sh "terraform apply -auto-approve tfplan"
            }
        }
    }

    parameters {
        booleanParam(name: 'APPLY', defaultValue: false, description: 'Apply Terraform?')
    }

    post {
        always {
            echo "Pipeline completed."
        }
    }
}
