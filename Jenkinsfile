pipeline {
    agent any
	options {
        ansiColor('xterm')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
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
                        sh 'trivy image -f json -o results.json vue2048'
                    }
                    post {
                      success {
                          recordIssues(tools: [trivy(pattern: 'result.json')])
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
            }
        }
    }
}
