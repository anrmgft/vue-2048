pipeline {
    agent any
	options {
        ansiColor('xterm')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    environment {
        dockerhub=credentials('dockerhub')
    }

    stages {

        stage('Build') {
                    steps {
                       
        		sh "docker-compose build"

                       
                    }
        }
        stage('Deploy') {
                    steps {

                sh "scp -i ./docker-compose.yml ec2-user@3.248.181.69:/home/ec2-user"      
                sh "ssh ec2-user@3.248.181.69 /usr/local/bin/docker-compose up -d --no-build"

                       
                    }
        }
        

        stage('Publish') {
            steps{
                sshagent(['github-ssh']) {
                            sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                            sh 'git push --tags'
                }
                //sh 'docker tag anrmgft/2048:latest anrmgft/2048:1.01'
                sh 'echo $dockerhub_PSW | docker login -u anrmgft --password-stdin'
                //sh 'docker push anrmgft/2048:1.01 '
                sh 'docker push anrmgft/2048:latest '
            }
        }
        stage('Registry') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'pass', usernameVariable: 'user')]) {
                   sh 'docker tag ghcr.io/anrmgft/2048:latest ghcr.io/anrmgft/2048:1.0.${BUILD_NUMBER} '
                   sh "echo '${pass}' | docker login ghcr.io -u anrmgft --password-stdin"
                   sh 'docker push ghcr.io/anrmgft/2048:1.0.${BUILD_NUMBER} '
                }


            }
        }

    }
}
