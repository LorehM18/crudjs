pipeline {
    agent any
    environment {
        DOCKER_BUILDKIT = '1'
    }
    stages {

        stage('Checkout') {
            steps {
                echo 'Clonando repositorio...'
                checkout scm
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Limpiando contenedores antiguos...'
                bat 'docker rm -f node_app mysql_db adminer || echo Contenedores no encontrados'
                bat 'docker-compose down --remove-orphans --volumes || echo No hay compose previo'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construyendo imagen Docker...'
                bat 'docker build -t crudjs-app .'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Levantando DB para tests...'
                bat 'docker-compose up -d db'
                
                echo 'Ejecutando tests...'
                bat 'docker run --rm --env-file .env.test crudjs-app npm test'
                
                echo 'Deteniendo DB de tests...'
                bat 'docker-compose down'
            }
        }

        stage('Deploy Containers') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                echo 'Desplegando contenedores...'
                bat 'docker-compose up -d'
            }
        }

    }
}
