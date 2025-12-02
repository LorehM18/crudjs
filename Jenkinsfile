pipeline {
    agent any
    environment {
        APP_NAME = 'crudjs-app'
        NETWORK_NAME = 'crud-network'
        MYSQL_CONTAINER = 'mysql_db'
        NODE_CONTAINER = 'node_app'
        ADMINER_CONTAINER = 'adminer'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/LorehM18/crudjs.git', branch: 'main'
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    echo "Limpiando contenedores previos..."
                    // Ignora errores si los contenedores no existen
                    bat """
                    docker stop %NODE_CONTAINER% %MYSQL_CONTAINER% %ADMINER_CONTAINER% 2>nul || echo Contenedores no existían
                    docker rm %NODE_CONTAINER% %MYSQL_CONTAINER% %ADMINER_CONTAINER% 2>nul || echo Contenedores no existían
                    docker-compose down --remove-orphans --volumes 2>nul || echo No hay compose previo
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Construyendo imagen Docker..."
                    bat "docker build --no-cache -t %APP_NAME% ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Creando red Docker si no existe..."
                    bat "docker network inspect %NETWORK_NAME% >nul 2>&1 || docker network create %NETWORK_NAME%"
                    
                    echo "Ejecutando base de datos MySQL..."
                    bat """
                    docker run -d --name %MYSQL_CONTAINER% --network %NETWORK_NAME% -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_DATABASE=cruddb -p 3306:3306 mysql:8 || echo Puerto 3306 ocupado
                    """
                    
                    // Aquí podrías agregar ejecución de contenedor Node si necesitas probar la app
                    echo "Si hay tests, agregarlos aquí..."
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
                bat """
                docker stop %NODE_CONTAINER% %MYSQL_CONTAINER% %ADMINER_CONTAINER% 2>nul || echo Contenedores no existían
                docker rm %NODE_CONTAINER% %MYSQL_CONTAINER% %ADMINER_CONTAINER% 2>nul || echo Contenedores no existían
                """
            }
            // Evita que falle el pipeline si no hay resultados de tests
            junit allowEmptyResults: true, testResults: '**/test-results/*.xml'
        }
        success {
            echo 'Pipeline finalizado correctamente.'
        }
        failure {
            echo 'Pipeline falló - Revisar logs.'
        }
    }
}
