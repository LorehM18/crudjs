pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/LorehM18/crudjs.git'
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Limpiando contenedores y redes previas...'
                bat '''
                docker stop node_app mysql_db adminer 2>nul || exit 0
                docker rm node_app mysql_db adminer 2>nul || exit 0
                docker network rm crud-network 2>nul || exit 0
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construyendo imagen Docker...'
                bat 'docker build --no-cache -t crudjs-app .'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Creando red Docker si no existe...'
                bat 'docker network inspect crud-network 1>nul 2>&1 || docker network create crud-network'

                echo 'Ejecutando base de datos MySQL...'
                bat 'docker run -d --name mysql_db --network crud-network -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=cruddb -p 3307:3306 mysql:8'

                echo 'Esperando a que MySQL esté listo...'
                // Espera ~15 segundos usando ping (funciona en Jenkins Windows)
                bat 'ping 127.0.0.1 -n 16 > nul'

                echo 'Levantando contenedor de Node.js...'
                bat 'docker run -d --name node_app --network crud-network crudjs-app'

                echo 'Ejecutando tests de la aplicación...'
                bat 'docker exec node_app npm test'
            }
        }
    }

    post {
        always {
            echo 'Post Actions: limpieza de contenedores y redes'
            bat '''
            docker stop node_app mysql_db adminer 2>nul || exit 0
            docker rm node_app mysql_db adminer 2>nul || exit 0
            docker network rm crud-network 2>nul || exit 0
            '''
        }
    }
}
