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
                        // Get some code from a GitHub repository
                        //git branch: 'main', url: 'https://github.com/anrmgft/hello-springrest.git'

                        // Run Maven on a Unix agent.

        		//yarn "install"
                        //yarn "build"

        		sh "docker-compose build"

                        // To run Maven on a Windows agent, use
                        // bat "mvn -Dmaven.test.failure.ignore=true clean package"
                    }
        }
        stage('Parallel Stage') {
            when {
                branch 'main'
            }
            failFast true
            parallel {
                stage('Trivy'){
                    steps{
                        sh 'trivy fs -f json -o results.json .'
                      }
                    post {
                      success {
                          recordIssues(tools: [trivy(pattern: 'result.json')])
                      }
                    }
                }
                stage('Trivy Image') {
                    steps {
                        sh 'trivy image -f json -o results.json anrmgft/2048'
                    }
                    post {
                      success {
                          recordIssues(tools: [trivy(pattern: 'result.json')])
                      }
                    }
                }
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
                   sh "echo '${pass}' | docker login ghcr.io -u anrmgft --password-stdin"
                   sh 'docker push ghcr.io/anrmgft/2048:latest '
                }


            }
        }

    }
}
