first you need to generate a personal access token in GitHub for credentials

go to setting and and developer setting and go to personal access tokens and classic token select the required boxes and then generate token

copy the code to local repo and create a docker file build and test and then delete 

install git docker Jenkins git in Jenkins machine

go to the ec2 machine of Jenkins where docker is installed and change the permission to 

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo systemctl restart docker

and run this jenkinsfile

pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/santoshpalla27/basic-cicd.git'
            }
        }
        stage('Docker Build') {
            steps {
                sh " docker rmi -f nginx || true" // Ignore errors if the image doesn't exist
                sh " docker build -t nginx ."
            }
        }
        stage('Docker Run') {
            steps {
                sh " docker container rm -f nginx || true" // Remove existing container if it exists
                sh " docker container run --name nginx -d -p 80:80 nginx"
            }
        }
    }
}
