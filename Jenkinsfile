pipeline {
    agent any

    environment {
        IMAGE_NAME = 'crudjs-app'
        NODE_CONTAINER = 'node_app'      
        MYSQL_CONTAINER = 'mysql_db'      
        ADMINER_CONTAINER = 'adminer'    
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Clonando el repositorio..."
                git branch: 'main', url: 'https://github.com/LorehM18/crudjs.git'
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    echo "Limpiando contenedores existentes..."
                    bat "docker-compose down --remove-orphans --volumes || echo No hay compose previo"
                    bat "docker rm -f ${env.NODE_CONTAINER} ${env.MYSQL_CONTAINER} ${env.ADMINER_CONTAINER} || echo Contenedores no encontrados"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Construyendo la imagen Docker..."
                    bat "docker build -t ${env.IMAGE_NAME} ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Ejecutando pruebas con Jest..."
                    bat "npm install"
                    bat "npm test"
                }
            }
        }

        stage('Deploy Containers') {
            steps {
                script {
                    echo "Levantando contenedores con docker-compose..."
                    bat "docker-compose up -d --build"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completado correctamente!'
            echo "Aplicación disponible en: http://localhost:3001"
            echo "Adminer disponible en: http://localhost:8080" 
        }
        failure {
            echo 'Pipeline falló.'
            script {
                echo "Debug información:"
                bat "docker ps -a"
                bat "docker logs mysql_db --tail 10 || echo No logs de MySQL"
            }
        }
    }
}
