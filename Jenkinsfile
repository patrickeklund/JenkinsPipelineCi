pipeline {
    agent none

    environment {
        CI = 'true'
    }

    stages {
        stage('Build') {
            steps {
                bat 'echo Stage build'
            }
        }
        stage('Test') {
            steps {
              bat 'echo Stage build'
            }
        }
        stage('Deliver for master') {
            when {
                branch 'master'
            }
            steps {
                bat 'echo Stage delivery'
            }
        }
        stage('Deploy for production') {
            when {
                branch 'production'
            }
            steps {
              bat 'echo Stage production'
            }
        }
    }
}
