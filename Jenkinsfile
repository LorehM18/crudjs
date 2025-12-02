pipeline {
    agent any

    environment {
        APP_IMAGE = 'crudjs-app'
        NETWORK = 'crud-network'
        MYSQL_CONTAINER = 'mysql_db'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/LorehM18/crudjs.git', branch: 'main'
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Limpiando contenedores y redes previas...'
                bat "docker stop node_app ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
                bat "docker rm node_app ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
                bat "docker network rm ${NETWORK} 2>nul || exit 0"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construyendo imagen Docker...'
                bat "docker build --no-cache -t ${APP_IMAGE} ."
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Creando red Docker si no existe...'
                bat "docker network inspect ${NETWORK} 1>nul 2>&1 || docker network create ${NETWORK}"

                echo 'Ejecutando base de datos MySQL...'
                bat """
                docker run -d --name ${MYSQL_CONTAINER} --network ${NETWORK} \
                -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=cruddb \
                -p 3307:3306 mysql:8
                """

                echo 'Esperando a que MySQL esté listo...'
                bat """
                timeout /t 15
                """

                echo 'Ejecutando tests en contenedor temporal...'
                bat "docker run --rm --network ${NETWORK} ${APP_IMAGE} npm test"
            }
        }
    }

    post {
        always {
            echo 'Post Actions: limpieza de contenedores y redes'
            bat "docker stop node_app ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
            bat "docker rm node_app ${MYSQL_CONTAINER} adminer 2>nul || exit 0"
            bat "docker network rm ${NETWORK} 2>nul || exit 0"
        }
    }
}
