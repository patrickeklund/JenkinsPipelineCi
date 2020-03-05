library identifier: 'https://github.com/patrickeklund/JenkinsPipelineCi@sharedlibraries',
	retriever: modernSCM(
		[
			$class:         'GitSCMSource',
			credentialsId:  patrickeklund,
			remote:         'https://github.com/patrickeklund/JenkinsPipelineCi.git'
		]
	)

pipeline {
    agent none

    environment {
        CI = 'true'
        LOG_DEBUG = 'true'
    }

    stages {
        stage('Build') {
            steps {
                echo('echo Stage build')
                getEnv()
            }
        }
        stage('Test') {
            steps {
              echo('echo Stage build')
            }
        }
        stage('Deliver for master') {
            when {
                environment name: 'BRANCH_NAME', value: 'master'
            }
            steps {
                echo('echo Stage master')
            }
        }
        stage('Deploy for production') {
            when {
                branch 'production'
            }
            steps {
              echo('echo Stage production')
            }
        }
    }
}
