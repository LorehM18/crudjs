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
                echo 'Ejecutando tests...'
                bat 'docker run --rm crudjs-app npm test'
            }
        }
        stage('Deploy Containers') {
            steps {
                echo 'Desplegando contenedores...'
                bat 'docker-compose up -d'
            }
        }
    }
}
