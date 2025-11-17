pipeline {
    agent any

    environment {
        IMAGE_NAME = 'crudjs-app'
        NODE_CONTAINER = 'node_app_jenkins'
        MYSQL_CONTAINER = 'mysql_db_jenkins'
        ADMINER_CONTAINER = 'adminer_jenkins'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Clonando el repositorio..."
                // Repositorio público, sin credenciales
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
                    echo "Deteniendo y eliminando contenedores antiguos si existen..."
                    // Fuerza eliminación de contenedores viejos
                    bat "docker rm -f %NODE_CONTAINER% %MYSQL_CONTAINER% %ADMINER_CONTAINER% || echo Containers not found"

                    echo "Levantando contenedores con docker-compose..."
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
            echo 'Pipeline falló. Revisa la consola de Jenkins para detalles.'
        }
    }
}
