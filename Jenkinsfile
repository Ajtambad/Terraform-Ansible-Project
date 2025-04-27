pipeline {
    agent any
    stages {
        stage('Run Terraform') {
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'jenkins-ec2-instance_key',
                    keyFileVariable: 'SSH_KEY_FILE',
                    usernameVariable: 'SSH_USER'
                )]) {
                    dir('Terraform'){
                        sh 'terraform init'
                        sh 'terraform plan -var="ssh_key_file=$(SSH_KEY_FILE)"'
                        sh 'terraform apply -var="ssh_key_file=$(SSH_KEY_FILE)" -auto-approve'
                    }
                }
            }
        }
        stage('Get and add IP Address of new EC2 instance'){
            steps{
                dir('Ansible'){
                    script{
                        def getIPRetry = true
                        retry(3){
                            def ipAddrOutput = sh(
                                script: 'aws ec2 describe-instances --filters "Name=tag:Name, Values=web-host-instance" "Name=instance-state-name, Values=running" --query "Reservations[*].Instances[*].NetworkInterfaces[*].Association.PublicIp" --output text',
                                returnStdout: true
                            ).trim()
                            if (ipAddrOutput == '') {
                                echo "IP Address not found, retrying after 30 seconds"
                                sleep time: 30
                                error("IP not found, retrying")
                            }
                            else{
                                echo "Found IP : ${ipAddrOutput}"
                                writeFile(file: 'hosts', text: "[webservers] \n${ipAddrOutput}")
                            }
                        }
                    }
                }
            }
        }
        stage('Run Ansible'){
            steps{
                dir('Ansible'){
                    script{
                        sleep time: 40
                        sh 'ansible-playbook -i hosts playbook.yaml -u ec2-user --private-key AWS-key-pair.pem --ssh-extra-args="-o StrictHostKeyChecking=no"'
                    }
                    
                }
            }
        }
        stage('Schedule Destroy') {
            steps {
                script {
                    build job: 'terraform-destroy-pipeline',
                    wait: false,
                    quietPeriod: 900

                }
            }
        }            
    }
}
