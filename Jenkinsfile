pipeline {
    agent any

    environment {
        IMAGE_NAME = 'crudjs-app'
        CONTAINER_NAME = 'node_app'
    }

    stages {
        stage('Checkout') {
            steps {
                // Repo público: sin credenciales
                git branch: 'main', url: 'https://github.com/LorehM18/crudjs.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Construyendo la imagen Docker..."
                    bat "docker build -t %IMAGE_NAME% ."
                }
            }
        }

        stage('Deploy Containers') {
            steps {
                script {
                    echo "Deteniendo contenedores existentes..."
                    bat "docker-compose down"
                    
                    echo "Levantando contenedores..."
                    bat "docker-compose up -d --build"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completado correctamente!'
        }
        failure {
            echo 'Pipeline falló.'
        }
    }
}
