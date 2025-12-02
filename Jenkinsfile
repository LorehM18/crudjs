pipeline {
    agent any

    environment {
        APP_IMAGE = "crudjs-app"
        MYSQL_CONTAINER = "mysql_db"
        NODE_CONTAINER = "node_app"
        NETWORK = "crud-network"
        MYSQL_ROOT_PASSWORD = "root123"
        MYSQL_DATABASE = "cruddb"
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
                    echo "Limpiando contenedores previos..."
                    bat "docker stop ${NODE_CONTAINER} ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
                    bat "docker rm ${NODE_CONTAINER} ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
                    bat "docker network rm ${NETWORK} 2>nul || exit 0"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Construyendo imagen Docker..."
                    bat "docker build --no-cache -t ${APP_IMAGE} ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Creando red Docker si no existe..."
                    bat "docker network inspect ${NETWORK} 1>nul 2>&1 || docker network create ${NETWORK}"

                    echo "Ejecutando base de datos MySQL..."
                    bat "docker run -d --name ${MYSQL_CONTAINER} --network ${NETWORK} -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -e MYSQL_DATABASE=${MYSQL_DATABASE} -p 3307:3306 mysql:8 || exit 0"

                    echo "Levantando contenedor de Node.js..."
                    bat "docker run -d --name ${NODE_CONTAINER} --network ${NETWORK} ${APP_IMAGE}"

                    echo "Ejecutando tests de la aplicación..."
                    bat "docker exec ${NODE_CONTAINER} npm test"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploy omitido, configurar según tu infraestructura..."
            }
        }
    }

    post {
        always {
            script {
                echo "Post Actions: limpieza de contenedores"
                bat "docker stop ${NODE_CONTAINER} ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
                bat "docker rm ${NODE_CONTAINER} ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
                bat "docker network rm ${NETWORK} 2>nul || exit 0"
            }
        }
    }
}
