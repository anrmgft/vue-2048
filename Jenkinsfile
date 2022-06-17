pipeline {
    agent any
	options {
        ansiColor('xterm')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }

    stages {
        stage('Trivy'){
                  steps{
                    sh 'trivy fs -f json -o results.json .'
                  }
                   post {
                          // If Gradle was able to run the tests, even if some of the test
                          // failed, record the test results and archive the jar file.
                          success {
                              recordIssues(tools: [trivy(pattern: 'result.json')])
                          }
                      }
                     }
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
