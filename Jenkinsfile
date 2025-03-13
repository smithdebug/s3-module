pipeline {
    agent any
    
    // Define environment variables
    environment {
        TERRAGRUNT_DIRECTORY = "${WORKSPACE}/terraform-stack/s3"
        TERRAFORM_MODULE_DIRECTORY = "${WORKSPACE}/Modules/s3_module"
    }
    
    // Define pipeline stages
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from version control
                checkout scm
            }
        }
        
        stage('Terragrunt Init') {
            agent {
                docker {
                    image 'alpine/terragrunt:latest'
                    reuseNode true
                }
            }
            steps {
                dir("${env.TERRAGRUNT_DIRECTORY}") {
                    sh 'terragrunt init --terragrunt-non-interactive'
                }
            }
        }
        
        stage('Terragrunt Plan') {
            agent {
                docker {
                    image 'alpine/terragrunt:latest'
                    reuseNode true
                }
            }
            steps {
                dir("${env.TERRAGRUNT_DIRECTORY}") {
                    // Create plan and save it to a file
                    sh 'terragrunt plan -out=tfplan --terragrunt-non-interactive'
                    
                    // Optionally, show the plan in a more readable format
                    sh 'terragrunt show -no-color tfplan > tfplan.txt'
                    
                    // Archive the plan as an artifact
                    archiveArtifacts artifacts: 'tfplan.txt', onlyIfSuccessful: true
                }
            }
        }
        
        stage('Approval') {
            steps {
                // Wait for manual approval before applying changes
                input message: 'Deploy the infrastructure?', ok: 'Deploy'
            }
        }
        
        stage('Terragrunt Apply') {
            agent {
                docker {
                    image 'alpine/terragrunt:latest'
                    reuseNode true
                }
            }
            steps {
                dir("${env.TERRAGRUNT_DIRECTORY}") {
                    // Apply the previously created plan
                    sh 'terragrunt apply -auto-approve tfplan --terragrunt-non-interactive'
                }
            }
        }
    }
    
    post {
        always {
            // Clean workspace
            cleanWs()
        }
        success {
            echo 'Terragrunt deployment completed successfully!'
        }
        failure {
            echo 'Terragrunt deployment failed!'
            // Optionally, you could add notifications here (email, Slack, etc.)
        }
    }
}
