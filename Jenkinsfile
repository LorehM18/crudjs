pipeline {
    agent any

    environment {
        APP_NAME = 'crudjs-app'
        MYSQL_CONTAINER = 'mysql_db'
        NODE_CONTAINER = 'node_app'
        ADMINER_CONTAINER = 'adminer'
        NETWORK = 'crud-network'
        MYSQL_ROOT_PASSWORD = 'root123'
        MYSQL_DB = 'cruddb'
        MYSQL_PORT = '3307' // puerto cambiado para evitar conflicto
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
                    try {
                        bat "docker stop ${NODE_CONTAINER} ${MYSQL_CONTAINER} ${ADMINER_CONTAINER} || echo 'Contenedor no existía'"
                        bat "docker rm ${NODE_CONTAINER} ${MYSQL_CONTAINER} ${ADMINER_CONTAINER} || echo 'Contenedor no existía'"
                        bat "docker-compose down --remove-orphans --volumes || echo 'No compose previo'"
                    } catch(err) {
                        echo "Ignorado error de limpieza: ${err}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build --no-cache -t ${APP_NAME} ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Crear red si no existe
                    bat "docker network create ${NETWORK} 2>nul || echo 'Red ya existe'"

                    // Levantar MySQL
                    bat """docker run -d --name ${MYSQL_CONTAINER} \
                        --network ${NETWORK} \
                        -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
                        -e MYSQL_DATABASE=${MYSQL_DB} \
                        -p ${MYSQL_PORT}:3306 \
                        mysql:8"""

                    // Levantar Node App (opcional si quieres testear conexión)
                    bat """docker run -d --name ${NODE_CONTAINER} \
                        --network ${NETWORK} \
                        ${APP_NAME}"""
                }
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo "Despliegue pendiente / aquí iría el deploy real"
            }
        }
    }

    post {
        always {
            script {
                echo "Post Actions: limpieza de contenedores"
                try {
                    bat "docker stop ${NODE_CONTAINER} ${MYSQL_CONTAINER} ${ADMINER_CONTAINER} || echo 'Contenedor no existía'"
                    bat "docker rm ${NODE_CONTAINER} ${MYSQL_CONTAINER} ${ADMINER_CONTAINER} || echo 'Contenedor no existía'"
                } catch(err) {
                    echo "Ignorado error de limpieza: ${err}"
                }
            }

            // JUnit opcional
            junit allowEmptyResults: true, testResults: '**/test-results/*.xml'
        }

        failure {
            echo "Pipeline falló - Revisar logs"
        }
    }
}
