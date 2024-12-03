first you need to generate a personal access token in GitHub for credentials

go to setting and and developer setting and go to personal access tokens and classic token select the required boxes and then generate token

copy the code to local repo and create a docker file build and test and then delete 

ifirst you need to generate a personal access token in GitHub for credentials

go to setting and and developer setting and go to personal access tokens and classic token select the required boxes and then generate token

copy the code to local repo and create a docker file build and test and then delete and also push the code to the dockerhub

and push the code to the repo 
===============================================================
to generate a project token in sonarqube create a project give a name which you can remember and key to same as name branch main then click setup
now choose locally and generate a token and copy the token and continue and the project type etc to get code
=========================================================================================
if above process is already done start from here
======================================================
actual project
==========

install git docker Jenkins git in Jenkins machine

go to the ec2 machine of Jenkins where docker is installed and change the permission to user docker in jenkins
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

then restart the docker container

docker run -d --name sonar -p 9000:9000 sonarqube:lts-community -- to run a SonarQube container 


first need to install the dependency like nodejs and sonar scanner plugins 

now go to manage Jenkins > tools > and install SonarQube scanner name as SonarQube and install the latest version same for nodejs and name it as NodeJS so we can use in pipeline

now go to manage Jenkins > system > go to SonarQube server and enable environmental variable(so we can use SonarQube as env in project pipeline) and name it as sonarQube copy paste server url and token of project in the sonarqube


pipeline {
    agent any

    tools {
        nodejs 'NodeJS' // Use the name configured in Jenkins Global Tool Configuration
    }

    environment {
        // Inject the SonarQube token securely using Jenkins credentials
        SONAR_AUTH_TOKEN = credentials('sonar-token') 
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/santoshpalla27/basic-cicd.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarQube') { // Use the configured SonarQube server name
                    sh '''
                        npx sonar-scanner \
                        -Dsonar.projectKey=nginx \
                        -Dsonar.projectName="nginx" \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=. \
                        -Dsonar.language=js \
                        -Dsonar.sourceEncoding=UTF-8 \
                        -Dsonar.login=$SONAR_AUTH_TOKEN \
                        -Dsonar.host.url=http://44.211.140.121:9000/
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker rmi -f nginx || true" // Ignore errors if the image doesn't exist
                sh "docker build -t nginx ."
            }
        }

        stage('Docker Run') {
            steps {
                sh "docker container rm -f nginx || true" // Remove existing container if it exists
                sh "docker container run --name nginx -d -p 80:80 nginx"
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed!'
        }
    }
}
