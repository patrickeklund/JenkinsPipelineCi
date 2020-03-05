pipeline {
    agent none

    environment {
        CI = 'true'
    }

    stages {
        stage('Build') {
            steps {
                echo('echo Stage build')
            }
        }
        stage('Test') {
            steps {
              echo('echo Stage build')
            }
        }
        stage('Deliver for master') {
            when {
                branch 'master'
            }
            steps {
                echo('echo Stage delivery')
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
