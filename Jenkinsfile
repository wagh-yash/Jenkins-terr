```groovy
pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Terraform action to run'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Tool Versions') {
            steps {
                sh 'git --version'
                sh 'terraform version'
                sh 'docker version --format "Docker {{.Server.Version}}"'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                sh 'terraform apply -input=false -auto-approve tfplan'
            }
        }

        stage('Verify Container') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                sh 'docker ps -a --filter name=hello-from-terraform'
                sh 'docker logs hello-from-terraform'
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }
            steps {
                sh 'terraform destroy -input=false -auto-approve'
            }
        }
    }

    post {
        success {
            echo "Pipeline finished: terraform ${params.ACTION} succeeded."
        }

        failure {
            echo 'Pipeline failed. Check the stage logs above.'
        }
    }
}
```

