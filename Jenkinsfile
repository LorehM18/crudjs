pipeline {
    agent any

    environment {
        APP_NAME = 'crudjs-app'
        MYSQL_CONTAINER = 'mysql_db'
        MYSQL_PORT = '3307'
        DOCKER_NETWORK = 'crud-network'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    echo 'Limpiando contenedores previos...'
                    bat """
                        docker stop node_app %MYSQL_CONTAINER% adminer 2>nul || exit 0
                        docker rm node_app %MYSQL_CONTAINER% adminer 2>nul || exit 0
                        docker-compose down --remove-orphans --volumes 2>nul || exit 0
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Construyendo imagen Docker...'
                    bat "docker build --no-cache -t %APP_NAME% ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo 'Creando red Docker si no existe...'
                    bat "docker network inspect %DOCKER_NETWORK% 1>nul 2>&1 || docker network create %DOCKER_NETWORK%"

                    echo 'Ejecutando base de datos MySQL...'
                    bat """
                        docker run -d --name %MYSQL_CONTAINER% --network %DOCKER_NETWORK% -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=cruddb -p %MYSQL_PORT%:3306 mysql:8 || exit 0
                    """

                    echo 'Si hay tests, agregarlos aquí...'
                    // Aquí puedes levantar el contenedor de tu app y correr tests
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy omitido, configurar según tu infraestructura...'
            }
        }
    }

    post {
        always {
            script {
                echo 'Post Actions: limpieza de contenedores'
                bat """
                    docker stop node_app %MYSQL_CONTAINER% adminer 2>nul || exit 0
                    docker rm node_app %MYSQL_CONTAINER% adminer 2>nul || exit 0
                """
            }
        }
    }
}
